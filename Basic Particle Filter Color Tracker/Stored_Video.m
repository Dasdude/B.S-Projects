function [ output_args ] = Stored_Video(VideoName,nParticle,targetColorHue,particlePositionVariance,particleVelocityVariance,particleHueRange  )
%STORED_VIDEO Summary of this function goes here
%   Detailed explanation goes here
%% Video Read
vr = VideoReader(VideoName);
Npix_resolution = [vr.Width vr.Height];
Nfrm_movie = vr.NumberOfFrame;
%% Particle Filter Parameter
targetColorHue = [255 0 0];
nParticle = 5000 ;  %% Number of Particles
particlePositionVariance = 70;
particleVelocityVariance = 30;
particleHueRange = 30;
noiseRange = [particlePositionVariance ;particleVelocityVariance];
predictionVector = [particlePositionVariance ; particlePositionVariance;particleVelocityVariance;particleVelocityVariance];
%% Application Parameters
FrameCaptureLimit= vr.NumberOfFrame;
resolution=[640 480];
%% Particle Filter
% Creating Particle
pState =BigBang(nParticle,resolution,predictionVector);
for frame = 1:FrameCaptureLimit
    %% Image Aqusition
    imager = read(vr,frame);
    %% Updating Particles
    pState = particleUpdate(pState,predictionVector);
    %% Calculate Weights
    particleWeights =weightCalculation(imager , pState,targetColorHue,particleHueRange);
    %% Resampling
    pState = Resampling(pState,particleWeights);
    %% show Particles
    show_particles(pState,imager);


end

