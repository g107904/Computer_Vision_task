function [Ix, E,rmIdx] = addVerSeam(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx = zeros(ny, 1);
Ix = uint8(zeros(ny, nx+1, nz));

%% Add your code here
t = 1e6;
E = 0;
for j = 1 : nx
    if Mx(ny,j) < t
        t = Mx(ny,j);
        rmIdx(ny) = sub2ind(size(Mx),ny,j);
        E = E + t;
    end
end
for i = ny-1:-1:1
    [u,v] = ind2sub(size(Mx),rmIdx(i+1));
    rmIdx(i) = sub2ind(size(Mx),u-1,v+Tbx(u,v));
    E = E + Mx(u-1,v+Tbx(u,v));
end
for j = 1:ny
    for i = 1:nx+1
        [u,v] = ind2sub(size(Mx),rmIdx(j));
        if i <= v
            Ix(j,i,:) = I(j,i,:);
        else
            Ix(j,i,:) = I(j,i-1,:);
        end
    end
end
end