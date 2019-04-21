function [Iy, E,rmIdx,bww] = rmHorSeam(I, My, Tby,bw)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image removed one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(1, nx);
Iy = uint8(zeros(ny-1, nx, nz));

%% Add your code here
t = 1e6;
E = 0;
for j = 1 : ny
    if My(j,nx) < t
        t = My(j,nx);
        rmIdx(nx) = sub2ind(size(My),j,nx);
        E = E + t;
    end
end
for i = nx-1:-1:1
    [u,v] = ind2sub(size(My),rmIdx(i+1));
    rmIdx(i) = sub2ind(size(My),u+Tby(u,v),v-1);
    E = E + My(u+Tby(u,v),v-1);
end
for j = 1:nx
    for i = 1:ny-1
        [u,v] = ind2sub(size(My),rmIdx(j));
        if i < u
            Iy(i,j,:) = I(i,j,:);
            bww(i,j) = bw(i,j);
        else
            Iy(i,j,:) = I(i+1,j,:);
            bww(i,j) = bw(i+1,j);
        end
    end
end
        
end