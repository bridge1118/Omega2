%
% Training stage
% !! discard extracting 'ellipse' area as features
%
disp('----------Training Stage----------');

%% Step 1
% -------------------------------------------------------------------------
% Load positive & negative training data
% -------------------------------------------------------------------------

[imsP, imsPn] = ReadImages(train_pos, 'resize', imSize);
[imsN, imsNn] = ReadImages(train_neg, 'resize', imSize);

%% Step 2
% -------------------------------------------------------------------------
% Extract siftP features from positive training images
% -------------------------------------------------------------------------

fprintf('Pre-processing & Extracting features...');tic
if exist('mdls/m4_Var_siftP.mat') & reTrain==0
    load('mdls/m4_Var_siftP.mat')
else
instanceP=[];
for img = 1 : imsPn
    [ siftP(img).keypts, siftP(img).descrs ] = ...
        vl_sift(imsP{img},'FloatDescriptors');
    siftP(img).descrs = ( normalize_sift(siftP(img).descrs') )';
    instanceP = cat( 2, instanceP, siftP(img).descrs );
end
clear img
save 'mdls/m4_Var_siftP.mat' siftP instanceP
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 2.1
% -------------------------------------------------------------------------
% Filt non-human keypoints
% -------------------------------------------------------------------------

if isFiltOut == 1
imsT = ResizeTm( imsT, imSize );
fprintf('Filt non-human keypoints...');tic
instanceP = [];
for img = 1 : imsPn
    tmpKo = siftP(img).keypts;
    siftP(img).keypts(1:2,:) = round( siftP(img).keypts(1:2,:) );
    
    tmpK = []; tmpD = [];
    for idx = 1 : length(siftP(img).keypts)
        if imsT{img}(siftP(img).keypts(2,idx),siftP(img).keypts(1,idx))==1
            tmpK = cat(2, tmpK, tmpKo(:,idx));
            tmpD = cat(2, tmpD, siftP(img).descrs(:,idx));
        end
    end
    siftP(img).keypts = tmpK;
    siftP(img).descrs = tmpD;
    instanceP = cat( 2, instanceP, siftP(img).descrs );
end
clear img idx tmpD tmpK tmpKo imsT imsTn
save 'mdls/m4_Var_siftP.mat' siftP instanceP
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);
end
%}

%% Step 3
% -------------------------------------------------------------------------
% Learn BoF vocabulary
% -------------------------------------------------------------------------

fprintf('Training bag of feature vocabulary...');tic
if exist('mdls/m4_Mdl_vocabulary.mat') & reTrain==0
    load('mdls/m4_Mdl_vocabulary.mat')
else
vocabulary = vl_kmeans(instanceP,vocabulary_size);
save 'mdls/m4_Mdl_vocabulary.mat' vocabulary vocabulary_size
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 4
% -------------------------------------------------------------------------
% Learn positive instance
% -------------------------------------------------------------------------

fprintf('Assigning BoF instance...');tic
if exist('mdls/m4_Var_bowP.mat') & reTrain==0
    load('mdls/m4_Var_bowP.mat')
else
for img = 1 : imsPn
    d2 = EuclideanDistance(siftP(img).descrs', vocabulary');
    [minz, index] = min(d2', [], 1);
    bowP(img,:)=hist(index,(1:vocabulary_size));
end
clear d2 minz index img
%bowP = ( do_normalize(bowP,1) )';
save 'mdls/m4_Var_bowP.mat' bowP
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 5
% -------------------------------------------------------------------------
% Extract negative dsift features
% -------------------------------------------------------------------------

fprintf('Pre-processing & Extracting features(neg)...');tic
if exist('mdls/m4_Var_siftN.m') & reTrain==0
    load('mdls/m4_Var_siftN.mat')
else
for img = 1 : imsNn
    [ siftN(img).keypts, siftN(img).descrs ] = ...
        vl_sift(imsN{img},'FloatDescriptors');
    siftN(img).descrs = ( normalize_sift(siftN(img).descrs') )';
end
clear binSize img
save 'mdls/m4_Var_siftN.mat' siftN 
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 6
% -------------------------------------------------------------------------
% Learn negative instance
% -------------------------------------------------------------------------

fprintf('Assigning BoF instance...');tic
if exist('mdls/m4_Var_bowN.mat') & reTrain==0
    load('mdls/m4_Var_bowN.mat')
else
for img = 1 : imsNn
    d2 = EuclideanDistance(single(siftN(img).descrs'), vocabulary');
    [minz, index] = min(d2', [], 1);
    bowN(img,:)=hist(index,(1:vocabulary_size));
end
clear d2 minz index img
%bowN = ( do_normalize(bowN,1) )';
save 'mdls/m4_Var_bowN.mat' bowN
end
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Step 7
% -------------------------------------------------------------------------
% Train SVM model
% -------------------------------------------------------------------------

fprintf('Training SVM...\n');tic
labels = cat( 1, ones(imsPn,1), zeros(imsNn,1) );
bow = cat( 1, bowP, bowN );
model = svmtrain(labels, bow, '-c 1 -g 0.07');
save 'mdls/m4_Mdl_bowModel.mat' model
fprintf(['Done! ' '(elapsed time: ' num2str(toc) ' seconds)\n']);

%% Save Workspace
save 'mdls/m4_Var_trainWorkspace.mat'
