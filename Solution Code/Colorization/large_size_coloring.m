clc
clear
x=imread('workshop.tif');
imshow(x)
x=imresize(x,0.2);
[H,W]=size(x);
B=x(10:floor(H/3),:);
G=x(floor(H/3):floor(H/3*2)-10,:);
R=x(floor(H/3*2)+11:H,:);
[hei,wid]=size(R)
%OFF=10
OFF=50
pad_size=[OFF OFF]
EdgeB = edge(B,'Canny');
EdgeG = edge(G,'Canny');
EdgeR = edge(R,'Canny');

CropR=R;
CropG=G;
CropB=B;
[cropY,cropX]=size(CropR)
B = padarray(CropR,pad_size,0,'both');
G = padarray(CropG,pad_size,0,'both');
R = padarray(CropB,pad_size,0,'both');

DB=double(B);
DG=double(G);
DR=double(R);
normB = DB;
normG = DG;
normR = DR;

img1=normR(OFF:cropY+OFF,OFF:cropX+OFF);
thresh=1e20;
GoffsetX=0;
GoffsetY=0;
for offsetY=-OFF+1:OFF-1
    for offsetX=-OFF+1:OFF-1
        img2=normG(offsetY+OFF:offsetY+OFF+cropY,offsetX+OFF:offsetX+OFF+cropX);
        MSE=sum(sum(((img1-img2).^2)));
        if MSE<thresh
            thresh=MSE;
            GoffsetX=offsetX;
            GoffsetY=offsetY;
        end
    end
end

thresh=1e20;
BoffsetX=0;
BoffsetY=0;
% for offsetY=-OFF+1:OFF-1
for offsetY=-OFF+1:-10 
    for offsetX=-OFF+1:OFF-1
        img2=normB(offsetY+OFF:offsetY+OFF+cropY,offsetX+OFF:offsetX+OFF+cropX);
        MSE=sum(sum(((img1-img2).^2)));
        if MSE<thresh
            thresh=MSE;
            BoffsetX=offsetX;
            BoffsetY=offsetY;
        end
    end
end

xB=imresize(B(BoffsetY+OFF:BoffsetY+OFF+cropY,BoffsetX+OFF:BoffsetX+OFF+cropX),5);
xG=imresize(G(GoffsetY+OFF:GoffsetY+OFF+cropY,GoffsetX+OFF:GoffsetX+OFF+cropX),5);
xR=imresize(R(OFF:cropY+OFF,OFF:cropX+OFF),5);
[cropY,cropX]=size(xB);
RGB=zeros(cropY,cropX,3);
RGB(:,:,3)=xR;
RGB(:,:,2)=xG;
RGB(:,:,1)=xB;
RGB=uint16(RGB);
figure()
imshow(RGB)
imwrite(RGB,'workshop_OUT3.tif')
                