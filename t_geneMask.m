close all;clear all;clc

addpath( genpath('apps') );
addpath( genpath('imgs') );

[imsP, imsPn] = ReadImages('imgs/posAll', 'resize', []);
[imsT, imsTn] = ReadImages('imgs/posAllMask', 'resize', []);

img = 94;

for img = 1 : imsPn
    imsT{img}( find(imsT{img}<10) ) = 0;
    imsT{img}( find(imsT{img}) ) = 1;
end

save 'mdls/posAllMask.mat' imsT imsTn