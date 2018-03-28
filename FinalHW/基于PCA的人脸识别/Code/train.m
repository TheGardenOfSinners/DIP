clear
%获取图片文件夹路径部分，此处需要在图片文件夹下随意打开一幅图片以获取图片路径。
[~,pathname1]=uigetfile('*.*','select an input image');

%训练部分(此部分选取没组图片的前7张作训练)
height=112;
width=92;
group=40;
num=7;
imgdata=zeros(height*width,group*num);
%生成数据矩阵
for i=1:group
    for j=1:num
        a=imread(strcat(pathname1,'\..\s',num2str(i),'\',num2str(j),'.pgm'));
        b=a(1:height*width);%将图片转化为行向量
        b=double(b');%转化为列向量
        imgdata(:,(i-1)*7+j)=b;%加入到对应列
    end
end
%均值列向量
imgu=mean(imgdata,2);

%用于计算协方差矩阵的H矩阵
H=zeros(height*width,group*num);
for i=1:group*num
  H(:,i) = imgdata(:,i)-imgu;
end
%协方差矩阵
Cov=H*H'/(group*num-1);
%主成分分析
[PC, ~,~] = pcacov(Cov');
clear Cov H imgu;%清除变量释放内存
Dimension = 80;%设置维数为80
lowDimension=(PC(:,1:Dimension))';%降维矩阵
ldImgData = lowDimension * imgdata;%降维后的数据矩阵。
clear imgdata PC;

%创建降维脸矩阵
avangeface = zeros(Dimension,group);
for i=1:group
    a = ldImgData(:,(i-1)*num+1:i*num);
    avangeface(:,i)=mean(a,2);%均值
end


%测试部分(此部分选取每幅图片的后三张做测试)

test_matrix = zeros(120,2);%第一列表示他应属类别，第二列表示匹配类别。
for i=1:group
    for j=1:3
        test_matrix((i-1)*3+j,1) = i;
        a=imread(strcat(pathname1,'\..\s',num2str(i),'\',num2str(j+7),'.pgm'));
        b=a(1:height*width);%将图片转化为行向量
        b=double(b');%转化为列向量
        b = lowDimension * b;%对B降维处理
        distance=100000000;%运用曼哈顿距离进行匹配
        for k=1:group
           d1 = norm((b-avangeface(:,k)),2);
           if d1 < distance
               distance = d1;
               test_matrix((i-1)*3+j,2)=k;
           end
        end
    end
end

clear avangeCov;%清除数据释放内存
right_num = 0;
wrong_num = 0;
wrong_matrix = zeros(120,2);
for i=1:120
    if (test_matrix(i,1) == test_matrix(i,2))
        right_num = right_num + 1;
    else
        wrong_num = wrong_num + 1;
        wrong_matrix(wrong_num,1) = floor(i / 3);
        wrong_matrix(wrong_num,2) = mod(i,3)+7;
    end
end
right_precent = right_num / 120 * 100;

%将结果输出到文件里面
fid = fopen(strcat(pathname1,'..\..\Output\output.txt'),'w');
fprintf(fid,'正确率:百分之%.2f \r\n', right_precent);
for i=1:wrong_num
   fprintf(fid,'第%d个错误图像为s%d的%d.pgm \r\n',i,wrong_matrix(i,1),wrong_matrix(i,2)); 
end
fclose(fid);



