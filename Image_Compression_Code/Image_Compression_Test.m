 % compress1.m   
   dat = imread('test_image.tif');


   % reduce resolution of blue layer by factor 64 (block 8x8 pixels)

   [height,width] = size(dat(:,:,1));

   image(dat); title('original');

   figure()
   image(dat(:,:,1)); title('red channel');
   c = zeros(256,3);            % setup a color axis with red intensities
   c(:,1) = 0:1/255:1;
   colormap(c); caxis([0 255]);

   figure()
   image(dat(:,:,2)); title('green channel');
   c = zeros(256,3);            % setup a color axis with green intensities
   c(:,2) = 0:1/255:1;
   colormap(c); caxis([0 255]);

   figure()
   image(dat(:,:,3)); title('blue channel');
   c = zeros(256,3);            % setup a color axis with blue intensities
   c(:,3) = 0:1/255:1;
   colormap(c); caxis([0 255]);


   figure();
   image(blue); title('blue channel, down-sampled');
   c = zeros(256,3);
   c(:,3) = 0:1/255:1;
   colormap(c); caxis([0 255]);
   imwrite(dat,'test_image_blue64.tif','TIFF');
   % down-sampling
   for w=1:width/8,
   for h=1:height/8,
      blue(h,w) = mean(mean(dat((h-1)*8+1:h*8,(w-1)*8+1:w*8, 3)));
   end
   end
   

 
   % reconstruct a complete image from reduced blue data
   % interpolate linearly

   [hes,wis] = size(blue);
   dat(:,:,3) = interp2([1:width/wis:width],[1:height/hes:height]',blue,[1:width],[1:height]','linear');
   figure();
   image(A); title('reconstructed image (linear interpolation)');

  
   
%    infoA=imfinfo('test_image.tif');
%    infoB=imfinfo('test_image_blue64.tif');
%    infoC=imfinfo('test_image_reconstructed.tif');