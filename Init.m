% VLFEAT required
try
    vl_version verbose    
catch
    run('~/Documents/MATLAB/Apps/vlfeat-0.9.20/toolbox/vl_setup')
end
addpath( genpath('apps') );
addpath( genpath('imgs') );
addpath( genpath('libs') );

reTrain = 1;
vocabulary_size = 30;
imSize = [100 100];

% noise filter folder
isFiltOut = 0;
%load('mdls/posAllMask.mat');
%load('mdls/posAll2Mask.mat');

% pos
%train_pos = 'imgs/posAll';
%train_pos = 'imgs/posAll2';
%train_pos = '/Volumes/Intel/learning data/training/positive';

% neg
train_neg = 'imgs/negAll';
%train_neg = '/Volumes/Intel/learning data/training/negative';

% test
%testFolder= 'imgs/test_neg';
testFolder= 'imgs/test_bridge';
%testFolder= 'imgs/pedestrian_nuu';
%testFolder= '/Volumes/Intel/learning data/testing/positive';
%testFolder= '/Volumes/Intel/learning data/testing/negative';