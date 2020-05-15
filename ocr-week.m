clear all;
close all;
f = rgb2gray(imread('TextureText02.jpg'));

K = wiener2(f,[5 5]);
K = medfilt2(K);

%--------freq fiilter---------%
PQ = paddedsize(size(K));
Do = 0.1* PQ(1);
HBW = hpfilter('gaussian',PQ(1),PQ(2),Do,2);
lp = lpfilter('gaussian',PQ(1),PQ(2),Do,2);
%ghf = dftfilt(double(K),HBW);
ghf = dftfilt(double(K),lp);
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
figure,imshow(toph);

g_obr=imreconstruct(imerode(toph,ones(1,20)),toph);
g_obrd = imdilate(g_obr,ones(1,50));
f2 = imreconstruct(min(g_obrd,toph),toph);
figure,imshow(f2);

%----binarize---%

nf2 = imbinarize(f2,'global');
figure,imshow(nf2);

ocrr = ocr(nf2,'TextLayout','Block')
Iocr  = insertObjectAnnotation(f, 'rectangle', ...
                           ocrr.WordBoundingBoxes, ...
                           ocrr.WordConfidences);
figure; imshow(Iocr);

ocrr.Text

