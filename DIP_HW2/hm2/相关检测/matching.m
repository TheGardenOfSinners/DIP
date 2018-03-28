clear 
[filename1,pathname1]=uigetfile('*.*','select an input image');
inputImage = imread([pathname1 filename1]);%读入待匹配图像
[filename2,pathname2]=uigetfile('*.*','select an standard image');
standardImage = imread([pathname2 filename2]);%读入榜样图像

subplot(2,2,1);
imshow(inputImage); 
title('待匹配');%显示待匹配图像

[h1,w1]=size(inputImage);%获取待匹配图像的长和宽

[h2,w2]=size(standardImage);%榜样图像的长和宽

im2 = [inputImage,zeros(h1,w2-1);zeros(h2-1,w1+w2-1)];%扩展图像边缘方便遍历

cValue = zeros(h1,w1);%生成相关值矩阵，利用绝对值之和除以格子数。
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
title('所有位置相关值矩阵的图像');

subplot(2,2,3);
imshow(standardImage);
title('榜样图像');

valueMin = 256;
x = 0;
y = 0;

for i=1:h1-h2+1%获取相关值最小的位置以及相关值。其中边缘值不具有代表性，忽略掉。
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
title(['相关值:' num2str(valueMin) '位置:[' num2str(x) ',' num2str(y) ']']);
outImageFileName = 'outputImage.png';
imwrite(a,[pathname1 outImageFileName]); 

