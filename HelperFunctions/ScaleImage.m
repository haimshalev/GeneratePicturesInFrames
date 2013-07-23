function [ ScaledImg ] = ScaleImage( InputImg , s )
%SCALEIMAGE - Scale the input image to the specified size or to the default
%size specified in the configuration file

%if the size parameter doesn't set we get it from the configuration file

%scaling the image accoding to the specified ratio of the first dimension
ScaledImg = imresize(InputImg(:,:,1),s(1:2));
ScaledImg(:,:,2) = imresize(InputImg(:,:,2),s(1:2));
ScaledImg(:,:,3) = imresize(InputImg(:,:,3),s(1:2));
end

