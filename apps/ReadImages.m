function [images, imNumb] = ReadImages( path, varargin )

% -------------------------------------------------------------------------
% Config input argument
% -------------------------------------------------------------------------
conf = struct( 'normalize',0, 'resize',[100 100], 'smooth',0 );
conf = getargs(conf, varargin);

% -------------------------------------------------------------------------
% Output argument
% -------------------------------------------------------------------------
fprintf('Reading the images...');tic

% Variables
imName = dir( [path '/*.jpg'] );
imNumb  = size(imName, 1);
if imNumb == 0
    imName = dir( [path '/*.png'] );
    imNumb  = size(imName, 1);
end
images = cell(imNumb, 1);

% -------------------------------------------------------------------------
% Read images and preprocess
% -------------------------------------------------------------------------
for img = 1 : imNumb
    
    images{img} = imread([ path '/' imName(img).name ]);
    
    if size(images{img}, 3) == 3 % RGB to gray
        images{img} = rgb2gray( images{img} );
    end
    images{img} = single( images{img} );
    
    if size(conf.resize,1)~=0
        images{img} = imresize(images{img}, conf.resize);
    end
    
    if conf.normalize == 1 % Normalize
        images{img} = images{img} / 255;
    end
    
    if conf.smooth ~= 0
        binSize = conf.smooth;
        images{img} = vl_imsmooth(images{img}, sqrt(binSize^2-.25));
    end
    
end

fprintf('Done!');
fprintf(['(elapsed time: ' num2str(toc) ' seconds)\n']);