close all; clear all; clc


addpath( genpath('imgs') );
addpath( genpath('apps') );

train_pos = '/Volumes/Intel/posAll2';

[imsP, imsPn] = ReadImages(train_pos, 'resize',[400 400]);

idx = 0;
minsize = 1000;
for img = 1 : imsPn
    s = size(imsP{img});
    m = min( s(:) );
    if m < minsize
        minsize = m;
        idx = img;
    end
end


