function HomographyChecker( src,evnt )
%HOMOGRAPHYCHECKER Summary of this function goes here
%   Detailed explanation goes here
global HOMOGRAPHYMATRIX;
global wToH;
TargetCenter=ginput(1);
TargetCenter = TargetCenter';
hold on
ykmean            = TargetCenter
height = topPointFromCenterCalculator(HOMOGRAPHYMATRIX,TargetCenter)
width = wToH*height;
 ekmean = [width;height;0];
[xmean , ymean]   = ellipse(ykmean , ekmean);
plot(xmean , ymean , 'g' , 'linewidth' , 3)% Ellipse
hold off
ginput(1);
end

