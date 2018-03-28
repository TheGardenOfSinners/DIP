clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%���������ͼ��
subplot(1,2,1);
imshow(inputImage); 
title('������');%��ʾ������ͼ��
[h1,w1]=size(inputImage);%��ȡ������ͼ��ĳ��Ϳ�

%��������ֵ
mean = 0;
var = 500;
OutputImage = imnoise(inputImage,'gaussian',mean,var/(h1*w1));
subplot(1,2,2);
imshow(OutputImage,[0 255]);%��ʾ�����ͼ��
title('����������');
imwrite(OutputImage,[pathname1 'gaussian.png']);