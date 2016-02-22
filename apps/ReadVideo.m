function [images, imNumb] = ReadVideo( path )

fprintf('Reading the video...');tic

%
% Variables
imName = dir( [path '/*.jpg'] );
imNumb  = size(imName, 1);

%
% Output
images = cell(imNumb, 1);

%
% Read images and assign values to struct
for img = 1 : imNumb
    
    images{img} = imread([ path '/' imName(img).name ]);
    
    if size(images{img}, 3) == 3 % RGB to gray
        images{img} = rgb2gray( images{img} );
    end
    %images{img} = imresize(images{img}, [100 100]);
    images{img} = single( images{img} );
    
end

fprintf('Done!');
fprintf(['(elapsed time: ' num2str(toc) ' seconds)\n']);