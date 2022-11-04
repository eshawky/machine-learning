clc

%we need to loop on all folders and files and do the same pre-processing
%%%%%%%%%%%%%%%%%%%%%%start with gesture 'A' folder%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:1
    %read image from its folder
    folder_name = 'D:\\3.Pre-PHD Courses\\Optimization_Dr.Hoda\\6.Project\\6.My Coding Work\\1.MatlbWork\\SampleData\\' ;
    path = strcat(folder_name,'hand','.ppm');
    imagepath = strcat(path);
    original = imread(imagepath);
    
    %Convert RGB color values to YCbCr color space to get skin color regions
    %converted = rgb2hsv(original);
    %converted = rgb2ycbcr(  gpuArray(original) );
    converted = rgb2ycbcr(original);
    [y c b] = size(converted)
    
    converted(1,:)
    for i = 1:y
        for  j = 1:c
             converted(1,i,j) = 0
        end
    end
%     skinImage = zeros(y,c)
%     skinImage = converted
%     for i = 1:y       
%            if converted(i,:)>=77 & converted(i,:)<=127
%               skinImage(i,:) = 0;
%            end
%     end
    
    
    figure, imshow(converted); 
    %figure, imshow(skinImage); 
    folder_name='';
end


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    