function [ imsT ] = ResizeTm( imsT, size )

imsTn = length( imsT );

for img = 1 : imsTn
    imsT{img} = imresize( imsT{img}, size );
    imsT{img}( find(imsT{img}) ) = 1;
end
