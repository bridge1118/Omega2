%
% Training stage
%
disp('----------Training Stage----------');
%load('mdls/posAllTem.mat');

%% Step 1
% -------------------------------------------------------------------------
% Load positive & negative training data
% -------------------------------------------------------------------------

[imsP, imsPn] = ReadImages(train_pos, 'resize', imSize);
[imsN, imsNn] = ReadImages(train_neg, 'resize', imSize);

%% Step 2
% -------------------------------------------------------------------------
% Extract dsift features from the training images
% -------------------------------------------------------------------------

fprintf('Pre-processing & Extracting features...');tic
if exist('mdls/m5_Var_dsiftP.mat') & reTrain==0
    load('mdls/m5_Var_dsiftP.mat')
else
for img = 1 : imsPn
    [dsiftP(img).keypts,dsiftP(img).descrs] = ...
        vl_dsift(imsP{img},'FloatDescriptors');
    dsiftP(img).descrs = ( normalize_sift(dsiftP(img).descrs') )';
    trainDsiftp{img} = dsiftP(img).descrs;
end
trainDsiftp = cat(4, trainDsiftp{:}) ;
save 'mdls/m5_Var_dsiftP.mat' dsiftP trainDsiftp
clear img
end % endif
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 2.1
% -------------------------------------------------------------------------
% Filt non-human keypoints
% -------------------------------------------------------------------------
%

if isFiltOut == 1
imsT = ResizeTm( imsT, imSize );
fprintf('Filt non-human keypoints...');tic
instanceP = [];
for img = 1 : imsPn
    tmpKo = dsiftP(img).keypts;
    dsiftP(img).keypts(1:2,:) = round( dsiftP(img).keypts(1:2,:) );
    
    tmpK = []; tmpD = [];
    for idx = 1 : length(dsiftP(img).keypts)
        if imsT{img}(dsiftP(img).keypts(2,idx),dsiftP(img).keypts(1,idx))==1
            tmpK = cat(2, tmpK, tmpKo(:,idx));
            tmpD = cat(2, tmpD, dsiftP(img).descrs(:,idx));
        end
    end
    dsiftP(img).keypts = tmpK;
    dsiftP(img).descrs = tmpD;
    instanceP = cat( 2, instanceP, dsiftP(img).descrs );
end
clear img idx tmpD tmpK tmpKo imsT imsTn
save 'mdls/m4_Var_siftP.mat' siftP instanceP
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);
end
%}

%% Step 3
% -------------------------------------------------------------------------
% Learn a simple dsift template model
% -------------------------------------------------------------------------

if exist('mdls/m5_Mdl_meanTemplate.mat') & reTrain==0
    load('mdls/m5_Mdl_meanTemplate.mat')
else
meanTemplate = mean(trainDsiftp, 4);
save 'mdls/m5_Mdl_meanTemplate.mat' meanTemplate
end

%% Step 4
% -------------------------------------------------------------------------
% Learn a BoF vocabulary
% -------------------------------------------------------------------------

fprintf('Learning bag of feature vocabulary...');tic
if exist('mdls/m5_Mdl_vocabulary.mat') & reTrain==0
    load('mdls/m5_Mdl_vocabulary.mat')
else
vocabulary_size = 15;
vocabulary = vl_kmeans(meanTemplate, vocabulary_size);
save 'mdls/m5_Mdl_vocabulary.mat' vocabulary vocabulary_size
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 5
% -------------------------------------------------------------------------
% Learn positive instance
% -------------------------------------------------------------------------

fprintf('Learning positive instance...');tic
if exist('mdls/m5_Var_bowP.mat') & reTrain==0
    load('mdls/m5_Var_bowP.mat')
else
for img = 1 : imsPn
    d2 = EuclideanDistance(dsiftP(img).descrs', vocabulary');
    [minz, index] = min(d2', [], 1);
    bowP(img,:) = hist( index, (1:vocabulary_size) );
end
clear d2 minz index img
save 'mdls/m5_Var_bowP.mat' bowP
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 6
% -------------------------------------------------------------------------
% Extract negative dsift features
% -------------------------------------------------------------------------

fprintf('Pre-processing & Extracting features(neg)...');tic
if exist('mdls/m5_Var_siftN.m') & reTrain==0
    load('mdls/m5_Var_siftN.mat')
else
for img = 1 : imsNn
    [dsiftN(img).keypts,dsiftN(img).descrs] = ...
        vl_sift(imsN{img},'FloatDescriptors');
    dsiftN(img).descrs = ( normalize_sift(dsiftN(img).descrs') )';
end
clear img
save 'mdls/m5_Var_siftN.mat' dsiftN 
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 6
% -------------------------------------------------------------------------
% Learn negative instance
% -------------------------------------------------------------------------

fprintf('Assigning BoF instance(neg)...');tic
if exist('mdls/m5_Var_bowN.mat') & reTrain==0
    load('mdls/m5_Var_bowN.mat')
else
for img = 1 : imsNn
    d2 = EuclideanDistance(single(dsiftN(img).descrs'), vocabulary');
    [minz, index] = min(d2', [], 1);
    bowN(img,:) = hist(index,(1:vocabulary_size));
end
clear d2 minz index img
save 'mdls/m5_Var_bowN.mat' bowN
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 7
% -------------------------------------------------------------------------
% Train SVM model
% -------------------------------------------------------------------------

fprintf('Training SVM...\n');tic
labels = cat(1, ones(imsPn,1), zeros(imsNn,1));
bow = cat(1, bowP, bowN);
model = svmtrain(labels, bow, '-c 1 -g 0.07');
save 'mdls/m5_Mdl_bowModel.mat' model
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Save Workspace
save 'mdls/m5_Var_trainWorkspace.mat'
