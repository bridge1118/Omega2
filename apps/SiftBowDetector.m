function [pdt_label] = SiftBowDetector(im, vocabulary, model)

vocabulary_size = size(vocabulary,2);
doSmooth = 0;
if (doSmooth)
    binSize = 8;
    imsV{img} = vl_imsmooth(imsV{img}, sqrt(binSize^2-.25));
end

% extracting feature
[keypts, descrs] = vl_sift( im, 'FloatDescriptors' );
descrs = ( normalize_sift(descrs') )';


d2 = EuclideanDistance(descrs', vocabulary');
[minz, index] = min(d2', [], 1);
bow = hist(index,(1:vocabulary_size));
%bow = bow';

label = ones(1,1);
[pdt_label, acry,dec_vals] = svmpredict(label, bow, model, '-q');
