clear all;
close all;
clc;

% To gray scale Image ------------------------
%f = rgb2gray(imread('Image07.jpg'));        % WORDS DON"T FIT PICTURE
%f = rgb2gray(imread('Image22.jpg'));        % COMING SOON
%f = rgb2gray(imread('texture text.jpg'));   % GRAPHIC MAC
f = rgb2gray(imread('TextureText02.jpg'));  % PSD
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

% Edge Detection ------------------
%f_edge = edge(f_fill, 'Canny');
%figure(6); imshow(f_edge); title("Edge Detection");

% Top hat --------------------
se1 = strel('diamond', 3);
f_tophat = imopen(f_fill, se1);
figure(7); imshow(f_tophat); title("Top hat");


%Commented part seems to break the image for now, might need fixing

%bw4 = imfill(bw3, 'holes');
%se2 = strel('disk', 3);
%bw5 = imclose(bw4, se2);
%L = bwlabeln(bw5, 8);
%S = regionprops(L, 'Area');
%figure(6); imshow(bw4);
%figure(7); imshow(bw5);


% OCR -------------------
ocrr = ocr(f_tophat,'TextLayout','Block')
Iocr  = insertObjectAnnotation(f, 'rectangle', ocrr.WordBoundingBoxes, ocrr.WordConfidences);
figure(10); imshow(Iocr);

ocrr.Text

