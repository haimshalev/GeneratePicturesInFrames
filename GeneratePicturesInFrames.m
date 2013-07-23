function [ ] = GeneratePicturesInFrames()
    
clc

%Add the helper functions to search path
addpath(genpath(char('HelperFunctions')));

%Clear the output dir if exist
if (exist('OutPutImages','dir'))
    rmdir(char('OutPutImages'),'s');
end
mkdir(char('OutPutImages'));

disp('---- Start Generating Pictures ----');

    %Load the frameing image
    framesList = GetAllFiles('InputFrames');
    CurrentFileName = framesList(1);
    frame = imread(CurrentFileName{1});  
    
disp('Creating Mask Matrix');
    %Creating a mask matrix
    mask = zeros(size(frame));
    
    %Setting edge size
    e  = 25; 
    
    for j=1:size(frame,1)
        for k = 1:size(frame,2)

            if ((frame(j,k,1) >71-e  && frame(j,k,1) <71 +e)&& ...
                (frame(j,k,2) > 255-e && frame(j,k,2) < 255+e) && ...
                (frame(j,k,3) > 0-e && frame(j,k,3) <0+e))
                mask(j,k,1) = 1;
                mask(j,k,2) = 1;
                mask(j,k,3) = 1;
            end

        end
    end
    
    %Load the input images
    fileList = GetAllFiles('InputImages');
    [fileListSize,~] = size(fileList);
    
    %outputMatrix is from the size of 8 frames
    outPutMatrix = [];
    
    %iterate over all photos
    for i=1:fileListSize
        
        disp(['Merging Picture ' num2str(i) ' out of ' num2str(fileListSize)]);
        
        CurrentFileName = fileList(i);
  
        img = imread(CurrentFileName{1});

        %Scale the input image to the frame size
        img = ScaleImage(img,size(frame));

        %The new image will be built from the nonzero cells in the frame image 
        newImage = frame;

        %Taking the image only where the input cells are zero
        newImage(find(mask)) = img(find(mask));
        
        

        %Create 2X4 Page
        if(mod(i,2) == 1)
            lineMatrix = newImage;
        else
            lineMatrix = [lineMatrix newImage];
            outPutMatrix = [outPutMatrix ; lineMatrix];
        end
        
        %If we created 8 pictures save the page
        if (mod(i,8) == 0)
            
            disp(['Produce page number ' num2str(i/8)]);
            
            imwrite(outPutMatrix,['OutPutImages/' num2str(i/8) '.jpg'],'jpg');
            outPutMatrix = [];
            
        end
        
        
    end
    
    if (mod(i,8) ~= 0)
        disp('Filling Empty pictures');
        for i=mod(i,8)+1:8
            %If we don't have 8 pictures
            if(mod(i,2) == 1)
                lineMatrix = ones(size(frame)).*255;
            else
                lineMatrix = [lineMatrix ones(size(frame)).*255];
                outPutMatrix = [outPutMatrix ; lineMatrix];
            end
        end
        
        disp('Produce the last page');
        imwrite(outPutMatrix,'OutPutImages/last.jpg','jpg');
        
    end
    
    disp('Finished Creating page. The pages will be in the OutputImages folder');
    disp('Thanks for using');
end