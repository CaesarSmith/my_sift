close all;
% clear all;
clc;

img1 = imread('F:\Programs\Matlab\SIFT\data\scene.tiff');
img2 = imread('F:\Programs\Matlab\SIFT\data\book.tiff');

features1 = sift_features(img1);
features2 = sift_features(img2);
% load features1.mat
% load features2.mat

%% extract pos and feature vector from features1
pos1 = zeros(length(features1), 2);
descriptor1 = zeros(length(features1), features1(1).d);
for i = 1 : length(features1)
    pos1(i, 1) = features1(i).x;
    pos1(i, 2) = features1(i).y;
    descriptor1(i, :) = features1(i).descr;
end

%% extract pos and feature vector from features2
pos2 = zeros(length(features2), 2);
descriptor2 = zeros(length(features2), features2(1).d);
for i = 1 : length(features2)
    pos2(i, 1) = features2(i).x;
    pos2(i, 2) = features2(i).y;
    descriptor2(i, :) = features2(i).descr;
end

%% draw extracted feature point
figure(), imshow(img1, []); hold on; plot(pos1(:, 1), pos1(:, 2), 'g+'); title('original image(scene)');
figure(), imshow(img2, []); hold on; plot(pos2(:, 1), pos2(:, 2), 'g+'); title('original image(book)');


%% match features using intrinsic matchFeatures in matlab
[indexPairs, matchmetric] = matchFeatures(descriptor1, descriptor2, 'MaxRatio', 0.49, 'MatchThreshold', 100);
matchedPoints1 = pos1(indexPairs(:, 1), :);
matchedPoints2 = pos2(indexPairs(:, 2), :);
scnsize = get(0,'ScreenSize'); 
figure('Name','Matched Points Between Image Pairs');
set(gcf, 'position', [50, 50, scnsize(3) - 150, scnsize(4) - 150]); subplot('Position', [0.02, 0.02, 0.96, 0.96]);
showMatchedFeatures(img1, img2, matchedPoints1, matchedPoints2, 'montage'); title('match using nearest neighbour indexing');

%% use ransac to filter out outliers
H = FSC(matchedPoints2, matchedPoints1, 'affine', 2);
Y_ = H * [matchedPoints2, ones(size(matchedPoints2, 1), 1)]';
Y_(1, :) = Y_(1, :) ./ Y_(3, :);
Y_(2, :) = Y_(2, :) ./ Y_(3, :);
E = sqrt(sum((Y_(1:2,:) - matchedPoints1').^2));
inliersIndex = E < 5;
cleanedPoints1 = matchedPoints1(inliersIndex, :);
cleanedPoints2 = matchedPoints2(inliersIndex, :);
figure, showMatchedFeatures(img1, img2, cleanedPoints1, cleanedPoints2, 'montage');
title('matched points after outliers removing with ransac');

%% transform reference in the coordinate of orignal image1
image_fusion2(img1, img2, double(H));
