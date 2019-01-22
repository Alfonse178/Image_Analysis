clear all; close all; clc

%Just loading in all of the images used for the task.
A=im2double(imread('Images\1.ppm', 'ppm'));
% B=im2double(imread('Images\2.ppm', 'ppm'));
% C=im2double(imread('Images\3.ppm', 'ppm'));
% D=im2double(imread('Images\4-gs.ppm', 'ppm'));
% E=im2double(imread('Images\5-gs.ppm', 'ppm'));
% F=im2double(imread('Images\6-gs.ppm', 'ppm'));

figure(1); title('Original image display');

%Displaying the original images in a plotted Figure.

subplot(3,2,1);imshow(A);title('1 ');
% subplot(3,2,2);imshow(B);title('2');
% subplot(3,2,3);imshow(C);title('3');
% subplot(3,2,4);imshow(D);title('4-greayscale');
% subplot (3,2,5);imshow(E);title('5-greyscale');
% subplot (3,2,6);imshow (F); title ('6-greyscale');

%Used during devlopment to ascertain the infromation for each image in the
%command window.

infoA=imfinfo('Images\1.ppm');
% infoB=imfinfo('Images\2.ppm');
% infoC=imfinfo('Images\3.ppm');
% infoD=imfinfo('Images\4-gs.ppm');
% infoE=imfinfo('Images\5-gs.ppm');
% infoF=imfinfo('Images\6-gs.ppm');

%Converting the colour images into their luma and chroma components so that
%their colours can be mainpulated later on. Although this would work in
%MATLAB, functions have been written from scratch to make the manipulation
%of the seperate channels easier.

% YCBCRA = rgb2ycbcr(A);
% YCBCRB = rgb2ycbcr(B);
% YCBCRC = rgb2ycbcr(C);
% 
% figure (2); title('Image in YCbCr Color Space');
% subplot (3,2,1);imshow(YCBCRB); title ('YCrCb 1');
% subplot (3,2,2);imshow(YCBCRB); title ('YCrCb 2');
% subplot (3,2,3);imshow(YCBCRC); title ('YCrCb 3');



