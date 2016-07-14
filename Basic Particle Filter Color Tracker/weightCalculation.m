function [ particleWeights ] = weightCalculation( imageHue ,pState ,referenceHue ,Xstd_rgb)
%WEIGHTCALCULATION Summary of this function goes here
%   Detailed explanation goes here
A = -log(sqrt(2 * pi) * Xstd_rgb);
B = - 0.5 / (Xstd_rgb.^2);

resolution=size(imageHue);
nParticle = size(pState,2);
% [row col]=find(pState(1:2,:)<=0);
% pState(row , col) = 1;
% [row col]=find(pState(1,:)>resolution(2));
% pState(row,col) = resolution(2);
% 
% [row col]=find(pState(2,:)>resolution(1));
% pState(2,col) = resolution(1);
particleObservation = zeros(nParticle,3);
particleWeights = zeros(1,nParticle);
for k = 1:nParticle
    
    m = pState(1,k);
    n = pState(2,k);
    I = (m >= 1 & m <= resolution(2));
    J = (n >= 1 & n <= resolution(1));
if(I&&J)
particleObservation(k,:) = imageHue(pState(2,k),pState(1,k),:);

particleWe = particleObservation(k,:)-referenceHue;
particleWeights(k) = particleWe*particleWe';
particleWeights(k) =  A + B * particleWeights(k);

else
    particleWeights(k)=-inf;
end

end
particleWeights = exp(particleWeights- max(particleWeights));
particleWeights = particleWeights/sum(particleWeights);
