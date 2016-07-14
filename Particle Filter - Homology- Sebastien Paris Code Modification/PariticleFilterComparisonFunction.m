function [] = PariticleFilterComparisonFunction( totalTest,particleTotalArray,targetNumber,filename,fileExtension )
%PARITICLEFILTERCOMPARISONFUNCTION Summary of this function goes here
%   PariticleFilterComparisonFunction( totalTest,particleTotalArray,targetNumber,filename,fileExtension )
% Particle Total Array : Arraye of size of Particles
% Total Test : Total Test for each Element of Particle Array
% TargetNumber : Specify which Target you want to track in your video if
% the target distrubution is not known the application will ask you to
% specify it's initial location

%% Folder Creating
run =1;
run
if(exist(filename)==2)
% if(exists(filename,'dir')==0)
mkdir(filename );
mkdir([filename '/Input Data']);
end
if(exist([filename '/Target ' int2str(targetNumber)],'dir')==0)
    mkdir([filename '/Target ' int2str(targetNumber)]);
end
while(1)
if(exist([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run)],'dir')==0)
    mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run)]);
    for k = particleTotalArray
        
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k)]);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/Weight History']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/Videos']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/Comparison to Ground Truth']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/Error']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/Weight Variance']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Proposed Method/State Variance']);

mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method'])
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/Weight History']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/Videos']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/Comparison to Ground Truth']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/Error']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/Weight Variance']);
mkdir([filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Total Particle ' num2str(k) '/Standard Method/State Variance']);
    end
break;
else
run=run+1;
end
end
%% Video Input
fileExtension = ['.' fileExtension]


%% Result Variable Initialization
MSEHom= zeros(size(particleTotalArray,2),totalTest);
timeHom= zeros(size(particleTotalArray,2),totalTest);
timeStand= zeros(size(particleTotalArray,2),totalTest);
MSEStand= zeros(size(particleTotalArray,2),totalTest);
%% Video Variable Initialization

video_file        = [filename,fileExtension];
video             = VideoReader(video_file , 'tag', 'myreader1');
Duration = video.Duration;

%% Tester
object= [1:3];
for N =1:size(particleTotalArray,2)
    for testNumber =1:totalTest
        [MSEHom(N,testNumber),timeHom(N,testNumber)] = MyParticle(particleTotalArray(N),900,410,'13',0,0,1,testNumber,run);
        [MSEStand(N, testNumber), timeStand(N,testNumber)] = StandardParticleFilter(particleTotalArray(N),900,410,'13',0,1,testNumber,run);
    end
end
mMSEHom = mean(MSEHom,2);
mMSEStand = mean(MSEStand,2);
meanTimeHom = mean(timeHom,2);
meanTimeStand = mean(timeStand,2);
% meanTimeHom = meanTimeHom/Duration;
% meanTimeStand = meanTimeStand/Duration;
% plot([1:size(particleTotalArray,2);
%% TEst
%  MyParticle(100,900,410,'13',0,0,1,1)
%  StandardParticleFilter(100,900,410,'13',0,1,1);
%% Display Result
% mean MSE Plot
figure(1);
plot(particleTotalArray([1:size(particleTotalArray,2)]),mMSEStand,'r');
title('mean of MSE Comparison \bf  \color{red}Proposed Method \color{blue} Regular Method');
hold on
plot(particleTotalArray([1:size(particleTotalArray,2)]),mMSEHom,'b');
saveas(figure(1),[filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Mean MSE.jpg']);
hold off
% Time 
figure(2);
plot(particleTotalArray,meanTimeHom,'r');
title('Processing Time Comparison \bf  \color{red}Proposed Method \color{blue} Regular Method');
hold on
plot(particleTotalArray,meanTimeStand,'b');
saveas(figure(2),[filename '/Target ' int2str(targetNumber) '/Run ' num2str(run) '/Time Consumption Comparison.jpg'])

hold off
end

