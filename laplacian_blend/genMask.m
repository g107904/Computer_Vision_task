
% ����һ��ͼ������Matlab��roipoly�������һ������ε�����
im1 = imread('Lenna.png'); 


% ����roipoly��ͼƬ1��ѡ�����Ȥ����
figure(1);clf; %imshow(im1);
[BW, xi, yi] = roipoly(im1);
save('Lenna.mat','BW','xi','yi');