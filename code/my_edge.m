function output = my_edge(input_image)
%in this function, you should finish the edge detection utility.
%the input parameter is a matrix of a gray image
%the output parameter is a matrix contains the edge index using 0 and 1
%the entries with 1 in the matrix shows that point is on the edge of the
%image
%you can use different methods to complete the edge detection function
%the better the final result and the more methods you have used, you will get higher scores 

%I = im2double(imread('rubberband cap.png'));
I = im2double(imread('noise.jpg'));
grayPic = rgb2gray(I);
[m,n]=size(grayPic);
%%
output = edge(grayPic);
figure,imshow(output);
%% using Roberts operator
robertThreshold=0.2;%ãÐÖµ
for j=1:m-1
    for k=1:n-1
        robertsNum = abs(grayPic(j,k)-grayPic(j+1,k+1)) + abs(grayPic(j+1,k)-grayPic(j,k+1));
        if(robertsNum > robertThreshold)
            output(j,k)=255;
        else
            output(j,k)=0;
        end
    end
end
figure,subplot(2,2,1),imshow(output);
title('Roberts')

%% using laplacian

LaplacianThreshold=0.2;
for j=2:m-1 
    for k=2:n-1
        LaplacianNum=abs(4*grayPic(j,k)-grayPic(j-1,k)-grayPic(j+1,k)-grayPic(j,k+1)-grayPic(j,k-1));
        if(LaplacianNum > LaplacianThreshold)
            output(j,k)=255;
        else
            output(j,k)=0;
        end
    end
end
subplot(2,2,2),imshow(output);
title('Laplace')

%% using prewitt operator
PrewittThreshold=0.4;
for j=2:m-1 
    for k=2:n-1
        PrewittNum=abs(grayPic(j-1,k+1)-grayPic(j+1,k+1)+grayPic(j-1,k)-grayPic(j+1,k)+grayPic(j-1,k-1)-grayPic(j+1,k-1))+abs(grayPic(j-1,k+1)+grayPic(j,k+1)+grayPic(j+1,k+1)-grayPic(j-1,k-1)-grayPic(j,k-1)-grayPic(j+1,k-1));
        if(PrewittNum > PrewittThreshold)
            output(j,k)=255;
        else
            output(j,k)=0;
        end
    end
end
subplot(2,2,3),imshow(output);
title('Prewitt')

%% using Sobel operator
sobelThreshold=0.4;
for j=2:m-1
    for k=2:n-1
        sobelNum=abs(grayPic(j-1,k+1)+2*grayPic(j,k+1)+grayPic(j+1,k+1)-grayPic(j-1,k-1)-2*grayPic(j,k-1)-grayPic(j+1,k-1))+abs(grayPic(j-1,k-1)+2*grayPic(j-1,k)+grayPic(j-1,k+1)-grayPic(j+1,k-1)-2*grayPic(j+1,k)-grayPic(j+1,k+1));
        if(sobelNum > sobelThreshold)
            output(j,k)=255;
        else
            output(j,k)=0;
        end
    end
end
subplot(2,2,4),imshow(output);
title('Sobel')

end