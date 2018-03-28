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
K = [0.001 0.005 0.01 0.1];

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
GaussianImage = imnoise(blurringImage,'gaussian',mean,var/(h1*w1));
subplot(2,3,2);
imshow(real(GaussianImage));
title('�Ӹ�˹����');
imwrite(GaussianImage,[pathname1 'gaussian.png']);
%Wiener�˲�
F2uv=Guv;
H2uv = abs(Huv) .^ 2;
G=fftshift(fft2(GaussianImage));
for kkk=1:4
    for i=1:h1
        for j=1:w1
            u=i-h2;
            v=j-w2;
            F2uv(i,j)=G(i,j)*H2uv(i,j)/(Huv(i,j)*(H2uv(i,j)+K(kkk)));

        end
    end

    WienerGaussianIamge=real(ifft2(ifftshift(F2uv)));
    subplot(2,3,2+kkk);
    imshow(WienerGaussianIamge);%��ʾ�����ͼ��
    aa = num2str(K(1,kkk));
    title(['��˹ά���˲�K=' aa]);
    imwrite(WienerGaussianIamge,[pathname1 'WienerGaussianImageK=' aa '.png']);
end
