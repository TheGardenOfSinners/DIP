clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%���������ͼ��
subplot(2,3,1);
imshow(inputImage); 
title('������');%��ʾ������ͼ��
[h1,w1]=size(inputImage);%��ȡ������ͼ��ĳ��Ϳ�
h2 = h1/2;
w2 = w1/2;
moveImage = im2double(inputImage);
%��������ֵ
T = 1;
a=0.1;
b=0.1;
mean=0;
var=500;
D0=70;
n=10;

Duv = fft2(moveImage);
Duv = fftshift(Duv);%���Ļ�
Guv = Duv;
Guv2 = Guv;
Huv = Guv;
%BL�˲�
for i=1:h1
    for j=1:w1
        u=i-h2;
        v=j-w2;
        Huv(i,j) = (T/(pi*(u*a+v*b)))*sin(pi*(u*a+v*b))*exp(-(1i)*pi*(u*a+v*b));
        if (Huv(i,j) == 0 || isnan(Huv(i,j)))
            Huv(i,j) = 1e-6;
        end
        Guv(i,j)=Duv(i,j)*Huv(i,j);
        Guv2(i,j)=Duv(i,j)*Huv(i,j);
    end
end
%����Ҷ���任ȡʵ��
blurringImage = real(ifft2(ifftshift(Guv)));
subplot(2,3,2);
imshow(blurringImage);%��ʾ�����ͼ��
imwrite(blurringImage,[pathname1 'blurring.png']);
title('ģ���˲�');
GaussianImage = imnoise(blurringImage,'gaussian',mean,var/(h1*w1));
subplot(2,3,3);
imshow(real(GaussianImage));
title('�Ӹ�˹����');
imwrite(GaussianImage,[pathname1 'gaussian.png']);
%Inverse�˲�
F1uv=Guv;
F2uv=Guv;
G=fftshift(fft2(GaussianImage));
for i=1:h1
    for j=1:w1
        u=i-h2;
        v=j-w2;
        F1uv(i,j)=Guv(i,j)/Huv(i,j);
        F2uv(i,j)=G(i,j)/Huv(i,j);
        if (Huv(i,j) < 5e-2)%������ֵ
            F2uv(i,j)=0;
        end
        F2uv(i,j)=F2uv(i,j)/(1+(sqrt(u^2+v^2)/D0)^(2*n));%��˹���ص�ͨ
    end
end

InverBlurringImage=real(ifft2(ifftshift(F1uv)));
InverGaussianImage=real(ifft2(ifftshift(F2uv)));
subplot(2,3,4);
imshow(InverBlurringImage);%��ʾ�����ͼ��
title('���˲�');
imwrite(InverBlurringImage,[pathname1 '���鲿InverBlurringImage.png']);
subplot(2,3,5);
imshow(InverGaussianImage);%��ʾ�����ͼ��
title('��˹���˲�');
imwrite(InverGaussianImage,[pathname1 '���鲿InverGaussianImage.png']);
