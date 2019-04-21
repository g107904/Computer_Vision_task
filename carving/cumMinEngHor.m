function [My, Tby] = cumMinEngHor(e)
% e is the energy map.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.

[ny,nx] = size(e);
My = zeros(ny, nx);
Tby = zeros(ny, nx);
My(:,1) = e(:,1);

for i = 2:1:nx
    for j = 1 : 1:ny
        if j == 1
            if e(j,i) + My(j,i-1)  < e(j,i)+My(j+1,i-1)
                My(j,i) = e(j,i) + My(j,i-1);
                Tby(j,i) = 0;
            else
                My(j,i) = e(j,i) + My(j+1,i-1);
                Tby(j,i) = 1;
            end
        elseif j == ny
            if e(j,i) + My(j,i-1)  < e(j,i)+My(j-1,i-1)
                My(j,i) = e(j,i) + My(j,i-1);
                Tby(j,i) = 0;
            else
                My(j,i) = e(j,i) + My(j-1,i-1);
                Tby(j,i) = -1;
            end
        else
             if e(j,i) + My(j,i-1)  < e(j,i)+My(j+1,i-1) && e(j,i) + My(j,i-1)  < e(j,i)+My(j-1,i-1)
                My(j,i) = e(j,i) + My(j,i-1);
                Tby(j,i) = 0;
             elseif e(j,i) + My(j,i-1)  > e(j,i)+My(j+1,i-1) && e(j,i) + My(j-1,i-1)  > e(j,i)+My(j+1,i-1)
                My(j,i) = e(j,i) + My(j+1,i-1);
                Tby(j,i) = 1;
             else
                 My(j,i) = e(j,i) + My(j-1,i-1);
                Tby(j,i) = -1;
            end
        end
    end
end

end