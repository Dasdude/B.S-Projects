% stop(video);
% flushdata(video);
clc
clear
close all
%% Video Device init
webcamInf = imaqhwinfo('winvideo');
try
video = videoinput(webcamInf.AdaptorName,webcamInf.DeviceIDs{1},'MJPG_640x480');
catch err
    video = videoinput(webcamInf.AdaptorName,webcamInf.DeviceIDs{1},webcamInf.DeviceInfo.DefaultFormat);
end
set(video,'triggerrepeat',inf);

%% Particle Filter Parameter 
targetColorHue = [255 0 0];
nParticle = 5000 ;%% Number of Particles
particlePositionVariance = 70;
particleVelocityVariance = 30;
particleHueRange = 30;

noiseRange = [particlePositionVariance ;particleVelocityVariance];
predictionVector = [particlePositionVariance ; particlePositionVariance;particleVelocityVariance;particleVelocityVariance];

%% Application Parameters
FrameCaptureLimit=300;

video.FrameGrabInterval = 1;
resolution=get(video,'videoresolution');
%% Particle Filter
% Creating Particle
pState =BigBang(nParticle,resolution,predictionVector);
start(video);

for frame = 1:FrameCaptureLimit
    %% Image Aqusition
    imager = getdata(video,1);
    flushdata(video);
    image = floor(rgb2hsv(imager)*255);
    %% Updating Particles
    pState = particleUpdate(pState,predictionVector);
    %% Calculate Weights
    particleWeights =weightCalculation(imager , pState,targetColorHue,particleHueRange);
    %% Resampling
    pState = Resampling(pState,particleWeights);
    %% show Particles
    show_particles(pState,imager);
end
stop(video);
delete(video);