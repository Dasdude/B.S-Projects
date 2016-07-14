function [MSE , processTime] = MyParticle( N,offset_frame,endOffset_frame,filename,calculateHomographyFlag,selectTarget,TargetNumber,testNumber,runNumber )
%MYPARTICLE Summary of this function goes here
%   [MSE] = MyParticle( N,offset_frame,endOffset_frame,filename,calculateHomographyFlag,selectTarget,TargetNumber,testNumber )
%% Demo illustrating Particle Filter applied to object tracking in a video


clc
% clear all, close all hidden
tic

fileExtension = '.avi'

video_file        = [filename,fileExtension];
video             = VideoReader(video_file , 'tag', 'myreader1');

nb_frame          = get(video, 'numberOfFrames') - offset_frame - endOffset_frame ;

% nb_frame =200;
dim_x             = get(video , 'Width');
dim_y             = get(video , 'Height');
N_threshold       = 6.*N/10;    % Redistribution threshold
delta             = 0.7;
eq = zeros(3,1);

%%%%% Color Cue parameters %%%%%%%%

Npdf              = 200;       % Number of samples to draw inside ellipse to evaluate color histogram
Nx                = 20;         % Number of bins in first color dimension (R or H)
Ny                = 20;         % Number of bins in second color dimension (G or S)
Nz                = 20;         % Number of bins in third color dimension (B or V)
sigma_color       = 0.20;      % Measurement Color noise
nb_hist           = 256;
range             = 1;
pos_index         = [1 , 3];
ellipse_index     = [5 , 6 , 7];
d                 = 4;
M                 = Nx*Ny*Nz;
vect_col          = (0:range/(nb_hist - 1):range);%% Pdf Bins Vector
I                 = read(video , offset_frame + 1);
% aviobj = avifile(['r N=' int2str(N) '.avi'],'compression','Indeo5');
'Proposed Method'
['Total Particle: ' num2str(N)]
['Test Number: ' num2str(testNumber)]
qqqString = [filename '/Target ' int2str(TargetNumber) '/Run ' int2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/Videos/Test #' int2str(testNumber)];
% aviobj = VideoWriter([filename '/Target ' int2str(TargetNumber) '/Run ' int2str(run) '/Total Particle ' num2str(N) '/Proposed Method/Videos/Test #' int2str(testNumber)],'MPEG-4');
aviobj = VideoWriter(qqqString,'MPEG-4');
open(aviobj);
%************************Result Variables**************
particlesStateHistory=zeros(nb_frame,N,2);
selectedParticleStateHistory = zeros(nb_frame , 2);
particlesWeightHistory = zeros(nb_frame , N);
varianceState = zeros(nb_frame,1);
%***************************************EDIT*******************************
if (exist([filename '/Input Data/Homography.mat'])==2 && calculateHomographyFlag==0)
    load([filename '/Input Data/Homography.mat']);
    if(selectTarget==0&&exist([filename '/Input Data/Target ' int2str(TargetNumber) ' Position.mat'])==2 )    
        load([filename '/Input Data/Target ' int2str(TargetNumber) ' Position.mat'])
        
        wToH =eq(1)/eq(2);
    else 
        
fig1 = figure(1);
image(I);
% display('Enter Target Center');
% yq=ginput(1);
% yq=yq';
clc;
display('Enter Target Side'); 
TargetWidth=ginput(1)
TargetWidth2=ginput(1)
% TargetWidth = abs(floor(TargetWidth(1))-floor(yq(1)));

clc;
display('Enter Target Top');
TargetHeight = ginput(1);
TargetHeight2 = ginput(1);
yq = [abs(floor((floor(TargetWidth(1))+floor(TargetWidth2(1)))/2)),abs(floor((floor(TargetHeight(2))+floor(TargetHeight2(2)))/2))  ];
yq = yq';
    TargetHeight = abs(floor((floor(TargetHeight(2))-floor(TargetHeight2(2)))/2));
    TargetWidth = abs(floor((floor(TargetWidth(1))-floor(TargetWidth2(1)))/2));
eq = [TargetWidth ; TargetHeight ; 0]
wToH =TargetWidth/TargetHeight;
save([filename '/Input Data/Target ' int2str(TargetNumber) ' Position.mat'],'eq','yq');
end
else
fig1 = figure(1);
image(I);
% display('Enter Target Center');
% yq=ginput(1);
% yq=yq';
clc;
display('Enter Target Side'); 
TargetWidth=ginput(1);
TargetWidth2=ginput(1);
% TargetWidth = abs(floor(TargetWidth(1))-floor(yq(1)));

clc;
display('Enter Target Top');
TargetHeight = ginput(1);
TargetHeight2 = ginput(1);
yq = [abs(floor((floor(TargetWidth(1))+floor(TargetWidth2(1)))/2)),abs(floor((floor(TargetHeight(2))+floor(TargetHeight2(2)))/2))  ];
yq = yq';
% TargetHeight = abs(floor(TargetHeight(2))-floor(yq(2)));
 TargetHeight = abs(floor((floor(TargetHeight(2))-floor(TargetHeight2(2)))/2));
 TargetWidth = abs(floor((floor(TargetWidth(1))-floor(TargetWidth2(1)))/2));
eq                = [TargetWidth ; TargetHeight ; 0]
wToH =TargetWidth/TargetHeight
close(fig1);
% **************************Homography Calculation**************************
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
    figure(1);
    image(I);
end
close(fig1);
homographyMatrix=HomographyCalculator(HOMOGRAPHYSAMPLES);
save([filename '/Input Data/Homography.mat'],'homographyMatrix','eq','yq','wToH');
end
%%%%%% Initialization distribution initialization %%%%

Sk                = zeros(d , 1);
Sk(pos_index)     = yq;
% Initial State covariance %

sigmax1           = 60;         % pixel % 
sigmavx1          = 1;          % pixel / frame %
sigmay1           = 60;         % pixel  %
sigmavy1          = 1;          % pixel / frame %
% State Covariance %
% a) Position covariance %
sigmay            = sqrt(0.35);
%%%%%%%%%%%%%%%%%%%% State transition matrix %%%%%%%%%%%%%%%%%%%%%%

