Upper-body dataset V 1.1
=========================

Manuel J. Marin-Jimenez, Vittorio Ferrari and Andrew Zisserman


Description
~~~~~~~~~~~

This Upper-body dataset contains 96 images (at original resolution) extracted 
from the following 3 movies: "Run Lola run", "Pretty woman" and "Groundhog day". 
It has been used to train the upper-body detector used in [1] and available 
online at [2].

The samples have been gathered by annotating 3 points on each upper-body: 
the top of the head and the two armpits. Afterwards, a bounding box, based on 
the three marked points, was automatically defined around each upper-body instance.
In such a way that a small proportion of background was included in the cropped
window.

The upper-body detector used in [1] has been trained by scaling all images to 
a common size: 100x90. After that, in order to get more training samples, 
we have applied the following transformations (combined): mirroring, 
rotation (+-3 degrees) and shearing. We end up getting a total of 1152 images 
(12 times the original dataset, where a half is mirror images).

If you use this dataset in your publications, please cite [1].


References
~~~~~~~~~~

[1] Progressive Search Space Reduction for Human Pose Estimation
Ferrari, V., Marin-Jimenez, M. and Zisserman, A.
Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (2008) 

[2] Upper-body detector: http://www.robots.ox.ac.uk/~vgg/software/UpperBody/index.html


Support
~~~~~~~

For any query/suggestion/complaint or simply to say you like/use this dataset, just drop us an email


mjmarin@uco.es
ferrari@vision.ee.ethz.ch
az@robots.ox.ac.uk


Version history
~~~~~~~~~~~~~~~
1.1
- better directory structure

1.0
- initial release

