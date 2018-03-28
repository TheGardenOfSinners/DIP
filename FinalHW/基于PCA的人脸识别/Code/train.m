clear
%��ȡͼƬ�ļ���·�����֣��˴���Ҫ��ͼƬ�ļ����������һ��ͼƬ�Ի�ȡͼƬ·����
[~,pathname1]=uigetfile('*.*','select an input image');

%ѵ������(�˲���ѡȡû��ͼƬ��ǰ7����ѵ��)
height=112;
width=92;
group=40;
num=7;
imgdata=zeros(height*width,group*num);
%�������ݾ���
for i=1:group
    for j=1:num
        a=imread(strcat(pathname1,'\..\s',num2str(i),'\',num2str(j),'.pgm'));
        b=a(1:height*width);%��ͼƬת��Ϊ������
        b=double(b');%ת��Ϊ������
        imgdata(:,(i-1)*7+j)=b;%���뵽��Ӧ��
    end
end
%��ֵ������
imgu=mean(imgdata,2);

%���ڼ���Э��������H����
H=zeros(height*width,group*num);
for i=1:group*num
  H(:,i) = imgdata(:,i)-imgu;
end
%Э�������
Cov=H*H'/(group*num-1);
%���ɷַ���
[PC, ~,~] = pcacov(Cov');
clear Cov H imgu;%��������ͷ��ڴ�
Dimension = 80;%����ά��Ϊ80
lowDimension=(PC(:,1:Dimension))';%��ά����
ldImgData = lowDimension * imgdata;%��ά������ݾ���
clear imgdata PC;

%������ά������
avangeface = zeros(Dimension,group);
for i=1:group
    a = ldImgData(:,(i-1)*num+1:i*num);
    avangeface(:,i)=mean(a,2);%��ֵ
end


%���Բ���(�˲���ѡȡÿ��ͼƬ�ĺ�����������)

test_matrix = zeros(120,2);%��һ�б�ʾ��Ӧ����𣬵ڶ��б�ʾƥ�����
for i=1:group
    for j=1:3
        test_matrix((i-1)*3+j,1) = i;
        a=imread(strcat(pathname1,'\..\s',num2str(i),'\',num2str(j+7),'.pgm'));
        b=a(1:height*width);%��ͼƬת��Ϊ������
        b=double(b');%ת��Ϊ������
        b = lowDimension * b;%��B��ά����
        distance=100000000;%���������پ������ƥ��
        for k=1:group
           d1 = norm((b-avangeface(:,k)),2);
           if d1 < distance
               distance = d1;
               test_matrix((i-1)*3+j,2)=k;
           end
        end
    end
end

clear avangeCov;%��������ͷ��ڴ�
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

%�����������ļ�����
fid = fopen(strcat(pathname1,'..\..\Output\output.txt'),'w');
fprintf(fid,'��ȷ��:�ٷ�֮%.2f \r\n', right_precent);
for i=1:wrong_num
   fprintf(fid,'��%d������ͼ��Ϊs%d��%d.pgm \r\n',i,wrong_matrix(i,1),wrong_matrix(i,2)); 
end
fclose(fid);