A                 = [1 delta 0 0  ; 0 1 0 0  ; 0 0 1 delta ; 0 0 0 1 ];
By                = [1 0 0 0 0 0 0 ; 0 0 1 0 0 0 0];
%%%%%% Initial State Covariance %%%%%

R1                = diag([sigmax1 , sigmavx1 , sigmay1 , sigmavy1].^2);

%%%%%% State Covariance %%%%%

Rk                = zeros(d , d);
Ry                = (sigmay^2)*[delta^3/3 delta^2/2 0 0 ; delta^2/2 delta 0 0 ; 0 0 delta^3/3 delta^2/2 ; 0 0 delta^2/2 delta];
Rk(1 : 4  , 1 : 4)= Ry;
Ck                = chol(Rk)';

%%%%%%%% Memory Allocation %%%%%%%

ON                = ones(1 , N);
Od                = ones(d , 1);
Smean             = zeros(d , nb_frame);
objectTrajectory = zeros(2,nb_frame);
targetEllipsemean = zeros(3,nb_frame);
Pcov              = zeros(d , d , nb_frame);
N_eff             = zeros(1 , nb_frame);
cte               = 1/N;
cteN              = cte(1 , ON);
w                 = cteN;
compteur          = 0;
cte1_color        = 1/(2*sigma_color*sigma_color);
cte2_color        = (1/(sqrt(2*pi)*sigma_color));
Depth = zeros(1,nb_frame);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Target Distribution %%%%%%%%%%%%%%

%**************************************************************************


Z                 = double(I);
im                = rgb2hsv_mex(Z);

