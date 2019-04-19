
function laps1 = genPyramids1(im1, nlvls)

if(nargin <= 1)
    nlvls = 4;
end
w = [1/8 1/4 1/4 1/4 1/8];

laps1 = cell(nlvls,2); 
laps1{1,1} = double(im1);
for i = 2 : nlvls
    laps1{i,1} = reduce(laps1{i-1,1},w);
end
laps1{end,2} = laps1{end,1};
for i = nlvls-1 : -1 : 1
    temp = expand(laps1{i+1,1},w);
    expSize = size(temp);
    orgSize = size(laps1{i,1});
    if(expSize(1) < orgSize(1))
        temp = vertcat(temp, temp(end,:,:));
    end
    if(expSize(2) < orgSize(2))
       temp =  horzcat(temp, temp(:,end,:));
    end
    laps1{i,2} = laps1{i,1} - temp;
    %laps1{i,2} = temp;
end