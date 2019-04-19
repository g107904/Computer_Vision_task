
img = imread ('94cad1c8a786c9179092ab7cc93d70cf3ac757e6.jpg');
img = rgb2gray(img); 
img = double (img);
% img = [1 0 0 0 0 0 0 0 1;
%     1 0.5 0 0 0 0 0 0.5 1;
%     1 0.5 0.5 0 0 0 0.5 0.5 1;
%     1 0.5 0.5 0.5 0 0.5 0.5 0.5 1;
%     1 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1;
%     1 0.5 0.5 0.5 0 0.5 0.5 0.5 1;
%     1 0.5 0.5 0 0 0 0.5 0.5 1;
%     1 0.5 0 0 0 0 0 0.5 1;
%     1 0 0 0 0 0 0 0 1];
% Value for high and low thresholding
threshold_low = 0.035;
threshold_high = 0.175;
global vis
global linked_edge
 
%% Gaussian filter definition (https://en.wikipedia.org/wiki/Canny_edge_detector)
G = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2];
G = 1/159.* G;
 
%Filter for horizontal and vertical direction
dx = [1 0 -1];
dy = [1; 0; -1];

%% Convolution of image with Gaussian
Gx = conv2(G, dx, 'same');
Gy = conv2(G, dy, 'same');
 
% Convolution of image with Gx and Gy
Ix = conv2(img, Gx, 'same');
Iy = conv2(img, Gy, 'same');


%% Calculate magnitude and angle
%k = abs(Ix)+abs(Iy);
magnitude = sqrt(Ix.*Ix+Iy.*Iy);
angle = atan2(Iy, Ix);
 
%% Edge angle conditioning
angle(angle<0) = pi+angle(angle<0);
angle(angle>7*pi/8) = pi-angle(angle>7*pi/8);

% Edge angle discretization into 0, pi/4, pi/2, 3*pi/4
angle(angle>=0&angle<pi/8) = 0;
angle(angle>=pi/8&angle<3*pi/8) = pi/4;
angle(angle>=3*pi/8&angle<5*pi/8) = pi/2;
angle(angle>=5*pi/8&angle<=7*pi/8) = 3*pi/4;

%% initialize the images
[nr, nc] = size(img);
edge = zeros(nr, nc);
 
%% Non-Maximum Supression
edge = non_maximum_suppression(magnitude, angle, edge); 
 
edge = edge.*magnitude;
%% Hysteresis thresholding
% for weak edge
threshold_low = threshold_low * max(edge(:));
% for strong edge
threshold_high = threshold_high * max(edge(:));  
linked_edge = zeros(nr, nc); 
linked_edge = hysteresis_thresholding(threshold_low, threshold_high, linked_edge, edge);
vis = zeros(nr, nc);
for i = 1 : nr
    for j = 1 : nc
        if(linked_edge(i,j) > 0.5 && linked_edge(i,j) < 1.5 && vis(i,j) < 0.5)
            %vis(:,:) = 0;
            redo(i,j,angle);
        end
    end
end
linked_edge = linked_edge .* edge;
imshow(linked_edge);

