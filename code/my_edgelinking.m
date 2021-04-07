function output = my_edgelinking(binary_image, row, col)
%in this function, you should finish the edge linking utility.
%the input parameters are a matrix of a binary image containing the edge
%information and coordinates of one of the edge points of a obeject
%boundary, you should run this function multiple times to find different
%object boundaries
%the output parameter is a Q-by-2 matrix, where Q is the number of boundary 
%pixels. B holds the row and column coordinates of the boundary pixels.
%you can use different methods to complete the edge linking function
%the better the quality of object boundary and the more the object boundaries, you will get higher scores 

%Edge linking using local processing


%Edge linking using local processing

testimg=im2double(imread('rubberband cap.png'));
I = rgb2gray(testimg);

[M,N]=size(I);
n_l=1;
%Sobel算子
s_x=[-1 0 1;
    -2 0 2;
    -1 0 1];
s_y=[-1 -2 -1;
    0 0 0;
    1 2 1];
%定义梯度和角度
gx=zeros(M,N);
gy=zeros(M,N);
f_pad=padarray(I,[n_l,n_l],'replicate');
for i=1:M
    for j=1:N
        Block=f_pad(i:i+2*n_l,j:j+2*n_l);
        gx(i,j)=sum(sum(Block.*s_x));
        gy(i,j)=sum(sum(Block.*s_y));        
    end
end
gx=abs(gx);
gy=abs(gy);
a_s=atan2(gy,gx)*180/pi;
%% 图像二值化
%设置梯度门限
th=0.3;
T_max=max(gy(:));
T_M=T_max*th;
T_A=45;
%计算水平方向
Tx=zeros(M,N);
A_x=90;
for i=1:M
    for j=1:N
            if a_s(i,j)>=A_x-T_A && a_s(i,j)<=A_x+T_A && gy(i,j)>T_M
                Tx(i,j)=1;
        end
    end
end
 
T_max=max(gx(:));
T_M=T_max*th;
T_A=45;
Ty=zeros(M,N);
A_y=0;
for i=1:M
    for j=1:N
            if gx(i,j)>T_M && a_s(i,j)>=A_y-T_A && a_s(i,j)<=A_y+T_A
                Ty(i,j)=1;
        end
    end
end

L=25;
%二值图像沿水平扩展
Tx_pad=padarray(Tx,[0,L-1],'post');
Tx_g=zeros(M,N);
for i=1:M
    for j=1:N
        if Tx_pad(i,j)==1 && Tx_pad(i,j+1)==0
            Block=Tx_pad(i,j+2:j+L-1);
            ind=find(Block==1);
            if ~isempty(ind)                
                ind_Last=j+2+ind(1,length(ind))-1;
                Tx_pad(i,j:ind_Last)=1;
                Tx_g(i,j:ind_Last)=1;
            end
        else
            Tx_g(i,j)=Tx_pad(i,j);
        end
    end
end
%沿垂直方向进行扩展
Ty_pad=padarray(Ty,[L-1,0],'post');
Ty_g=zeros(M,N);
for j=1:N
    for i=1:M
        if Ty_pad(i,j)==1 && Ty_pad(i+1,j)==0
            Block=Ty_pad(i+2:i+L-1,j);
            ind=find(Block==1);
            if ~isempty(ind)                
                ind_Last=i+2+ind(length(ind),1)-1;
                Ty_pad(i:ind_Last,j)=1;
                Ty_g(i:ind_Last,j)=1;
            end
        else
            Ty_g(i,j)=Ty_pad(i,j);
        end
    end
