function g = dftfilt(f,h)

F=fft2(f,size(h,1),size(h,2));
G=h.*F;
figure,imshow(h,[])
figure, imshow(uint8(abs(log(1+F))),[])

g=real(ifft2(G));
g=g(1:size(f,1),1:size(f,2));