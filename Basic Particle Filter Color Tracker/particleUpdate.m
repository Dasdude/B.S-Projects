function [ pState ] = particleUpdate( pState ,predictionVector )
%PARTICLEUPDATE Summary of this function goes here
%   Detailed explanation goes here
F = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1]; %% xk = f(x(k-1)) +Noise
pState = F*pState;
pState(3:4,:) =  round( pState(3:4,:)+ predictionVector(3)*randn(2,size(pState,2)));
pState(1:2,:) = round(pState(1:2,:) + predictionVector(1)*randn(2,size(pState,2)));

end

