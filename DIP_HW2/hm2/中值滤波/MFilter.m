clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像

subplot(2,3,1);
imshow(inputImage); 
title('待处理');%显示待处理图像

[h1,w1]=size(inputImage);%获取待处理图像的长和宽
%P2=imnoise(inputImage,'salt & pepper',0.1);%自带的椒盐噪声生成图像

t1 = uint8(round((rand(h1, w1)*255))); %生成T1

t2 = uint8(round((rand(h1, w1)*255)));%生成T2

subplot(2,3,2);
imshow(t1);
title('T1');
subplot(2,3,3);
imshow(t2);
title('T2');

jyImage = zeros(h1,w1);
for i=1:h1%按照给定方法生成椒盐图像
    for j=1:w1
        if (inputImage(i,j) > t1(i,j) && inputImage(i,j)>t2(i,j))
            jyImage(i,j)=255;
        elseif (inputImage(i,j) < t1(i,j) && inputImage(i,j)<t2(i,j))
            jyImage(i,j)=0;
        else
            jyImage(i,j)=inputImage(i,j);
        end
    end
end

jyImage = uint8(jyImage);

subplot(2,3,4);
%imshow(P2)
imshow(jyImage,[0,255]);
title('椒盐图像');%显示椒盐图像

apiImage = medfilt2(jyImage);
apiImage = uint8(apiImage);

subplot(2,3,6);
imshow(apiImage,[0,255]);
title('medfilt2图像');%medfilt2图像

medImage = jyImage;
%medImage = P2;%自带的椒盐噪声生成
for i=1:h1-2
    for j=1:w1-2
        mm = zeros(1,9);
        for i1=0:2
            for j1=0:2
                mm(i1*3+j1+1) = jyImage(i+i1,j+j1);
                %mm(i1*3+j1+1) = P2(i+i1,j+j1);%利用自带的椒盐噪声生成器
            end
        end
        medImage(i+1,j+1) = median(mm,2);
    end
end
medImage = uint8(medImage);
subplot(2,3,5);
imshow(medImage,[0,255]);
title('自己算法的中值滤波图像');%自己算法图像
imwrite(medImage,[pathname1 '中值滤波图像.png']);
imwrite(apiImage,[pathname1 'medfilt2图像.png']);
imwrite(jyImage,[pathname1 '椒盐图像.png']);

