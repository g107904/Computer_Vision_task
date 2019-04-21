function [Ic, T] = carv(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map
bw = load('ca.mat', 'BW');  
bw = bw.BW; 
[ny, nx, nz] = size(I);
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
bww = cell(nr+1,nc+1);
bww{1,1} = bw;
TI{1,1} = I;
% TI is a trace table for images. TI{r+1,c+1} records the image removed r rows and c columns.
rmIdxs = cell(nr+1,nc+1);
pI = zeros(nr+1,nc+1);
rmHors = [];
for i = 2 : nr+1
    % generate the energy map
	e = genEngMap(TI{i-1, 1},bww{i-1,1});

    % dynamic programming matrix
    [My, Tby] = cumMinEngHor(e);
    [TI{i, 1}, E, rmIdxs{i,1},bww{i,1}] = rmHorSeam(TI{i-1, 1}, My, Tby,bww{i-1,1});
    
    % accumulate the energy
	T(i, 1) = T(i-1, 1) + E;
    
    % assign the direction of parent 0 row,1 col
    pI(i,1) = 1;
end

% remove the vertical seams
rmVers = [];
for i = 2 : nc+1
	e = genEngMap(TI{1, i-1},bww{1,i-1});
	[Mx,Tbx] = cumMinEngVer(e);
	[TI{1, i}, E, rmIdxs{1,i},bww{1,i}] = rmVerSeam(TI{1, i-1}, Mx, Tbx,bww{1,i-1});
%     if(DEBUG)
%         [yy,xx] = ind2sub([size(TI{1, i-1},1),size(TI{1, i-1},2)],rmIdxs{1,i});
%         yy = unique(yy);
%         disp(length(yy));
%     end
	T(1, i) = T(1, i-1) + E;  
    pI(1,i) = 0;
end

% do the dynamic programming
for i = 2 : nr+1
	for j = 2 : nc+1
		e = genEngMap(TI{i-1, j},bww{i-1,j});
		[My, Tby] = cumMinEngHor(e);
		[Iy, Ey, rmHor,by] = rmHorSeam(TI{i-1, j}, My, Tby,bww{i-1,j});
		
		e = genEngMap(TI{i, j-1},bww{i,j-1});
		[Mx, Tbx] = cumMinEngVer(e);
		[Ix, Ex, rmVer,bx] = rmVerSeam(TI{i, j-1}, Mx, Tbx,bww{i,j-1});
		
		if T(i, j-1) + Ex < T(i-1, j) + Ey
			TI{i, j} = Ix;
			T(i ,j) = T(i, j-1) + Ex;
            rmIdxs{i, j} = rmVer;
            bww{i,j}= bx;
            pI(i,j) = 0; % inherite from row direction
		else
			TI{i, j} = Iy;
			T(i, j) = T(i-1, j) + Ey;
            rmIdxs{i,j} = rmHor;
            bww{i,j} = by;
            pI(i,j) = 1; % inherite from col direction
        end
        
        % suppress the memory for recording intermediate results
        TI{i-1,j} = [];
	end
end	
Ic = TI{nr+1,nc+1};
%figure;imshow(Ic);
end