% C1                = cumsum(histc(reshape(im(: , : , 1) , dim_x*dim_y , 1) , vect_col))/(dim_x*dim_y);% CDF of image Color Distribution
% C2                = cumsum(histc(reshape(im(: , : , 2) , dim_x*dim_y , 1) , vect_col))/(dim_x*dim_y);
% C3                = cumsum(histc(reshape(im(: , : , 3) , dim_x*dim_y , 1) , vect_col))/(dim_x*dim_y);
% i1                = sum(C1(: , ones(1 , Nx)) < repmat((0:1/(Nx - 1) : 1) , nb_hist  , 1)); %Cdf of Image in Nx bins
% i2                = sum(C2(: , ones(1 , Ny)) < repmat((0:1/(Ny - 1) : 1) , nb_hist  , 1));
% i3                = sum(C3(: , ones(1 , Nz)) < repmat((0:1/(Nz - 1) : 1) , nb_hist  , 1));
% i1(find(i1==0))=1;
% i2(find(i2==0))=1;
% i3(find(i3==0))=1;
% edge1             = [0 , vect_col(i1(2 : end)) , range];
% edge2             = [0 , vect_col(i2(2 : end)) , range];
% edge3             = [0 , vect_col(i3(2 : end)) , range];
 %********************************************EDITED**********************************
edge1 = [0:1/Nx:1];
edge2 = [0:1/Ny:1];
edge3 = [0:1/Nz:1];
%**************************************************************************************

q                 = pdfcolor_ellipserand(im , yq , eq , Npdf , edge1 , edge2 , edge3);

Q                 = q(: , ON);
fig1              = figure(1);
image(I);
set(gca , 'drawmode' , 'fast');
set(gcf , 'doublebuffer','on');
set(gcf , 'renderer' , 'zbuffer');

%%%%%%%%%%%% Particle initialisation %%%%%%%%

Sk                = Sk(: , ON) + chol(R1)'*randn(d , N);

%%%%%%%%%%%% Main Loop %%%%%%%%%%%%%%%%%%%%%%
 weightHistory = zeros(1,nb_frame);

for k = 1 : nb_frame ;

    Sk               = A*Sk + Ck*randn(d , N);
    I                = read(video , offset_frame + k);
    Z                = double(I);
    im               = rgb2hsv_mex(Z);
    yk               = Sk(pos_index , :);     %yk                = By*Sk;
%     ek               = Sk(ellipse_index , :); %ek                = Be*Sk;
    %********************************************EDIT*************************************
%     ellipsePosition = yk;
    ek(2,:) = topPointFromCenterCalculator(homographyMatrix,yk)/2;
%     ek(2,:) = topPointFromCenterCalculator(homographyMatrix,yk);

    ek(1,:)= ek(2,:)*wToH;
%     Sk(ellipse_index(1:2),:)=ek(1:2,:);
    ek(3,:)=0;

    %%%%%%%%%%  Color Likelihood %%%%%%%%%

    [py , zi , yi]   = pdfcolor_ellipserand(im , yk , ek , Npdf , edge1 , edge2 , edge3);
    rho_py_q         = sum(sqrt(py.*Q));
    likelihood_color = cte2_color*exp((rho_py_q - 1)*cte1_color);
    
%     weightHistory(k) = max(likelihood_color)/sum(likelihood_color);
%    
    w                = w.*likelihood_color;
    
    w                = w/sum(w);
    weightHistory(k) = max(w);
    particlesWeightHistory(k,:) = w;

    %--------------------------- 6) MMSE estimate & covariance -------------------------

    [Smean(: , k) , Pcov(: , : , k)] = part_moment(Sk , w);
    [value maxWIndex] = max(w);
    
    
    ObjectPositionFor3d = Sk(pos_index,maxWIndex);
    objectTrajectory(:,k) = ObjectPositionFor3d;
    ObjectSizeForDepth = ek(1:3,maxWIndex);
