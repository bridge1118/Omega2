%
% Testing satge
%
disp('----------Testing Stage----------');

%% Step 1
% -------------------------------------------------------------------------
% Load models
% -------------------------------------------------------------------------

load 'mdls/m5_Mdl_bowModel.mat'
load 'mdls/m5_Mdl_meanTemplate.mat'
load 'mdls/m5_Mdl_vocabulary.mat'

%meanTemplate2 = reshape(meanTemplate',41,41,128);

%% Step 2
% -------------------------------------------------------------------------
% Read testing images
% -------------------------------------------------------------------------

[imsV, imsVn] = ReadImages(testFolder);
% imsV{1} = imread([testFolder '/955.jpg']);
% imsV{1} = rgb2gray(imsV{1});
% imsV{1} = imresize(imsV{1}, .25);
% imsV{1} = single(imsV{1});
% imsVn = 1;

%% Step 3
% -------------------------------------------------------------------------
% Extract features
% -------------------------------------------------------------------------

for img = 1 : imsVn
    [dsiftV(img).keypts, dsiftV(img).descrs] = ...
        vl_dsift(imsV{img},'FloatDescriptors');
    dsiftV(img).descrs = ( normalize_sift(dsiftV(img).descrs') )';
    
%     descrs = reshape(dsiftV(img).descrs',111,151,128);
%     scores = vl_nnconv( descrs, meanTemplate2, [] );
%     return
    d2 = EuclideanDistance(dsiftV(img).descrs', vocabulary');
    [minz, index] = min(d2', [], 1);
    bowV(img,:) = hist(index,(1:vocabulary_size));
end
clear img binSize

labelsV = ones(imsVn,1);
[pdt_label, acry,dec_vals] = svmpredict(labelsV, bowV, model);
