clear all;
close all;
clc;

f = rgb2gray(imread('Image07.jpg'));        % WORDS DON"T FIT PICTURE
%f = rgb2gray(imread('Image22.jpg'));        % COMING SOON
%f = rgb2gray(imread('texture text.jpg'));   % GRAPHIC MAC
%f = rgb2gray(imread('TextureText02.jpg'));  % PSD
%f = rgb2gray(imread('TextureText03.jpg'));  % EARTH
%f = rgb2gray(imread('TextureText04.jpg'));  % FUR
%f = rgb2gray(imread('TextureText07.jpg'));  % CANDY CANE

%figure,imshow(f);
f = imadjust(f,[0.001 0.9]);
%figure,imshow(f);
K = wiener2(f,[5 5]);
K = medfilt2(K);

%--------freq fiilter---------%
PQ = paddedsize(size(K));
Do = 0.1* PQ(1);
hp = hpfilter('gaussian',PQ(1),PQ(2),Do,2);
lp = lpfilter('btw',PQ(1),PQ(2),Do,2);
%ghf = dftfilt(double(K),hp);  %hipass
ghf = dftfilt(double(K),lp);   %lowpass
ghfscale = gscale(ghf);
figure,imshow(ghfscale);

%---------recon smooth----------%
se = strel('disk', 5);
fe = imerode(ghfscale, se);	
fobr = imreconstruct(fe, ghfscale);

fobrc = imcomplement(fobr); 
fobrce = imerode(fobrc, se);
fobrcer = imcomplement(imreconstruct(fobrce, fobrc));
figure,imshow(fobrcer);
%----------top hat---------------%

se = strel('disk',25);
toph = imtophat(fobrcer,se);
%figure,imshow(toph);

g_obr=imreconstruct(imerode(toph,ones(1,20)),toph);
g_obrd = imdilate(g_obr,ones(1,50));
f2 = imreconstruct(min(g_obrd,toph),toph);
figure,imshow(f2);

%----binarize---%

nf2 = imbinarize(f2,'global');
figure,imshow(nf2);

num = size(nf2);
c = ones(num) - nf2;
figure,imshow(c);

c2 = imbinarize(c,'global');
figure,imshow(c2);


ocrr = ocr(c2,'TextLayout','Block')
Iocr  = insertObjectAnnotation(f, 'rectangle', ...
                           ocrr.WordBoundingBoxes, ...
                           ocrr.WordConfidences);
figure; imshow(Iocr);

ocrr.Text