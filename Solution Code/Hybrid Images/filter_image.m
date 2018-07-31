function output = filter_image(image, filter)

im = im2double(image);
isgray =0;
if length(size(image))==2    
    isgray=1;
elseif length(size(image))==3
    [~,~,mz]=size(image);
    isgray=0;
end
[fy,fx] = size(filter);

pad_x = floor(fx/2);
pad_y = floor(fy/2);

if isgray==1
    output = zeros(size(im)+[2*pad_y 2*pad_x]);
    for x= 1:fx,
        for y=1:fy,
            output(y:end-(fy-y),x:end-(fx-x))=output(y:end-(fy-y),x:end-(fx-x))+im*filter(y,x);
        end
    end
    output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x);
else
    output = zeros(size(im)+[2*pad_y 2*pad_x 0]);
    for x= 1:fx,
        for y=1:fy,
            for z=1:mz,
                output(y:end-(fy-y),x:end-(fx-x),z)=output(y:end-(fy-y),x:end-(fx-x),z)+im(:,:,z)*filter(y,x);
            end
        end
    end
    output = output(1+pad_y:end-pad_y,1+pad_x:end-pad_x,:);
end
        