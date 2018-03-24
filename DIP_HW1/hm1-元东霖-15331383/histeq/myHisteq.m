[filename,pathname]=uigetfile('*.*','select an image');
inputImage = imread([pathname filename]);%����ͼ��

subplot(3,2,1);
imshow(inputImage);                                 
title('ԭʼͼ��');%��ʾԭʼͼ��

[height,width]=size(inputImage);%��ȡ���Ϳ�

pdf1 = zeros(1,256);
for i = 1:height
   for j = 1:width
       pdf1(inputImage(i,j)+1) = pdf1(inputImage(i,j)+1)+1;
   end
end  
pdf1 = pdf1 / (height * width);%������ʷֲ�������pdf = T(inputImage)�Ĺ��̡�
subplot(3,2,2);
stem(pdf1);
title('�������ûҶ�ͼ����ʷֲ�ֱ��ͼ');

cdf1 = zeros(1,256);
cdf1(1) = pdf1(1);
for i=2:256
    cdf1(i)=cdf1(i-1)+pdf1(i);
end         %�����ۻ��ֲ�����

for i=1:256
    cdf1(i) = round(255*cdf1(i));%��������ȡ��
end

myImage=inputImage;
for i=1:height
   for j=1:width
       myImage(i,j)= cdf1(inputImage(i,j)+1) - 1;
    end
end
%�õ����⻯���ͼ��T(myImage) = cdf��������̵ó�myImage��

pdf2 = zeros(1,256);
for i=1:height
   for j=1:width
       pdf2(myImage(i,j)+1)= pdf2(myImage(i,j)+1)+1;
    end
end  
pdf2 = pdf2 / (height * width);
%�Լ��㷨�ó��ĸ����ܶȺ���
subplot(3,2,4);
stem(pdf2);
title('�Լ����㷨ͼ����ʷֲ�ֱ��ͼ');

myImageFileName = 'myImage.png';
imwrite(myImage,[pathname myImageFileName]); 
subplot(3,2,3);
imshow(myImage);                          
title('�Լ����㷨��ͼ��');%��ʾ�Լ���ͼ��

ApiImage = histeq(inputImage);
%ApiImage = histeq(inputImage, 256);
apiImageFileName = 'apiImage.png';
%apiImageFileName = 'apiImage256.png';
imwrite(ApiImage,[pathname apiImageFileName]); 
subplot(3,2,5);
imshow(ApiImage);
title('��ʾmatlab�Դ�������ͼ��');%��ʾmatlab�Դ�������ͼ��

pdf3 = zeros(1,256);
for i=1:height
   for j=1:width
       pdf3(ApiImage(i,j)+1)= pdf3(ApiImage(i,j)+1)+1;
    end
end  
pdf3 = pdf3 / (height * width);
subplot(3,2,6);
stem(pdf3);
title('��ʾmatlab�Դ������ĸ��ʷֲ�ֱ��ͼ');%MATLAB�Դ������ó��ĸ����ܶȺ���
