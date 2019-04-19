
%demo_laplacian_blend 
%读入两幅照片，以及采用genMask标记的图像区域
imA = imread('Lenna.png');  
maskA = load('Lenna.mat', 'BW');  
maskA = maskA.BW; 
maskA = double(maskA);
imB = imread('957c5893-830e-4fd3-a58b-e662e8b806db.jpg');  
% imA = [0 0 0 0 0 0 0 0 0;
%     0 0 0 127 255 127 0 0 0;
%     0 0 0 127 255 127 0 0 0;
%     0 127 127 127 255 127 127 127 0;
%     0 255 255 255 255 255 255 255 0;
%     0 127 127 127 255 127 127 127 0;
%     0 0 0 127 255 127 0 0 0;
%     0 0 0 127 255 127 0 0 0;
%     0 0 0 0 0 0 0 0 0];
% maskA = [0 0 1 1 1 1 1 0 0;
%     0 0 1 1 1 1 1 0 0;
%     1 1 1 1 1 1 1 1 1;
%     1 1 1 1 1 1 1 1 1;
%     1 1 1 1 1 1 1 1 1;
%     1 1 1 1 1 1 1 1 1;
%     1 1 1 1 1 1 1 1 1;
%     0 0 1 1 1 1 1 0 0;
%     0 0 1 1 1 1 1 0 0];
% imB = [
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100;
%     100 100 100 100 100 100 100 100 100
%     ];

%%
% 通过padding，将两幅照片的大小实现一致了
szA = size(imA); if(size(imA,3) == 1), szA(3) = 1; end
szB = size(imB); if(size(imB,3) == 1), szB(3) = 1; end
sz = max([szA(:) szB(:)],[],2);

% 对图像A和模板maskA进行Padding
if(szA(1) < sz(1))
    imA_pad = vertcat(imA, zeros(sz(1)-szA(1), szA(2), szA(3)));
    maskA_pad = vertcat(maskA, zeros(sz(1) - szA(1), szA(2)));
else
    imA_pad = imA;
    maskA_pad = maskA;
end
if(szA(2) < sz(2))
   imA_pad =  horzcat(imA_pad, zeros(size(imA_pad,1), sz(2) - szA(2), szA(3)));
   maskA_pad = horzcat(maskA_pad, zeros(size(imA_pad,1), sz(2) - szA(2)));
end
if(szA(3) < sz(3))
    imA_pad = repmat(imA_pad,[1 1 3]);
end

% 对图像B进行Padding
if(szB(1) < sz(1))
    imB_pad = vertcat(imB, zeros(sz(1)-szB(1), szB(2), szB(3)));
else
    imB_pad = imB;
end
if(szB(2) < sz(2))
   imB_pad =  horzcat(imB_pad, zeros(size(imB_pad,1), sz(2) - szB(2), szB(3)));
end
if(szB(3) < sz(3))
    imB_pad = repmat(imB_pad,[1 1 3]);
end

%%
% 获取一个位置信息
figure(1);imshow(uint8(imB_pad));
[xshift,yshift] = ginput(1);

% 获取原始图像中
maskPoints = load('Lenna.mat', 'xi', 'yi');
xshift = (xshift - mean(maskPoints.xi));
yshift = (yshift - mean(maskPoints.yi));

% 将图像A和它的模板都进行平移
imA_pad = imtranslate(imA_pad, [xshift, yshift]);
maskA_pad = imtranslate(maskA_pad, [xshift, yshift]);

figure;imshow(uint8(imA_pad));
figure;imshow(uint8(maskA_pad)*255);

%%
% 进行拉普拉斯金字塔的分解
nlvls = 4;
lapsA = genPyramids1(imA_pad, nlvls);
lapsB = genPyramids1(imB_pad, nlvls);

% 将Mask进行imresize运算
lapsMask = genPyramids1(maskA_pad, nlvls);

%%
% 通过拉普拉斯金字塔进行合成
lapsBlend = lapsB;
for i = nlvls : -1 : 1
    lapsBlend{i,2} = lapsA{i,2} .* repmat(lapsMask{i,1}, [1 1 sz(3)]) + ...
                     lapsB{i,2} .* (1 - repmat(lapsMask{i,1}, [1 1 sz(3)]));
end

% 通过合成的拉普拉斯金字塔进行恢复
imBlend = recoverLaplacian(lapsBlend(:,2));
figure;imshow(uint8(imBlend));