function [Mx, Tbx] = cumMinEngVer(e)
% e is the energy map.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.

[ny,nx] = size(e);
Mx = zeros(ny, nx);
Tbx = zeros(ny, nx);
Mx(1,:) = e(1,:);

%% Add your code here
for i = 2:1:ny
    for j = 1 : 1:nx
        if j == 1
            if e(i,j) + Mx(i-1,j)  < e(i,j)+Mx(i-1,j+1)
                Mx(i,j) = e(i,j) + Mx(i-1,j);
                Tbx(i,j) = 0;
            else
                Mx(i,j) = e(i,j) + Mx(i-1,j+1);
                Tbx(i,j) = 1;
            end
        elseif j == nx
            if e(i,j) + Mx(i,j-1)  < e(i,j)+Mx(i-1,j-1)
                Mx(i,j) = e(i,j) + Mx(i,j-1);
                Tbx(i,j) = 0;
            else
                Mx(i,j) = e(i,j) + Mx(i-1,j-1);
                Tbx(i,j) = -1;
            end
        else
             if e(i,j) + Mx(i,j-1)  < e(i,j)+Mx(i-1,j+1) && e(i,j) + Mx(i,j-1)  < e(i,j)+Mx(i-1,j-1)
                Mx(i,j) = e(i,j) + Mx(i,j-1);
                Tbx(i,j) = 0;
             elseif e(i,j) + Mx(i,j-1)  > e(i,j)+Mx(i-1,j+1) && e(i,j) + Mx(i-1,j-1)  > e(i,j)+Mx(i-1,j+1)
                Mx(i,j) = e(i,j) + Mx(i-1,j+1);
                Tbx(i,j) = 1;
             else
                 Mx(i,j) = e(i,j) + Mx(i-1,j-1);
                Tbx(i,j) = -1;
            end
        end
    end
end
end