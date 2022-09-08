
% ******************************* Defs and macros ****************************

% default number of sampled intervals per octave 
SIFT_INTVLS = 3;

% default sigma for initial gaussian smoothing 
SIFT_SIGMA = 1.6;

% default threshold on keypoint contrast |D(x)| 
SIFT_CONTR_THR = 0.04;

% default threshold on keypoint ratio of principle curvatures 
SIFT_CURV_THR = 10;

% double image size before pyramid construction? 
SIFT_IMG_DBL = 1;

% default width of descriptor histogram array 
SIFT_DESCR_WIDTH = 4;

% default number of bins per histogram in descriptor array 
SIFT_DESCR_HIST_BINS = 8;

% assumed gaussian blur for input image 
SIFT_INIT_SIGMA = 0.5;

% width of border in which to ignore keypoints 
SIFT_IMG_BORDER = 5;

% maximum steps of keypoint interpolation before failure 
SIFT_MAX_INTERP_STEPS = 5;

% default number of bins in histogram for orientation assignment 
SIFT_ORI_HIST_BINS = 36;

% determines gaussian sigma for orientation assignment 
SIFT_ORI_SIG_FCTR = 1.5;

% determines the radius of the region used in orientation assignment 
SIFT_ORI_RADIUS = 3.0 * SIFT_ORI_SIG_FCTR;

% number of passes of orientation histogram smoothing 
SIFT_ORI_SMOOTH_PASSES = 2;

% orientation magnitude relative to max that results in new feature 
SIFT_ORI_PEAK_RATIO = 0.8;

% determines the size of a single descriptor orientation histogram 
SIFT_DESCR_SCL_FCTR = 3.0;

% threshold on magnitude of elements of descriptor vector 
SIFT_DESCR_MAG_THR = 0.2;

% factor used to convert floating-point descriptor to unsigned char 
SIFT_INT_DESCR_FCTR = 512.0;
