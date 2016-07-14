function [ objectSize ] = topPointFromCenterCalculator( H , Center )
%TOPPOINTFROMBOTTUMCALCULATION Summary of this function goes here
% Center  : [x ;y]
%   Detailed explanation goes here
Center = [Center;ones(1,size(Center,2))];
Top = H*Center;
landa = Top(3,:);
landa = repmat(landa,3,1);
Top = Top./landa;
objectSize=(Top-Center);
objectSize =sqrt(sum(objectSize.^2));
end

