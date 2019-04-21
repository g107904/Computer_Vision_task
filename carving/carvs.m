im = imread('cc.jpg');
[BW,xi,yi] = roipoly(im);
save('ca.mat','BW','xi','yi');
bw = load('ca.mat', 'BW');  
bw = bw.BW; 
[ny,nx,nz] = size(im);
nc = 0;
nr = 0;
% for i = 1:ny
%     for j = 1:nx
%         if bw(i,j) ~= 0
%             im(i,j,:) = [0;0;0];
%         end
%     end
for i = 1:ny
    tc = 0;
    for j = 1:nx
        if bw(i,j) ~= 0
            tc = tc+1;
        end
    end
    if tc > nc
        nc = tc;
    end
end
for i = 1:nx
    tr = 0;
    for j = 1:ny
        if bw(j,i) ~= 0
            tr = tr + 1;
        end
    end
    if tr > nr
        nr = tr;
    end
end
[im1,~] = carv(im,nc,nr);
figure;imshow(im1);
[I,~] = carvAdd(im1,nc,nr);
figure;imshow(I);
