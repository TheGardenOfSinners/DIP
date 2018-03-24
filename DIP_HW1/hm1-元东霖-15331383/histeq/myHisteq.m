[filename,pathname]=uigetfile('*.*','select an image');
inputImage = imread([pathname filename]);%读入图像

subplot(3,2,1);
imshow(inputImage);                                 
title('原始图像');%显示原始图像

[height,width]=size(inputImage);%获取长和宽

pdf1 = zeros(1,256);
for i = 1:height
   for j = 1:width
       pdf1(inputImage(i,j)+1) = pdf1(inputImage(i,j)+1)+1;
   end
end  
pdf1 = pdf1 / (height * width);%计算概率分布函数。pdf = T(inputImage)的过程。
subplot(3,2,2);
stem(pdf1);
title('计算所得灰度图像概率分布直方图');

cdf1 = zeros(1,256);
cdf1(1) = pdf1(1);
for i=2:256
    cdf1(i)=cdf1(i-1)+pdf1(i);
end         %计算累积分布函数

for i=1:256
    cdf1(i) = round(255*cdf1(i));%四舍五入取整
end

myImage=inputImage;
for i=1:height
   for j=1:width
       myImage(i,j)= cdf1(inputImage(i,j)+1) - 1;
    end
end
%得到均衡化后的图像。T(myImage) = cdf的逆向过程得出myImage。

pdf2 = zeros(1,256);
for i=1:height
   for j=1:width
       pdf2(myImage(i,j)+1)= pdf2(myImage(i,j)+1)+1;
    end
end  
pdf2 = pdf2 / (height * width);
%自己算法得出的概率密度函数
subplot(3,2,4);
stem(pdf2);
title('自己的算法图像概率分布直方图');

myImageFileName = 'myImage.png';
imwrite(myImage,[pathname myImageFileName]); 
subplot(3,2,3);
imshow(myImage);                          
title('自己的算法的图像');%显示自己的图像

ApiImage = histeq(inputImage);
%ApiImage = histeq(inputImage, 256);
apiImageFileName = 'apiImage.png';
%apiImageFileName = 'apiImage256.png';
imwrite(ApiImage,[pathname apiImageFileName]); 
subplot(3,2,5);
imshow(ApiImage);
title('显示matlab自带函数的图像');%显示matlab自带函数的图像

pdf3 = zeros(1,256);
for i=1:height
   for j=1:width
       pdf3(ApiImage(i,j)+1)= pdf3(ApiImage(i,j)+1)+1;
    end
end  
pdf3 = pdf3 / (height * width);
subplot(3,2,6);
stem(pdf3);
title('显示matlab自带函数的概率分布直方图');%MATLAB自带函数得出的概率密度函数
