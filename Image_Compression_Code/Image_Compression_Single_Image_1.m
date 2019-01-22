%Clear all of the previous images if any of the settings are changed.
clear all; close all; clc
 
%*********************DISPLAYING OF THE IMAGE******************************
%Load the images from the provided ppm's.
A = imread('Images\4-gs.ppm');
image(A); title('original greyscale');
[height,width] = size(A(:,:,1));
 
B=imread('Images\1.ppm');
image(B);title('original colour');
[heightc,widthc]=size(B(:,:,1));
 
%subplot of the original images
figure (1); title ('Original images');
subplot (1,2,1); imshow (A); title ('original GS');
subplot (1,2,2);imshow(B); title ('original colour');
 
%*********************DOWNSAMPLING OF THE IMAGE****************************
 
%this is the downsampling section for all of the "colours" in the image.
%The greyscale image means that although the downsampling can be a set
%standard across the whole image, and therefore it is "easier" to
%downsample the image, it does mean that some quality is lost because you
%cannot choose what less dominant colours you would downsample more.
for width_1=1:width/2
for height_1=1:height/2
   blue(height_1,width_1) = mean(mean(A((height_1-1)*2+1:height_1*2,(width_1-1)*2+1:width_1*2, 3)));%just a standard formula for calculating the mean amount of pixels both horizontally and vertically that will be downsampled.
end
end
  
for width_1=1:width/2
for height_1=1:height/2
   green(height_1,width_1) = mean(mean(A((height_1-1)*2+1:height_1*2,(width_1-1)*2+1:width_1*2, 3)));
end
end
  
for width_1=1:width/2
for height_1=1:height/2
   red(height_1,width_1) = mean(mean(A((height_1-1)*2+1:height_1*2,(width_1-1)*2+1:width_1*2, 3)));
end
end
 
for width_2=1:widthc/8
for height_2=1:heightc/8
   bluecol(height_2,width_2) = mean(mean(B((height_2-1)*8+1:height_2*8,(width_2-1)*8+1:width_2*8, 3)));%just a standard formula for calculating the mean amount of pixels both horizontally and vertically that will be downsampled.
end
end
%*****************DISPLAY OF THE RGB VALUES OF THE IMAGE*******************
 
%output only the red channel of the image A
figure ();
image(A(:,:,1)); title('red channel GS');
col = zeros(256,3); %creating an array that will be filled with zeroes.          
col(:,1) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the red spectrum.
 
%output only the green channel of the image A
figure ();
image(A(:,:,2)); title('green channel GS');
col = zeros(256,3);           
col(:,2) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the green spectrum.
  
%output only the blue channel of the image A
figure ();
image(A(:,:,3)); title('blue channel GS');
col = zeros(256,3);           
col(:,3) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the blue spectrum.
 
figure ();
image(B(:,:,1)); title('red channel colour');
col = zeros(256,3); %creating an array that will be filled with zeroes.          
col(:,1) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the red spectrum.
 
figure ();
image(B(:,:,2)); title('green channel colour');
col = zeros(256,3);           
col(:,2) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the green spectrum.
 
figure (20);
image(B(:,:,3)); title('blue channel colour');
col = zeros(256,3);           
col(:,3) = 0:1/255:1;
colormap(col); caxis([0 255]);%setting the colormap of the image to the blue spectrum.
 
%******************DISPLAY THE DOWNSAMPLED RGB IMAGE **********************
 
%output the down sampled blue channel of the image A
% figure();
% image(blue); title('blue channel GS, down-sampled');
% col = zeros(256,3);
% col(:,3) = 0:1/255:1;
% colormap(col); caxis([0 255]);
%  
% figure();
% image(red); title('red channel GS, down-sampled');
% col = zeros(256,3);
% col(:,1) = 0:1/255:1;
% colormap(col); caxis([0 255]);
%  
% figure();
% image(green); title('green channel GS, down-sampled');
% col = zeros(256,3);
% col(:,2) = 0:1/255:1;
% colormap(col); caxis([0 255]);
 
figure(21);
image(bluecol); title('blue channel colour, down-sampled');
col = zeros(256,3);
col(:,3) = 0:1/255:1;
colormap(col); caxis([0 255]);

%saving the downsampled images, this is the collective lossy compression of
%the images.
imwrite(blue, 'downsampled_blue_GS.bmp','bmp');
imwrite(red, 'downsampled_red_GS.bmp','bmp');
imwrite(green, 'downsampled_green_GS.bmp','bmp');
% imwrite (bluecol, 'downsampled_blue_colour.bmp', 'BMP');
%*****************RECONSTRUCTION OF THE IMAGE*****************************
 
% reconstruct a complete image from reduced blue, green and red
% it is then interpolated linearly. Use of the interpolation function is
% shown here.
 
%interpolation for the GS image
[ih,iw] = size(blue);
A(:,:,3) = interp2([1:width/iw:width],[1:height/ih:height]',blue,[1:width],[1:height]','linear');
 
[ih,iw] = size(red);
A(:,:,1) = interp2([1:width/iw:width],[1:height/ih:height]',red,[1:width],[1:height]','linear');
 
[ih,iw] = size(green);
A(:,:,2) = interp2([1:width/iw:width],[1:height/ih:height]',green,[1:width],[1:height]','linear');
 
%interpolation for the colour image
[ih,iw] = size(bluecol);
B(:,:,3) = interp2([1:widthc/iw:widthc],[1:heightc/ih:heightc]',bluecol,[1:widthc],[1:heightc]','linear');
 
%********************DISPLAY THE RECONSTRUCTED IMAGE***********************
 
image(A); title('compressed image GS final');
 
image (B); title ('compressed image colour final');
 
figure (); title ('Original images');
subplot (1,2,1); imshow (A); title ('final decompressed GS');
subplot (1,2,2);imshow(B); title ('final decompressed colour');
 
%*******************COMPRESSION RATIO ************************************
 
%getting the size of the original image in the three dimensions of data
%that is is in; 768*1024*3
[xogs,yogs,zogs]=size(A);
 
%Getting the size of the three indivdually compressed colour channels.
[xrgs,yrgs,zrgs]=size(red);
[xbgs,ybgs,zbgs]=size(blue);
[xggs,yggs,zggs]=size(green);
 
%multiplying the x,y and z values to get the size of the image overall
sizeo=xogs*yogs*zogs;
sizec=((xrgs*yrgs*zrgs)+(xbgs*ybgs*zbgs)+(xggs*yggs*zggs));
 
%formula for the compression ratio which is then printed.
CompressionratioGS=(sizec/sizeo);
fprintf("compression ratio for GS: %0.4f\n", CompressionratioGS);
   %********END OF THE RGB TEST **************