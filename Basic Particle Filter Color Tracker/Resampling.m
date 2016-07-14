function [ pState ] = Resampling( pState , particleWeights )
%RESAMPLING Summary of this function goes here
%   Detailed explanation goes here
nParticles = size(pState,2);

cdf = cumsum(particleWeights,2);%% Creat CDF of Particle Weights
S = rand(1,nParticles);%% uniform samples 
[~, I] = histc(S, cdf);%% sampling particles
pState = pState(1:4, I + 1);%% reassignment of Particles
end