%     ObjectSizeForDepth =Smean(ellipse_index,k);
%     ObjectPositionFor3d = Smean(pos_index,k);
    targetEllipsemean(:,k)= ObjectSizeForDepth;
    
    
    Depth(k) = eq(1)/ObjectSizeForDepth(1);
    
        

    %--------------------------- 7) Particles redistribution ? if N_eff < N_threshold -------------------------

    N_eff(k)                         = 1./(sum(w.*w));
%***************EDIT
    if (N_eff(k) < N_threshold)
%       if max(likelihood_color)>.0008
        compteur              = compteur + 1;
        indice_resampling     = particle_resampling(w);
        % Copy particules
        Sk                    = Sk(: , indice_resampling);
        
        w                     = cteN;
%       end
    end
    %%%%%%%%%%%%% Display %%%%%%%%%%%%%%%
    
    fig1              = figure(1);
    image(I);
    title(sprintf('N = %6.3f/%6.3f, Frame = %d, Redistribution =%d , Depth = %d' , N_eff(k) , N_threshold , k , compteur,Depth(k)))
    ind_k             = (1 : k);
    hold on
    ykmean            = Smean(pos_index , k);
%     ekmean            = Smean(ellipse_index, k);
    ykmean = ykmean(1:2,1);
    selectedParticleStateHistory(k , :) = ykmean'; 
%     ekmean = ekmean(1:2,1);
%     ykmean = ObjectPositionFor3d;
    ekmean = ObjectSizeForDepth;
    ekmean(3)=0;
    
    [xmean , ymean]   = ellipse(ykmean , ekmean);
    plot(xmean , ymean , 'g' , 'linewidth' , 3)% Ellipse
    plot(Smean(pos_index(1) , ind_k) , Smean(pos_index(2) , ind_k) , 'r' , 'linewidth' , 2)%Trajectory
    plot(Sk(pos_index(1) , :) , Sk(pos_index(2) , :) , 'b+');% Particles
    hold off
    
    frameResult = getframe(figure(1));
    writeVideo(aviobj,frameResult);
    particlesStateHistory(k,:,:)=[Sk(pos_index(1),:)',Sk(pos_index(2),:)'];
end

%% Display
% 
% figure(3)
% plot(Smean(pos_index(1) , :) , Smean(pos_index(2) , :) , 'linewidth' , 2)
% axis([1 , dim_x , 1 , dim_y ]);
% axis ij
% grid on
% title('trajectory');
% 
% 
% figure(4)
% plot((1 : nb_frame) , targetEllipsemean , 'linewidth' , 2)
% axis([1 , nb_frame , -pi , pi ]);
% xlabel('Frames k');
% ylabel('\theta');
% grid on
% title('Ellipse angle versus frames');
% 
% figure(5);
% h = slice(reshape(q , Nx , Ny , Nz) , (1 : Nx) , (1 : Ny) , (1 : Nz));
% colormap(flipud(cool));
% alpha(h , 0.1);
% brighten(+0.5);
% title('3D Histogram of the Target distribution');
% xlabel('Bin x');
% ylabel('Bin y');
% zlabel('Bin z');
% colorbar
% cameramenu;

% figure(6);
% hold on
% plot(vect_col , C1 , vect_col , C2, vect_col , C3);
% plot(edge1 , C1([1 , i1(2 : end) , nb_hist]) , '+' , edge2 , C2([1 , i2(2 : end) , nb_hist])   ,'*' , edge3 , C3([1 , i3(2 : end) , nb_hist]) ,'p')
% hold off
% ylabel('HSV CDF');


