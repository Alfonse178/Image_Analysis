A = im2double(imread('Images\1.ppm',ppm));
B=im2double(imread('Images\2.ppm', 'ppm'));
C=im2double(imread('Images\3.ppm', 'ppm'));
D=im2double(imread('Images\4-gs.ppm', 'ppm'));
E=im2double(imread('Images\5-gs.ppm', 'ppm'));
F=im2double(imread('Images\6-gs.ppm', 'ppm'));


   % reduce resolution of blue layer by factor 64 (block 8x8 pixels)

   [height,width] = size(A(:,:,1));

   % down-sampling of the less dominant colour
   for w=1:width/8,
   for h=1:height/8,
      blue(h,w) = mean(mean(A((h-1)*8+1:h*8,(w-1)*8+1:w*8, 3)));
   end
   end
   
   %down sampling of the more dominant colours, smalled desampling
   for w=1:width/2,
   for h=1:height/2,
      green(h,w) = mean(mean(A((h-1)*2+1:h*2,(w-1)*2+1:w*2, 3)));
   end
   end
   
      for w=1:width/2,
   for h=1:height/2,
      red(h,w) = mean(mean(A((h-1)*2+1:h*2,(w-1)*2+1:w*2, 3)));
   end
   end
   
   image(A); title('original');

   figure()
   image(A(:,:,1)); title('red channel');
   c = zeros(256,3);            % setup a color axis with red intensities
   c(:,1) = 0:1/255:1;
   colormap(c); caxis([0 255]);
   
   figure()
   image(A(:,:,2)); title('green channel');
   c = zeros(256,3);            % setup a color axis with green intensities
   c(:,2) = 0:1/255:1;
   colormap(c); caxis([0 255]);
   
   figure()
   image(A(:,:,3)); title('blue channel');
   c = zeros(256,3);            % setup a color axis with blue intensities
   c(:,3) = 0:1/255:1;
   colormap(c); caxis([0 255]);

   figure();
   image(blue); title('blue channel, down-sampled');
   c = zeros(256,3);
   c(:,3) = 0:1/255:1;
   colormap(c); caxis([0 255]);

      figure();
   image(red); title('red channel, down-sampled');
   c = zeros(256,3);
   c(:,1) = 0:1/255:1;
   colormap(c); caxis([0 255]);
   
      figure();
   image(green); title('green channel, down-sampled');
   c = zeros(256,3);
   c(:,2) = 0:1/255:1;
   colormap(c); caxis([0 255]);
   
   % reconstruct a complete image from reduced blue, green and red
   % interpolate linearly

   [hes,wis] = size(blue);
   A(:,:,3) = interp2([1:width/wis:width],[1:height/hes:height]',blue,[1:width],[1:height]','linear');
   figure();
   image(A); title('compressed image final');

   imwrite(A,'test_image_blue64.ppm','PPM');
   imwrite(blue, 'downsampled_blue.ppm','ppm');
   imwrite(red, 'downsampled_red.ppm','ppm');
   imwrite(green, 'downsampled_green.ppm','ppm');
   
   
   
   %********END OF THE RGB TEST **************
   %********YCrCb TEST STARTS HERE ***********
   
    %  compress2.m
%    A = imread('Images\1.ppm');
% 
%    gamma = 2.2; % assume that the image is gamma-corrected for this gamma
% 
%    r = A(:,:,1);
%    g = A(:,:,2);
%    b = A(:,:,3);
% 
%    % remove gamma correction
%    r = ((double(r)./256).^gamma .* 256);
%    g = ((double(g)./256).^gamma .* 256);
%    b = ((double(b)./256).^gamma .* 256);
% 
%    % rotate to YCbCr
%    Y  = uint8(      0.299   *r +  0.587   *g  +  0.114   *b);
%    Cb = uint8(128 - 0.168736*r -  0.331264*g  +  0.5     *b);
%    Cr = uint8(128 + 0.5     *r -  0.418688*g  -  0.081312*b);
% 
% 
%    % store only 1/4 of the Cb and Cr channels
%    [m,n] = size(r);
%    for ml = 1:m/2
%    for nl = 1:n/2
%       Cb_small(ml,nl) = mean(mean(Cb(ml*2-1:ml*2, nl*2-1:nl*2)));
%       Cr_small(ml,nl) = mean(mean(Cr(ml*2-1:ml*2, nl*2-1:nl*2)));
%    end
%    end
% 
%    clear Cb Cr r g b
% 
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    % at this point the channels Y, Cb_small and Cr_small would be saved or
%    % further compressed. 
%    %
%    %
%    % To reconstruct the image, proceed as follows:
%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    
%    %*******RECONSTRUCTION OCCURS HERE********
%    % reconstruct full Cr/Cb channels (piecewise constant interpolation)
%    Cb = zeros(m,n); Cr = zeros(m,n);
%    for ml = 1:m/2
%    for nl = 1:n/2
%       Cb(ml*2-1:ml*2, nl*2-1:nl*2) = Cb_small(ml,nl);
%       Cr(ml*2-1:ml*2, nl*2-1:nl*2) = Cr_small(ml,nl);
%    end
%    end
% 
%    % rotate back to RGB
%    Y = double(Y);
%    r = uint8(Y + 1.402  *(Cr-128));
%    g = uint8(Y - 0.34414*(Cb-128) - 0.71414*(Cr-128));
%    b = uint8(Y + 1.772  *(Cb-128));
% 
%    % correct gamma
%    igamma = 1/gamma;
%    r = uint8((double(r)./256).^igamma .*256);
%    g = uint8((double(g)./256).^igamma .*256);
%    b = uint8((double(b)./256).^igamma .*256);
% 
%    % store reconstructed image for comparisons
%    A2(:,:,1) = r;
%    A2(:,:,2) = g;
%    A2(:,:,3) = b;
%    imwrite(A2,'test_image_reconstructed_1.ppm','PPM');
% 
% 
%    figure(1);
%    image(A); title(' original');
%    figure(2);
%    image(A2); title(' reconstructed');