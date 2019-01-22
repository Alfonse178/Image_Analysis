%  compress2.m
   dat = im2double(imread('Images\1.ppm', 'ppm'));

   gamma = 2.2; % assume that the image is gamma-corrected for this gamma

   r = dat(:,:,1);
   g = dat(:,:,2);
   b = dat(:,:,3);

   % remove gamma correction
   r = ((double(r)./256).^gamma .* 256);
   g = ((double(g)./256).^gamma .* 256);
   b = ((double(b)./256).^gamma .* 256);

   % rotate to YCbCr
   Y  = uint8(      0.299   *r +  0.587   *g  +  0.114   *b);
   Cb = uint8(128 - 0.168736*r -  0.331264*g  +  0.5     *b);
   Cr = uint8(128 + 0.5     *r -  0.418688*g  -  0.081312*b);


   % store only 1/4 of the Cb and Cr channels
   [m,n] = size(r);
   for ml = 1:m/2
   for nl = 1:n/2
      Cb_small(ml,nl) = mean(mean(Cb(ml*2-1:ml*2, nl*2-1:nl*2)));
      Cr_small(ml,nl) = mean(mean(Cr(ml*2-1:ml*2, nl*2-1:nl*2)));
   end
   end

   clear Cb Cr r g b

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % at this point the channels Y, Cb_small and Cr_small would be saved or
   % further compressed. 
   %
   %
   % To reconstruct the image, proceed as follows:
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % reconstruct full Cr/Cb channels (piecewise constant interpolation)
   Cb = zeros(m,n); Cr = zeros(m,n);
   for ml = 1:m/2
   for nl = 1:n/2
      Cb(ml*2-1:ml*2, nl*2-1:nl*2) = Cb_small(ml,nl);
      Cr(ml*2-1:ml*2, nl*2-1:nl*2) = Cr_small(ml,nl);
   end
   end

   % rotate back to RGB
   Y = double(Y);
   r = uint8(Y + 1.402  *(Cr-128));
   g = uint8(Y - 0.34414*(Cb-128) - 0.71414*(Cr-128));
   b = uint8(Y + 1.772  *(Cb-128));

   % correct gamma
   igamma = 1/gamma;
   r = uint8((double(r)./256).^igamma .*256);
   g = uint8((double(g)./256).^igamma .*256);
   b = uint8((double(b)./256).^igamma .*256);

   % store reconstructed image for comparisons
   dat2(:,:,1) = r;
   dat2(:,:,2) = g;
   dat2(:,:,3) = b;
   imwrite(dat2,'test_image_reconstructed.ppm','PPM');


   figure(1);
   image(dat); title('crop from original');
   figure(2);
   image(dat2); title('crop from reconstructed');