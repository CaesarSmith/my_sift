/*
  Detects SIFT features in two images and finds matches between them.

  Copyright (C) 2006-2012  Rob Hess <rob@iqengines.com>

  @version 1.1.2-20100521
*/

#include "sift.h"
#include "imgfeatures.h"
#include "kdtree.h"
#include "utils.h"
#include "xform.h"

//#include <cv.h>
//#include <cxcore.h>
//#include <highgui.h>
#include <opencv2/opencv.hpp>

#include <stdio.h>

/* the maximum number of keypoint NN candidates to check during BBF search */
#define KDTREE_BBF_MAX_NN_CHKS 200

/* threshold on squared ratio of distances between NN and 2nd NN */
#define NN_SQ_DIST_RATIO_THR 0.49

char *im1 = "..\\..\\data\\scene.tiff";
char *im2 = "..\\..\\data\\book.tiff";

int main(int argc, char **argv)
{
  cv::Mat img1, img2, stacked;
  struct feature *feat1, *feat2, *feat;
  struct feature **nbrs;
  struct kd_node *kd_root;
  cv::Point2d pt1, pt2;
  double d0, d1;
  int n1, n2, k, i, m = 0;

  img1 = cv::imread(im1, -1);
  if (img1.empty())
    fatal_error("unable to load image from %s", im1);
  img2 = cv::imread(im2, -1);
  if (img2.empty())
    fatal_error("unable to load image from %s", im2);
  stacked = stack_imgs(img1, img2);

  fprintf(stderr, "Finding features in %s...\n", im1);
  n1 = sift_features(img1, &feat1);
  fprintf(stderr, "Finding features in %s...\n", im2);
  n2 = sift_features(img2, &feat2);
  fprintf(stderr, "Building kd tree...\n");
  kd_root = kdtree_build(feat2, n2);
  for (i = 0; i < n1; i++)
  {
    feat = feat1 + i;
    k = kdtree_bbf_knn(kd_root, feat, 2, &nbrs, KDTREE_BBF_MAX_NN_CHKS);
    if (k == 2)
    {
      d0 = descr_dist_sq(feat, nbrs[0]);
      d1 = descr_dist_sq(feat, nbrs[1]);
      if (d0 < d1 * NN_SQ_DIST_RATIO_THR)
      {
        pt1 = cv::Point2d(cvRound(feat->x), cvRound(feat->y));
        pt2 = cv::Point2d(cvRound(nbrs[0]->x), cvRound(nbrs[0]->y));
        // pt2.y += img1.rows;
        pt2.x += img1.cols;
        cv::line(stacked, pt1, pt2, CV_RGB(255, 0, 255), 1, 1, 0);
        m++;
        feat1[i].fwd_match = nbrs[0];
      }
    }
    free(nbrs);
  }

  fprintf(stderr, "Found %d total matches\n", m);
  display_big_img(stacked, "Matches");
  cv::waitKey(0);
  cv::destroyWindow("Matches");

  /*
    UNCOMMENT BELOW TO SEE HOW RANSAC FUNCTION WORKS

    Note that this line above:

    feat1[i].fwd_match = nbrs[0];

    is important for the RANSAC function to work.
  */
  {
    cv::Matx33d *H;
    H = ransac_xform(feat1, n1, FEATURE_FWD_MATCH, lsq_homog, 4, 0.01,
                     homog_xfer_err, 3.0, NULL, NULL);
    if (H)
    {

      cv::Mat xformed = cv::Mat::zeros(img2.rows, img2.cols, CV_8UC3);
      cv::warpPerspective(img1, xformed, *H, cv::Size(img1.cols, img1.rows),
                          CV_INTER_LINEAR + CV_WARP_FILL_OUTLIERS, IPL_BORDER_CONSTANT);

      cv::namedWindow("Xformed", 1);
      cv::imshow("Xformed", xformed);
      cv::waitKey(0);
    }
  }

  kdtree_release(kd_root);
  free(feat1);
  free(feat2);
  return 0;
}
