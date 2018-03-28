clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待处理图像
inputImage = rgb2gray(inputImage);
subplot(2,3,1);
imshow(inputImage); 
title('待处理');%显示待处理图像
[h1,w1]=size(inputImage);%获取待处理图像的长和宽

moveImage = double(inputImage);

D0 = [3,5,10,20];


for i=1:h1%对数变换
    for j=1:w1
        moveImage(i,j) = log(moveImage(i,j)+1);
    end
end

Duv = fft2(moveImage);
Duv = fftshift(Duv);

for g = 1:4%四个不同D0
    Guv = Duv;
    n = 1;
    h2 = floor(h1/2);
    w2 = floor(w1/2);
    %BHPF滤波
    for i=1:h1
        for j=1:w1
            d=sqrt((j-w2)^2 + (i-h2)^2);
            Huv = 1/(1+(D0(1,g)/d)^(2 * n));
            Guv(i,j) = Duv(i,j) * Huv;
        end
    end
    Guv = ifftshift(Guv);
    %傅里叶反变换取实部
    OutputImage = real(ifft2(Guv));
    for i=1:h1%指数变换
        for j=1:w1
            OutputImage(i,j) = exp(OutputImage(i,j)) - 1;
        end
    end
    omax = max(max(OutputImage));
    omin = min(min(OutputImage));
    for i=1:h1%处理
        for j=1:w1
            OutputImage(i,j) = floor((OutputImage(i,j)-omin) * 255/(omax-omin));
        end
    end
    aa = num2str(D0(1,g));
    subplot(2,3,1+g);
    OutputImage = uint8(floor(OutputImage));
    imshow(OutputImage,[0 255]);%显示处理后图像
    title(['D0=' aa]);
    imwrite(OutputImage,[pathname1 'Butterworth' aa '.png']);
end