end
T_g=Ty_g+Tx_g;
[g]=ImageThinning(T_g);
imshow(g);
title("my linking")
%% 边缘连接
function [g]=ImageThinning(I)
n_l=1;
%对图进行扩充，四周各加1行、1列的0,以处理边界点
I_pad=padarray(I,[n_l,n_l]);
%获得扩充后的图像大小
[M,N]=size(I_pad);
%寻找图像中值为1的点，记为ind
ind=find(I_pad==1);
ind_c=[];
while ~isequal(ind_c,ind)
    ind_c=ind;
    %保存ind中符合条件的下标
    ind_sub=[];
    %分别向八个方向的相邻元素检查
    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p+1)) && ~isempty(find(ind==p-M+1)) && ~isempty(find(ind==p+M+1)) && isempty(find(ind==p-1)) && isempty(find(ind==p-M-1)) && isempty(find(ind==p+M-1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    %将下标符合条件的数值，从ind中清除
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p+1)) && ~isempty(find(ind==p-M)) && ~isempty(find(ind==p-M+1)) && isempty(find(ind==p-1)) && isempty(find(ind==p+M)) && isempty(find(ind==p+M-1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end   
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p-M-1)) && ~isempty(find(ind==p-M)) && ~isempty(find(ind==p-M+1)) && isempty(find(ind==p+M-1)) && isempty(find(ind==p+M)) && isempty(find(ind==p+M+1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p-1)) && ~isempty(find(ind==p-M)) && ~isempty(find(ind==p-M-1)) &&  isempty(find(ind==p+1)) && isempty(find(ind==p+M)) && isempty(find(ind==p+M+1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end    
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p-M-1)) && ~isempty(find(ind==p-1)) && ~isempty(find(ind==p+M-1)) &&  isempty(find(ind==p-M+1)) && isempty(find(ind==p+1)) && isempty(find(ind==p+M+1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end     
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p-1)) && ~isempty(find(ind==p+M-1)) && ~isempty(find(ind==p+M)) && isempty(find(ind==p+1)) && isempty(find(ind==p-M+1)) && isempty(find(ind==p-M))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end    
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p+M-1)) && ~isempty(find(ind==p+M)) && ~isempty(find(ind==p+M+1)) && isempty(find(ind==p-M-1)) && isempty(find(ind==p-M)) && isempty(find(ind==p-M+1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end   
    ind_sub=[];

    for i=1:length(ind)
        p=ind(i,1);
        if ~isempty(find(ind==p+1)) && ~isempty(find(ind==p+M)) && ~isempty(find(ind==p+M+1)) &&  isempty(find(ind==p-1)) && isempty(find(ind==p-M)) && isempty(find(ind==p-M-1))
            ind_sub=cat(1,ind_sub,i);
        end
    end
    if ~isempty(ind_sub)
        ind(ind_sub)=[];
    end 
end            
%m连通检测
ind_c=[];
while ~isequal(ind_c,ind)
    ind_c=ind;    
    ind_back=ind;    
    while ~isempty(ind_back)
        p=ind_back(1,:);
        %如果p点四联通中有三个值为1，则将该点置为零
        if (~isempty(find(ind==p+1)) && ~isempty(find(ind==p+M)) && ~isempty(find(ind==p-M))) ||  (~isempty(find(ind==p-1)) && ~isempty(find(ind==p+M)) && ~isempty(find(ind==p-M))) || (~isempty(find(ind==p+1)) && ~isempty(find(ind==p-1)) && ~isempty(find(ind==p-M))) ||  (~isempty(find(ind==p+1)) && ~isempty(find(ind==p-1)) && ~isempty(find(ind==p+M)))
            c=find(ind==p);
            ind(c)=[];
        end
        %如果p点四联通中有两个值为1，且其对角为0，则将该点置为零
        if (~isempty(find(ind==p+1)) && ~isempty(find(ind==p+M)) && isempty(find(ind==p-M-1))) ||  (~isempty(find(ind==p-1)) && ~isempty(find(ind==p+M)) && isempty(find(ind==p-M+1))) || (~isempty(find(ind==p+1)) && ~isempty(find(ind==p-M)) && isempty(find(ind==p+M-1))) || (~isempty(find(ind==p-1)) && ~isempty(find(ind==p-M)) && isempty(find(ind==p+M+1)))
            c=find(ind==p);
            ind(c)=[];
        end             
        ind_back(1,:)=[];
    end       
end

%删除扩展的边缘
g=zeros(size(I_pad));
g(ind)=1;
g=g(2:M-1,2:N-1);
end

end

