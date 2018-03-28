clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像
subplot(1,2,1);
imshow(inputImage); 
title('待处理');%显示待处理图像
[h1,w1]=size(inputImage);%获取待处理图像的长和宽

%给参数赋值
mean = 0;
var = 500;
OutputImage = imnoise(inputImage,'gaussian',mean,var/(h1*w1));
subplot(1,2,2);
imshow(OutputImage,[0 255]);%显示处理后图像
title('加上噪声后');
imwrite(OutputImage,[pathname1 'gaussian.png']);