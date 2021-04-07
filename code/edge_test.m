%DIP16 Assignment 2
%Edge Detection
%In this assignment, you should build your own edge detection and edge linking 
%function to detect the edges of a image.
%Please Note you cannot use the build-in matlab edge and bwtraceboundary function
%We supply four test images, and you can use others to show your results for edge
%detection, but you just need do edge linking for rubberband_cap.png.
clc; clear all;
% Load the test image
imgTest = im2double(imread('rubberband cap.png'));
imgTestGray = rgb2gray(imgTest);
figure; clf;
imshow(imgTestGray);

%now call your function my_edge, you can use matlab edge function to see
%the last result as a reference first
img_edge = edge(imgTestGray);
figure,imshow(img_edge);
title("matlab�Դ�edge")
%img_edge = my_edge(filter_gray_image);%???

%img_edge = my_edge(imgTestGray);
% figure,imshow(img_edge);
% title("my_edge���")

figure;clf;
background = im2bw(imgTest, 1);
imshow(background);
%using imtool, you select a object boundary to trace, and choose
%an appropriate edge point as the start point 
imtool(img_edge);
%now call your function my_edgelinking, you can use matlab bwtraceboundary 
%function to see the last result as a reference first. please trace as many 
%different object boundaries as you can, and choose different start edge points.
Bxpc = bwtraceboundary(img_edge, [197, 329], 'N');
%Bxpc = my_edgelinking(img_edge, 197, 329);
hold on
plot(Bxpc(:,2), Bxpc(:,1), 'w', 'LineWidth', 2);