% objectTrajectory(1,:) =-objectTrajectory(1,:)+dim_x/2;
% objectTrajectory(2,:) =- objectTrajectory(2,:)+dim_y/2;
% % object3dTrajectory = [Depth.*objectTrajectory(1,:);Depth.*objectTrajectory(2,:);Depth];
% Depth= Depth*500;
% object3dTrajectory = [objectTrajectory(1,:);objectTrajectory(2,:);sqrt(((Depth).^2)-(objectTrajectory(1,:).^2)-(objectTrajectory(2,:).^2))];
% figure(9);
% plot3(object3dTrajectory(3,:),object3dTrajectory(1,:),object3dTrajectory(2,:),'linewidth', 3);
% axis(4*[.0001*min(Depth) .7*max(Depth) -max(abs(object3dTrajectory(1,:))) max(abs(object3dTrajectory(1,:)))  -max(abs(object3dTrajectory(2,:))) max(abs(object3dTrajectory(2,:))) ]);
% grid on
close(aviobj);

processTime=   toc;

%******************************************RESULT*********************************************************
load([filename '/Input Data/GroundTruth Target #' int2str(TargetNumber) '.mat']);
%% Result Calculation
% groundTruth 
% ykmean(1:2,1);
ErrorPerFrame = sum((groundTruth -selectedParticleStateHistory).^2,2);
MSE = (sum(sum((groundTruth - selectedParticleStateHistory).^2,2),1))/nb_frame;
varianceState1 = var(particlesStateHistory(:,:,1),0,2);
varianceState2 = var(particlesStateHistory(:,:,1),0,2);

varianceState = varianceState1+varianceState2;
varianceWeight = var(particlesWeightHistory,0,2);

%% Result Plot1 
%                                   Selected Particle Weight History
figure(2);
plot(1:nb_frame,weightHistory);
% figure(8);
% plot(1:nb_frame,Depth);
xlabel('Frame Index');
ylabel('Weight');
title('Selected Particle Weight History');
saveas(figure(2),[filename '/Target ' int2str(TargetNumber) '/Run ' num2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/Weight History/Test #' ,num2str(testNumber), '.jpg']);
%% Result Plot 2 
%                                   Variance of Particles State in Each Frame
figure(3)
plot(1:nb_frame , varianceState)
xlabel('Frame Index');
ylabel('Variance of States')
title('State Variance Per Frame');
saveas(figure(3),[filename '/Target ' int2str(TargetNumber) '/Run ' num2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/State Variance/Test #' ,num2str(testNumber), '.jpg']);
%% Result Plot 3
%                                   Variance of Particles Weight in Each Frame
figure(4)
plot(1:nb_frame , varianceWeight)
xlabel('Frame Index');
ylabel('Variance of Weights');
title(' Variance of Weights in each Frame');
saveas(figure(4),[filename '/Target ' int2str(TargetNumber) '/Run ' num2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/Weight Variance/Test #' ,num2str(testNumber), '.jpg']);
%% Result Plot 4
%                                   Error of Estimated State From Ground Truth State
figure(5)
plot(1:nb_frame , sqrt(ErrorPerFrame));
xlabel('Frame Index');
ylabel('Error');
title(' Estimation Error Per Frame');
saveas(figure(5),[filename '/Target ' int2str(TargetNumber) '/Run ' num2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/Error/Test #' ,num2str(testNumber), '.jpg']);
%% Result Plot 5 
%                                   Comparison of Ground Truth and Result
figure(6)
plot(groundTruth( :,1) , groundTruth( :,2),'r', 'linewidth',2);
hold on
plot(Smean(pos_index(1) , :) , Smean(pos_index(2) , :) ,'b', 'linewidth' , 2);
xlabel('X');
ylabel('Y');
axis([1 , dim_x , 1 , dim_y ]);
axis ij
grid on
title(' Comparison of Result and Ground Truth Blue:Result Red: Ground Truth');
hold off
saveas(figure(6),[filename '/Target ' int2str(TargetNumber) '/Run ' num2str(runNumber) '/Total Particle ' num2str(N) '/Proposed Method/Comparison to Ground Truth/Test #' ,num2str(testNumber), '.jpg']);

end

