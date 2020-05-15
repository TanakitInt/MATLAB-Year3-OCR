clear all;
close all;
clc;

% To gray scale Image ------------------------
f = rgb2gray(imread('Image07.jpg'));        % WORDS DON"T FIT PICTURE
%f = rgb2gray(imread('Image22.jpg'));        % COMING SOON
%f = rgb2gray(imread('texture text.jpg'));   % GRAPHIC MAC
%f = rgb2gray(imread('TextureText02.jpg'));  % PSD
%f = rgb2gray(imread('TextureText03.jpg'));  % EARTH
%f = rgb2gray(imread('TextureText04.jpg'));  % FUR
%f = rgb2gray(imread('TextureText07.jpg'));  % CANDY CANE

figure(1); imshow(f); title("Input (Grayscale)");

% Entropy --------------------------
ef = entropyfilt(f);
efg = mat2gray(ef);
figure(2); imshow(efg); title("Entropy setup");

% Convert to Binary Image --------------------
bw = imbinarize(efg, 0.8);
bw2 = ~bw;
figure(3); imshow(bw); title("BW Image 1");
figure(4); imshow(bw2); title("BW Image 2");

% Fill Image ------------------
f_fill = imfill(bw, 'holes');
figure(5); imshow(f_fill); title("Fill Image")

% Top hat --------------------
se1 = strel('diamond', 3);
f_tophat = imopen(f_fill, se1);
figure(7); imshow(f_tophat); title("Top hat");


% OCR -------------------
ocrr = ocr(f_tophat,'TextLayout','Block')
Iocr  = insertObjectAnnotation(f, 'rectangle', ocrr.WordBoundingBoxes, ocrr.WordConfidences);
figure(10); imshow(Iocr);

ocrr.Text
