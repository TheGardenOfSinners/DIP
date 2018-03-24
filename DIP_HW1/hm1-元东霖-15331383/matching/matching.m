clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%���������ͼ��
[filename2,pathname2]=uigetfile('*.*','select an standard image');
standardImage = imread([pathname2 filename2]);%�������ͼ��

subplot(3,2,1);
imshow(inputImage); 
title('������');%��ʾ������ͼ��

[height1,width1]=size(inputImage);%��ȡ������ͼ��ĳ��Ϳ�

pdf1 = zeros(1,256);
for i = 1:height1
   for j = 1:width1
       pdf1(inputImage(i,j)+1) = pdf1(inputImage(i,j)+1)+1;
   end
end  
pdf1 = pdf1 / (height1 * width1);%������ʷֲ�������
subplot(3,2,2);
stem(pdf1);
title('���������ͼ����ʷֲ�ֱ��ͼ');

cdf1 = zeros(1,256);
cdf1(1) = pdf1(1);
for i=2:256
    cdf1(i)=cdf1(i-1)+pdf1(i);
end         %�����ۻ��ֲ�����


subplot(3,2,3);
imshow(standardImage);
title('����ͼ��');%��ʾ����ͼ��

[height2,width2]=size(standardImage);%��ȡ����ͼ��ĳ��Ϳ�

pdf2 = zeros(1,256);
for i = 1:height2
   for j = 1:width2
       pdf2(standardImage(i,j)+1) = pdf2(standardImage(i,j)+1)+1;
   end
end  
pdf2 = pdf2/ (height2 * width2);%������ʷֲ�������
subplot(3,2,4);
stem(pdf2);
title('�������ͼ����ʷֲ�ֱ��ͼ');

cdf2 = zeros(1,256);
cdf2(1) = pdf2(1);
for i=2:256
    cdf2(i)=cdf2(i-1)+pdf2(i);
end         %��������ۻ��ֲ�����


% ��ȡ�����Ҷȼ����Ӧ�Ĵ�����ͼ��ĻҶȼ��� �ھ���ֵ�����С��  
Map   = zeros(1,256);  
for idx = 1 : 256  
    [tmp,ind] = min(abs(cdf1(idx) - cdf2));
    Map(idx)    = ind-1;  
end
   
% �滻�Ҷ�ֵ
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
%�Լ��㷨�ó��ĸ����ܶȺ���
subplot(3,2,6);
stem(pdf3);
title('�Լ����㷨ͼ����ʷֲ�ֱ��ͼ');

myImageFileName = 'myImage.png';
imwrite(myImage,[pathname1 myImageFileName]); 
subplot(3,2,5);
imshow(myImage);               
title('ƥ��ͼ��');%��ʾ�Լ���ͼ��