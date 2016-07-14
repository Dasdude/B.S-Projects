%% Demo illustrating Particle Filter applied to object tracking in a video
% 
% Likelihood is based on the Battacharya distance between a reference 
% color pdf and currentparticule color pdf
% 
%%  State Definition
%
%    S_k = A_k S_{k-1} + N(0 , R_k)
%
%    S_k = (x_k , x'_k , y_k , y'_k , H_k^x , H_k^y , theta_k)
%
%
%          |1   delta_k       0        0       0      0     0|
%          |0         1       0        0       0      0     0|
%          |0         0       1  delta_k       0      0     0|
% A  =     |0         0       0        1       0      0     0|
%          |0         0       0        0       1      0     0|
%          |0         0       0        0       0      1     0|
%          |0         0       0        0       0      0     1|
%
% R_k  =   |R_y       0   |
%          |0         R_e |
%
%                 |delta_k^3/3   delta_k^2/2       0        0 |
% R_y  = sigma_y  |delta_k^2/2       delta_k       0        0 |, % Kinematic of
%                 |0         0       delta_k^3/3   delta_k^2/2|  % the ellipsoid
%                 |0         0       delta_k^2/2       delta_k|

%          |sigma_Hx^2        0          0|
% R_e  =   |0        sigma_Hy^2          0|, % Kinematic of
%          |0         0      sigma_theta^2|  % the ellipsoid


tic
clc
clear all, close all hidden
filename = '13';
fileExtension = '.avi'

video_file        = [filename,fileExtension];
video             = mmreader(video_file , 'tag', 'myreader1');

offset_frame      = 900;%80
endOffset_frame=410;
nb_frame          = get(video, 'numberOfFrames') - offset_frame - endOffset_frame;
%nb_frame          = 400;
dim_x             = get(video , 'Width');
dim_y             = get(video , 'Height');
N                 = 5;        % Number of particules
N_threshold       = 6.*N/10;    % Redistribution threshold
delta             = 0.7;

groundTruth = zeros(nb_frame , 2);%1 = x 2 = y 

%***************************************EDIT*******************************
figure(1);
% set(gca , 'drawmode' , 'fast');
% set(gcf , 'doublebuffer','on');
% set(gcf , 'renderer' , 'zbuffer');
for k = 1 :nb_frame;
I                = read(video , offset_frame + k);
% ind_k = 1:k
figure(1);
image(I);
% imshow(I);
% hold off
hold on
plot(groundTruth( 1:k-1,1) , groundTruth( 1:k-1,2),'b','linewidth',2 )
TargetCenter=ginput(1)
groundTruth(k,:)=[TargetCenter(1),TargetCenter(2)]';


 %Trajectory
 
save('GroundTruth.mat','groundTruth');
end
