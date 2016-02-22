close all;clear all;clc

run('~/Documents/MATLAB/Apps/vlfeat-0.9.20/toolbox/vl_setup')
addpath( genpath('apps') );

%train_pos = '/Volumes/Intel/posAll2';
train_pos = '/Volumes/Intel/learning data/training/positive';
[imsP, imsPn] = ReadImages(train_pos, 'resize', []);
load('mdls/m4_Var_siftP.mat');
for img = 1 : imsPn
    
    %[ siftP(img).keypts, siftP(img).descrs ] = ...
    %    vl_sift(imsP{img},'FloatDescriptors');
    %siftP(img).descrs = ( normalize_sift(siftP(img).descrs') )';
    
    figure
    imshow( uint8(imsP{img}) ), hold on
    
    perm = randperm( size(siftP(img).keypts,2) );
    sel = perm( 1 : size(perm,2) );
    h1 = vl_plotframe( siftP(img).keypts(:,sel) );
    h2 = vl_plotframe( siftP(img).keypts(:,sel) );
    set( h1, 'color', 'k', 'linewidth', 3 );
    set( h2, 'color', 'y', 'linewidth', 2 );
    
    hold off
    
    %set(gca,'XTick',[]) % Remove the ticks in the x axis
    %set(gca,'YTick',[]) % Remove the ticks in the y axis
    %set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,['/Users/ful6ru04/Desktop/sift_i' num2str(img) '.jpg'])
    
    close all
    
end