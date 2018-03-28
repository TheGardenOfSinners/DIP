clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像
subplot(2,3,1);
imshow(inputImage); 
title('待处理');%显示待处理图像
[h1,w1]=size(inputImage);%获取待处理图像的长和宽
h2 = h1/2;
w2 = w1/2;
moveImage = im2double(inputImage);
%给参数赋值
T = 1;
a=0.1;
b=0.1;
mean=0;
var=500;
K = [0.001 0.005 0.01 0.1];

Duv = fft2(moveImage);
Duv = fftshift(Duv);%中心化
Guv = Duv;
Guv2 = Guv;
Huv = Guv;
%BL滤波
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
%傅里叶反变换取实部
blurringImage = real(ifft2(ifftshift(Guv)));
GaussianImage = imnoise(blurringImage,'gaussian',mean,var/(h1*w1));
subplot(2,3,2);
imshow(real(GaussianImage));
title('加高斯噪声');
imwrite(GaussianImage,[pathname1 'gaussian.png']);
%Wiener滤波
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
    imshow(WienerGaussianIamge);%显示处理后图像
    aa = num2str(K(1,kkk));
    title(['高斯维纳滤波K=' aa]);
    imwrite(WienerGaussianIamge,[pathname1 'WienerGaussianImageK=' aa '.png']);
end
