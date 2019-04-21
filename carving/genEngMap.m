function e = genEngMap(I,bw)
% I is an image. I could be of color or grayscale.
% e is the energy map of n-by-m matrix.
if ndims(I) == 3
    % Assume the image fed in is a 3-channel RGB color image
    Ig = double(rgb2gray(I)); 
else
    % Assume the image fed in is a grayscale image
    Ig = double(I);
end
w = ones(size(bw));
b = w - bw;
[gx, gy] = gradient(Ig);
e = abs(gx) + abs(gy);
e = e .* b;
end