clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像
subplot(1,2,1);
imshow(inputImage); 
title('待处理');%显示待处理图像
[h1,w1]=size(inputImage);%获取待处理图像的长和宽
h2 = h1/2;
w2 = w1/2;
moveImage = double(inputImage);
%给参数赋值
T = 1;
a=0.1;
b=0.1;

Duv = fft2(moveImage);
Duv = fftshift(Duv);%中心化
Guv = Duv;
%BL滤波
for i=1:h1
    for j=1:w1
        u=i-h2;
        v=j-w2;
        Huv = (T/(pi*(u*a+v*b)))*sin(pi*(u*a+v*b))*exp(-(1i)*pi*(u*a+v*b));
        if (Huv == 0 || isnan(Huv))
            Huv = 1e-6;
        end
        Guv(i,j) = Duv(i,j) * Huv;
    end
end
Guv = ifftshift(Guv);
%傅里叶反变换取实部
IGuv = ifft2(Guv);
OutputImage = real(ifft2(Guv));
subplot(1,2,2);
OutputImage = uint8(floor(OutputImage));
imshow(OutputImage,[0 255]);%显示处理后图像
title('滤波后');
imwrite(OutputImage,[pathname1 'blurring.png']);