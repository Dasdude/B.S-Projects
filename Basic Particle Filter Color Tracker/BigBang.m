function [ pState  ] = BigBang( nparticle,resolution,nextStatePredictionVector )
%BIGBANG Summary of this function goes here
%   Detailed explanation goes here
% resolution : resolution of each frame resolution = [Totalrows ,Totalcolumns]
% initialState : particles Initial States . 
% nextStatePredictionVector defines as a vector which consist of
% prediction Parameters
pState = zeros(4,nparticle);
% pState defines as : [x ; y ; vx ; vy];
initialStatex = randi(resolution(2),1,nparticle); %% each particle gets a random postion at initialization
initialStatey = randi(resolution(1),1,nparticle);
pState(1,:) = initialStatex;
pState(2,:) = initialStatey;
end

