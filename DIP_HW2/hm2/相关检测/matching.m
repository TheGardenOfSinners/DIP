clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%�����ƥ��ͼ��
[filename2,pathname2]=uigetfile('*.*','select an standard image');
standardImage = imread([pathname2 filename2]);%�������ͼ��

subplot(2,2,1);
imshow(inputImage); 
title('��ƥ��');%��ʾ��ƥ��ͼ��

[h1,w1]=size(inputImage);%��ȡ��ƥ��ͼ��ĳ��Ϳ�

[h2,w2]=size(standardImage);%����ͼ��ĳ��Ϳ�

im2 = [inputImage,zeros(h1,w2-1);zeros(h2-1,w1+w2-1)];%��չͼ���Ե�������

cValue = zeros(h1,w1);%�������ֵ�������þ���ֵ֮�ͳ��Ը�������
for i=1:h1
    for j=1:w1
        for i1=1:h2
            for j1 = 1:w2
                cValue(i,j) = cValue(i,j)+ double(abs(im2(i+i1-1,j+j1-1)-standardImage(i1,j1)));
            end
        end
    end
end

cValue = uint8(round(cValue / (h2*w2)));

subplot(2,2,2);
imshow(cValue);
title('����λ�����ֵ�����ͼ��');

subplot(2,2,3);
imshow(standardImage);
title('����ͼ��');

valueMin = 256;
x = 0;
y = 0;

for i=1:h1-h2+1%��ȡ���ֵ��С��λ���Լ����ֵ�����б�Եֵ�����д����ԣ����Ե���
    for j=1:w1-w2+1
        if cValue(i,j) < valueMin
            valueMin = cValue(i, j);
            x = i;
            y = j;
        end
    end
end

a = inputImage(x:x+h2-1, y:y+w2-1);
subplot(2,2,4);
imshow(a);
title(['���ֵ:' num2str(valueMin) 'λ��:[' num2str(x) ',' num2str(y) ']']);
outImageFileName = 'outputImage.png';
imwrite(a,[pathname1 outImageFileName]); 

