function [ output_args ] = Webcam_Function(FrameCaptureLimit,nParticle,targetColorHue,particlePositionVariance,particleVelocityVariance,particleHueRange  )
%WEBCAM_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
%% Video Device init
webcamInf = imaqhwinfo('winvideo');
try
video = videoinput(webcamInf.AdaptorName,webcamInf.DeviceIDs{1},'MJPG_640x480');
catch err
    video = videoinput(webcamInf.AdaptorName,webcamInf.DeviceIDs{1},webcamInf.DeviceInfo.DefaultFormat);
end
set(video,'triggerrepeat',inf);

%% Particle Filter Parameter 
noiseRange = [particlePositionVariance ;particleVelocityVariance];
predictionVector = [particlePositionVariance ; particlePositionVariance;particleVelocityVariance;particleVelocityVariance];

%% Application Parameters
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

end

