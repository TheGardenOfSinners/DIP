clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像
[filename2,pathname2]=uigetfile('*.*','select an standard image');
standardImage = imread([pathname2 filename2]);%读入榜样图像

subplot(3,2,1);
imshow(inputImage); 
title('待处理');%显示待处理图像

[height1,width1]=size(inputImage);%获取待处理图像的长和宽

pdf1 = zeros(1,256);
for i = 1:height1
   for j = 1:width1
       pdf1(inputImage(i,j)+1) = pdf1(inputImage(i,j)+1)+1;
   end
end  
pdf1 = pdf1 / (height1 * width1);%计算概率分布函数。
subplot(3,2,2);
stem(pdf1);
title('计算待处理图像概率分布直方图');

cdf1 = zeros(1,256);
cdf1(1) = pdf1(1);
for i=2:256
    cdf1(i)=cdf1(i-1)+pdf1(i);
end         %计算累积分布函数


subplot(3,2,3);
imshow(standardImage);
title('榜样图像');%显示榜样图像

[height2,width2]=size(standardImage);%获取榜样图像的长和宽

pdf2 = zeros(1,256);
for i = 1:height2
   for j = 1:width2
       pdf2(standardImage(i,j)+1) = pdf2(standardImage(i,j)+1)+1;
   end
end  
pdf2 = pdf2/ (height2 * width2);%计算概率分布函数。
subplot(3,2,4);
stem(pdf2);
title('计算榜样图像概率分布直方图');

cdf2 = zeros(1,256);
cdf2(1) = pdf2(1);
for i=2:256
    cdf2(i)=cdf2(i-1)+pdf2(i);
end         %计算榜样累积分布函数


% 获取榜样灰度级别对应的待处理图像的灰度级别 佢绝对值相差最小的  
Map   = zeros(1,256);  
for idx = 1 : 256  
    [tmp,ind] = min(abs(cdf1(idx) - cdf2));
    Map(idx)    = ind-1;  
end
   
% 替换灰度值
myImage  = inputImage;
for i=1:height1
   for j=1:width1
      myImage(i,j) = Map(myImage(i,j) - 1);
    end
end  

pdf3 = zeros(1,256);
for i=1:height1
   for j=1:width1
       pdf3(myImage(i,j)+1)= pdf3(myImage(i,j)+1)+1;
    end
end 
pdf3 = pdf3 / (height1 * width1);
%自己算法得出的概率密度函数
subplot(3,2,6);
stem(pdf3);
title('自己的算法图像概率分布直方图');

myImageFileName = 'myImage.png';
imwrite(myImage,[pathname1 myImageFileName]); 
subplot(3,2,5);
imshow(myImage);               
title('匹配图像');%显示自己的图像