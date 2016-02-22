close all;clear all;clc

run('~/Documents/MATLAB/Apps/vlfeat-0.9.20/toolbox/vl_setup')

 
train_pos = 'imgs/posAll';
[imsP, imsPn] = ReadImages(train_pos);
imsPn = 130;

for img = 1 : imsPn
    [ siftP(img).keypts, siftP(img).descrs ] = vl_sift(imsP{img},'FloatDescriptors');
end

%%%%%%%%%%%%%%%%%%%%%
load('mdls/posAllTem.mat');
%imsT = ResizeTm( imsT, [100 100] );
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
%}
%%%%%%%%%%%%%%%%%%%%%


for img = 1 : 2 : imsPn

    [matches, mscore] = vl_ubcmatch(siftP(img).keypts, siftP(img+1).keypts);

    Ia = uint8( imsP{img}  );
    Ib = uint8( imsP{img+1});

    figure ; clf ;
    imagesc(cat(2, Ia, Ib)) ;

    xa = siftP(img).keypts(1,matches(1,:)) ;
    xb = siftP(img+1).keypts(1,matches(2,:)) + size(Ia,2) ;
    ya = siftP(img).keypts(2,matches(1,:)) ;
    yb = siftP(img+1).keypts(2,matches(2,:)) ;

    hold on ;
    h = line([xa ; xb], [ya ; yb]) ;
    set(h,'linewidth', 1, 'color', 'b') ;

    vl_plotframe(siftP(img).keypts(:,matches(1,:))) ;
    siftP(img+1).keypts(1,:) = siftP(img+1).keypts(1,:) + size(Ia,2) ;
    vl_plotframe(siftP(img+1).keypts(:,matches(2,:))) ;
    axis image off ;
    hold off

    saveas(gcf,['/Users/ful6ru04/Desktop/siftMatch_i' num2str(img) '.jpg'])

end

