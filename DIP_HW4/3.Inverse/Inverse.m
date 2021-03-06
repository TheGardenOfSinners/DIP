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
D0=70;
n=10;

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
subplot(2,3,2);
imshow(blurringImage);%显示处理后图像
imwrite(blurringImage,[pathname1 'blurring.png']);
title('模糊滤波');
GaussianImage = imnoise(blurringImage,'gaussian',mean,var/(h1*w1));
subplot(2,3,3);
imshow(real(GaussianImage));
title('加高斯噪声');
imwrite(GaussianImage,[pathname1 'gaussian.png']);
%Inverse滤波
F1uv=Guv;
F2uv=Guv;
G=fftshift(fft2(GaussianImage));
for i=1:h1
    for j=1:w1
        u=i-h2;
        v=j-w2;
        F1uv(i,j)=Guv(i,j)/Huv(i,j);
        F2uv(i,j)=G(i,j)/Huv(i,j);
        if (Huv(i,j) < 5e-2)%加门限值
            F2uv(i,j)=0;
        end
        F2uv(i,j)=F2uv(i,j)/(1+(sqrt(u^2+v^2)/D0)^(2*n));%布斯沃特低通
    end
end

InverBlurringImage=real(ifft2(ifftshift(F1uv)));
InverGaussianImage=real(ifft2(ifftshift(F2uv)));
subplot(2,3,4);
imshow(InverBlurringImage);%显示处理后图像
title('逆滤波');
imwrite(InverBlurringImage,[pathname1 '带虚部InverBlurringImage.png']);
subplot(2,3,5);
imshow(InverGaussianImage);%显示处理后图像
title('高斯逆滤波');
imwrite(InverGaussianImage,[pathname1 '带虚部InverGaussianImage.png']);
