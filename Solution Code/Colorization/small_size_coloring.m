x=imread('cathedral.jpg');
imshow(x)
[H,W]=size(x);
B=x(10:floor(H/3),:);
G=x(floor(H/3):floor(H/3*2)-10,:);
R=x(floor(H/3*2)+11:H,:);
[hei,wid]=size(R);
% OFF=10
OFF=50
pad_size=[OFF OFF]
EdgeB = edge(B,'Canny');
EdgeG = edge(G,'Canny');
EdgeR = edge(R,'Canny');

for iteration=1:3 %RGB CROP
    xtag=0;
    ytag=0;
    for i=1:wid
        if xtag==2
            xshift=i-1;
            break
        elseif sum(sum(EdgeR(:,i)))>0 && xtag<2
            xtag=xtag+1
        end

    end
    for i=1:hei
        if ytag==2
            yshift=i-1;
            break
        elseif sum(sum(EdgeR(i,:)))>0 && ytag<2
           ytag=ytag+1
        end

    end
end

CropB=B(yshift:yshift+hei-40,xshift:xshift+wid-40);
CropG=G(yshift:yshift+hei-40,xshift:xshift+wid-40);
CropR=R(yshift:yshift+hei-40,xshift:xshift+wid-40);


[cropY,cropX]=size(CropR);
R = padarray(CropB,pad_size,0,'both');
G = padarray(CropG,pad_size,0,'both');
B = padarray(CropR,pad_size,0,'both');
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
% for offsetX=-OFF+1:OFF-1
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
RGB=zeros(cropY+1,cropX+1,3);
RGB(:,:,3)=R(OFF:cropY+OFF,OFF:cropX+OFF);
RGB(:,:,2)=G(GoffsetY+OFF:GoffsetY+OFF+cropY,GoffsetX+OFF:GoffsetX+OFF+cropX);
RGB(:,:,1)=B(BoffsetY+OFF:BoffsetY+OFF+cropY,BoffsetX+OFF:BoffsetX+OFF+cropX);
RGB=uint8(RGB);
figure()
imshow(RGB)
imwrite(RGB,'cathedral_OUT4.jpg')
                