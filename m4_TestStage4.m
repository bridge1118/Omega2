% Test satge

%% Test Stage

load 'mdls/m4_Mdl_bowModel.mat'
load 'mdls/m4_Mdl_vocabulary.mat'

disp('----------Testing Stage----------');
[imsV, imsVn] = ReadImages(testFolder);
%imsVn = 1;

for img = 1 : imsVn
    % extracting feature
    [siftV(img).keypts,siftV(img).descrs]=vl_sift(imsV{img},'FloatDescriptors');
    siftV(img).descrs = ( normalize_sift(siftV(img).descrs') )';
    
    
    d2 = EuclideanDistance(siftV(img).descrs', vocabulary');
    [minz, index] = min(d2', [], 1);
    bowV(:,img)=hist(index,(1:vocabulary_size));
    
end
clear img binSize
bowV = bowV';
%bowV = ( do_normalize(bowV,1) )';

labelsV = ones(imsVn,1);
[pdt_label, acry,dec_vals] = svmpredict(labelsV, bowV, model);
