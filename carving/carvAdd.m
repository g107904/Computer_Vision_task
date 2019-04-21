function [Ic, T, rmIdxs] = carvAdd(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
% Memory saving way for carving
DEBUG = 0;
[nx, ny, nz] = size(I);
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
rmIdxs = cell(nr+1,nc+1);
pI = zeros(nr+1,nc+1);

TI{1,1} = I;
% remove the horizontal seams
rmHors = [];
for i = 2 : nr+1
    % generate the energy map
    b = zeros([size(TI{i-1,1},1),size(TI{i-1,1},2)]);
	e = genEngMap(TI{i-1, 1},b);

    % dynamic programming matrix
    [My, Tby] = cumMinEngHor(e);
    [TI{i, 1}, E, rmIdxs{i,1}] = addHorSeam(TI{i-1, 1}, My, Tby);
    
    % accumulate the energy
	T(i, 1) = T(i-1, 1) + E;
    
    % assign the direction of parent 0 row,1 col
    pI(i,1) = 1;
end

% remove the vertical seams
rmVers = [];
for i = 2 : nc+1
    b = zeros([size(TI{1,i-1},1),size(TI{1,i-1},2)]);
	e = genEngMap(TI{1, i-1},b);
	[Mx,Tbx] = cumMinEngVer(e);
	[TI{1, i}, E, rmIdxs{1,i}] = addVerSeam(TI{1, i-1}, Mx, Tbx);
    if(DEBUG)
        [yy,xx] = ind2sub([size(TI{1, i-1},1),size(TI{1, i-1},2)],rmIdxs{1,i});
        yy = unique(yy);
        disp(length(yy));
    end
	T(1, i) = T(1, i-1) + E;  
    pI(1,i) = 0;
end

% do the dynamic programming
for i = 2 : nr+1
	for j = 2 : nc+1
        b = zeros([size(TI{i-1,j},1),size(TI{i-1,j},2)]);
		e = genEngMap(TI{i-1, j},b);
		[My, Tby] = cumMinEngHor(e);
		[Iy, Ey, rmHor] = addHorSeam(TI{i-1, j}, My, Tby);
		b = zeros([size(TI{i,j-1},1),size(TI{i,j-1},2)]);
		e = genEngMap(TI{i, j-1},b);
		[Mx, Tbx] = cumMinEngVer(e);
		[Ix, Ex, rmVer] = addVerSeam(TI{i, j-1}, Mx, Tbx);
		
		if T(i, j-1) + Ex < T(i-1, j) + Ey
			TI{i, j} = Ix;
			T(i ,j) = T(i, j-1) + Ex;
            rmIdxs{i, j} = rmVer;
            pI(i,j) = 0; % inherite from row direction
		else
			TI{i, j} = Iy;
			T(i, j) = T(i-1, j) + Ey;
            rmIdxs{i,j} = rmHor;
            pI(i,j) = 1; % inherite from col direction
        end
        
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];
	end
end	
Ic = TI{nr+1,nc+1};
%figure;imshow(Ic);
end

