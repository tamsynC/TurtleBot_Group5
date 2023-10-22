clc;
close all;

% Q1
I = imread('Square_v2.png');
I = rgb2gray(I);
cornerPoints = detectHarrisFeatures(I,'MinQuality',0.2);
imshow (I)
hold on;
plot (cornerPoints);
disp(cornerPoints);