%%-------------------------------------------------------------------------
%%              8.  GridCat MODEL SETTINGS
%% Stangl, M.*, Shine, J.*, & Wolbers, T. (2017). The GridCAT: A toolbox for 
%% automated analysis of human grid cell codes in fMRI. Frontiers in 
%% Neuroinformatics, 11:47. https://doi.org/10.3389/fninf.2017.00047

e3_cfg_gen;

% TR (inter-scan-interval) in seconds
GCcfg.GLM.TR = 1.5;

% x-fold symmetry value that the model is testing for
GCcfg.GLM.xFoldSymmetry = 6;

% Masking threshold
GCcfg.GLM.maskingThreshold = 0.8;

% Microtime onset & resolution
GCcfg.GLM.microtimeOnset = 8;
GCcfg.GLM.microtimeResolution = 16;

% HPF per run
GCcfg.GLM.HPF_perRun = [128, 128];

% Model derivatives
%   [0 0] ... do not model derivatives
%   [1 0] ... time derivatives
%   [1 1] ... model time and dispersion derivatives
GCcfg.GLM.derivatives = [0 0]; 

% Optional: Do you want to display the design matrix after it has been created?
% The design matrix will not be displayed, if this settings is not defined
% use 0 or 1
GCcfg.GLM.dispDesignMatrix = 0;


%% GLM1

% Specify GLM number
%   1 ... estimate grid orientations voxelwise
%   2 ... test grid orientations
GCcfg.GLMnr = 1;

% Specify data directory for this GLM
% The directory will be created if it does not exist
GCcfg.GLM.dataDir = '/home/ExampleData/GridCAT_output/GLM1';

% Which grid events should be used for this GLM?
%	2 ... use the first half of grid events per run
%	3 ... use the second half of grid events per run
%	4 ... use odd grid events within each run
%	5 ... use even grid events within each run
%	6 ... use all grid events of odd runs
%	7 ... use all grid events of even runs
%	8 ... use all grid events of all runs
%	9 ... use specification from event-table
GCcfg.GLM.eventUsageSpecifier = 2;

% Include unused grid events in the model?
%	0 ... grid events that are not used for this GLM will not be included in the model
%	1 ... grid events that are not used for this GLM will not be included in the model
GCcfg.GLM.keepUnusedGridEvents = 1;

% Specify GLM1 using the current configuration (cfg)
specifyGLM(cfg);

% Estimate GLM1 using the current configuration (cfg)
estimateGLM(cfg);


%% GLM2

% Specify GLM number
%   1 ... estimate grid orientations voxelwise
%   2 ... test grid orientations
GCcfg.GLMnr = 2;

% Specify data directory for this GLM
% The directory will be created if it does not exist
GCcfg.GLM.dataDir = '/home/ExampleData/GridCAT_output/GLM2';

% Which grid events should be used for this GLM?
%	2 ... use the first half of grid events per run
%	3 ... use the second half of grid events per run
%	4 ... use odd grid events within each run
%	5 ... use even grid events within each run
%	6 ... use all grid events of odd runs
%	7 ... use all grid events of even runs
%	8 ... use all grid events of all runs
%	9 ... use specification from event-table
GCcfg.GLM.eventUsageSpecifier = 3;

% Include unused grid events in the model?
%	0 ... grid events that are not used for this GLM will not be included in the model
%	1 ... grid events that are not used for this GLM will not be included in the model
GCcfg.GLM.keepUnusedGridEvents = 1;

% GLM2 tests the estimated grid orientations that were estimated in GLM1.
% Specify here, where the GLM1 output is stored (i.e., the GLM1 data directory)
GCcfg.GLM.GLM1_resultsDir = '/home/ExampleData/GridCAT_output/GLM1';

% Specify binary ROI mask
% Nonzero voxels within this mask are used to calculate the mean grid orientation.
% This ROI mask must be aligned with the functional scans.
GCcfg.GLM.GLM2_roiMask_calcMeanGridOri = {'/home/ExampleData/ROI_masks/ROI_entorhinalCortex_RH.nii'};

% Use different weighting for individual voxels within the ROI, when estimating the mean grid orientation?
%   0 ... all voxels within the ROI will get the same weighting
%   1 ... voxels will be weighted differently, according to their estimated firing amplitude in GLM1
GCcfg.GLM.GLM2_useWeightingForVoxels = 1;

% Calculate the mean grid orientation within an ROI across all runs or separately for each run?
%   0 ... the mean grid orientation is calculated for each run separately
%   1 ... the mean grid orientation is averaged across all runs
GCcfg.GLM.GLM2_averageMeanGridOriAcrossRuns = avgOriAcrossRuns_flag;

% Which type of regressor should be included for grid events?
%   'pmod' ... one regressor with a parametric modulation
%   'aligned_misaligned' ... one regressor for events that are aligned with the mean grid orientation
%                            and one regressor for misaligned events
%   'aligned_misaligned_multiple' ... one regressor for each orientation, for which either a positive peak (for aligned events)
%                                     or a negative peak (for misaligned events) in the BOLD signal is expected 
GCcfg.GLM.GLM2_gridRegressorMethod = 'aligned_misaligned';
    
% Specify GLM2 using the current configuration (cfg)
specifyGLM(cfg);

% Estimate GLM2 using the current configuration (cfg)
estimateGLM(cfg);


%% EXPORT GRID METRICS

% Specify ROI masks, for which the grid metrics are calculated and exported
ROI_masks = {
    '/home/ExampleData/ROI_masks/ROI_entorhinalCortex_RH.nii'
    '/home/ExampleData/ROI_masks/ROI_entorhinalCortex_LH.nii'
    };

% Specify where the GLM1 and GLM2 output is stored
GLM1dir = '/home/ExampleData/GridCAT_output/GLM1';
GLM2dir = '/home/ExampleData/GridCAT_output/GLM2';

% Specify where the grid metric output should be saved
output_file = {'/home/ExampleData/GridCAT_output/GridCAT_grid_metrics.txt'};
