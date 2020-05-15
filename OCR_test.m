f = imread('ocrtest.jpg');

ocrr = ocr(f,'TextLayout','Block');
Iocr  = insertObjectAnnotation(f, 'rectangle', ...
                           ocrr.WordBoundingBoxes, ...
                           ocrr.WordConfidences);
figure; imshow(Iocr);

ocrr.Text