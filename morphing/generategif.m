function [] = generategif(im1, im2, im1_pts, im2_pts)
Fig = figure;

filename = 'test.gif';
for i = 0 : 0.05 : 1
    img = morph(im1, im2, im1_pts, im2_pts, i, i);
    frame = getframe(Fig); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256);

    if i == 0

        imwrite(imind,cm,filename,'gif','WriteMode','overwrite', 'Loopcount',inf);

   else

        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.02);

   end
end

end

