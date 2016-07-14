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



clc
clear all, close all hidden
close all
filename = '7';
fileExtension = '.avi';
video_file        = [filename,fileExtension];
video             = mmreader(video_file , 'tag', 'myreader1');
offset_frame      = 0;%80
nb_frame          = get(video, 'numberOfFrames') - offset_frame ;
% nb_frame          = 500;
dim_x             = get(video , 'Width');
dim_y             = get(video , 'Height');
N                 = 200;        % Number of particules
N_threshold       = 1.*N/10;    % Redistribution threshold
delta             = 0.7;

%%%%% Color Cue parameters %%%%%%%%

Npdf              = 100;       % Number of samples to draw inside ellipse to evaluate color histogram
Nx                = 20;         % Number of bins in first color dimension (R or H)
Ny                = 20;         % Number of bins in second color dimension (G or S)
Nz                = 20;         % Number of bins in third color dimension (B or V)
sigma_color       = 0.20;      % Measurement Color noise
nb_hist           = 256;
range             = 1;
pos_index         = [1 , 3];
ellipse_index     = [5 , 6 , 7];
d                 = 7;
M                 = Nx*Ny*Nz;
vect_col          = (0:range/(nb_hist - 1):range);%% Pdf Bins Vector

%%%%%% Target Localization for computing the target distribution %%%%

yq                = [185 ; 100]; %Ellipse Initial Position
% eq                = [14 ; 20 ; pi/3]; % Elipse Initial Size And Rotation
eq                = [14 ; 20 ; 0]; % Elipse Initial Size And Rotation
global wToH;
global HOMOGRAPHYMATRIX;
I                 = read(video , offset_frame + 1);
%***************************************EDIT*******************************
if exist([filename,'.mat'])==2
    load([filename,'.mat'])
    HOMOGRAPHYMATRIX=homographyMatrix;
else
    
fig1 = figure(1);
image(I);
yq=ginput(1);
yq=yq'
pause;
TargetWidth=ginput(2)
TargetWidth = abs(floor(TargetWidth(1,1))-floor(TargetWidth(2,1)));
TargetHeight = ginput(2)
TargetHeight = abs(floor(TargetHeight(1,2))-floor(TargetHeight(2,2)));
eq                = [TargetWidth/2 ; TargetHeight/2 ; 0]

wToH =TargetWidth/TargetHeight;
close(fig1);
%**************************Homography Calculation**************************
Homography = zeros(3,3);
totalHomographySamples=input('Enter Required Samples For Homography \n');
global HOMOGRAPHYSAMPLES;
global HOMOGRAPHYSAMPLESCOUNT;

HOMOGRAPHYSAMPLES = zeros (2,2,totalHomographySamples)% (Bottom , Top, SampleNo)
HOMOGRAPHYSAMPLESCOUNT =1;
fig1 = figure(1);
set(fig1,'KeyPressFcn',@Listener);
for k = 1:nb_frame
    if(HOMOGRAPHYSAMPLESCOUNT>totalHomographySamples)
        break;
    end
    I=read(video,offset_frame+k);
%     I =imresize(I,6);
    figure(1);
    image(I);
end
close(fig1);
homographyMatrix=HomographyCalculator(HOMOGRAPHYSAMPLES);

end
%%%%%% Initialization distribution initialization %%%%
fig1              = figure(1);
set(fig1 , 'KeyPressFcn', @HomographyChecker);
for k=1:nb_frame

    %%%%%%%%%%%%% Display %%%%%%%%%%%%%%%
    
    I                = read(video , offset_frame + k);
    image(I);

end

%% Display

