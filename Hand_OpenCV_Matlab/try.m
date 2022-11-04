%Read the image, and capture the dimensions
clc
img_orig = imread('hand.jpg');
height = size(img_orig,1);
width = size(img_orig,2);

%%Initialize the output images
%out = img_orig;
%bin = zeros(height,width);
%
%%Convert the image from RGB to YCbCr
%img_ycbcr = rgb2ycbcr(img_orig);
%Cb = img_ycbcr(:,:,2);
%Cr = img_ycbcr(:,:,3);
%
%%Detect Skin
%[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
%numind = size(r,1);
%
%%Mark Skin Pixels
%for i=1:numind
%    out(r(i),c(i),:) = [0 0 255];
%    bin(r(i),c(i)) = 1;
%end
%imshow(img_orig);
%figure; imshow(out);
%figure; imshow(bin);
%
%%now for count of fingers
%
%img2=im2bw(bin,graythresh(bin));
%imshow(img2)
%img2=~img2;
%imshow(img2)
%B = bwboundaries(img2);
%imshow(img2)
%text(10,10,strcat('\color{green}Objects Found:',num2str(length(B))))

