
%% Introduction
% The particle Filter is based on Color detection in RGB color space. the
% details of the program is provided along the instructions and codes

% this Script Provides Command line User Interface which leads to Webcam or Stored video Source decision for processing
% 
%% Particle Filter Configuration Interface
clc
clear
close all
fprintf('\t \t Particle Filter Configuration \n \n \n \n');

conf = input('Press Enter for Default Configuration And Otherwise For Costum Configuration','s');
if (isempty(conf))
    Number_Of_Particles=1000;
    Velocity_State_Noise=30;
    Position_State_Noise=70;
    Color_State_Noise=30;
else
    conf = input('\n Type In Total Number Of Particles \n','s');
    Number_Of_Particles = str2num(conf);
    
    
    conf = input('\n Type In Velocity Noise \n','s');
    Velocity_State_Noise=str2num(conf);
    
    
    conf = input('\n Type In Position Noise \n','s');
    Position_State_Noise=str2num(conf);
    
    conf = input('\n Type In Color Detection Aproximated Range \n','s');
    Color_State_Noise=str2num(conf);
    
end

fprintf(' \n Please State Target Color \n'); 
conf = input('\n Red :','s');
Target_Color = [str2num(conf) 0 0];

conf = input('\n Green :','s');
Target_Color(2) = str2num(conf);

conf = input('\n Blue :','s');
Target_Color(3) = str2num(conf);
 
if (sum(Target_Color>255 | Target_Color<0)>0)
    err = MException( 'InputRangeErr:OutofBound','RGB Not in The Range');
    throw(err)
end
conf = input('Press Enter To Use Stored video otherwise Enter Any Key to use Webcam \n','s');
if(isempty(conf))
    videoName = input('Type in Video File Name (Case Sensitive) \n','s');
else
    frameCaptureLimit = input('Type in Webcam Total Frame Capture \n','s');
end
clc
fprintf('\t \t \t YOUR PARTICLE FILTER PROPERTIES \n \n \n')
fprintf(['Total Number Of Particles: \t',num2str(Number_Of_Particles), '\n']); 
fprintf(['Velocity State Noise: \t',num2str(Velocity_State_Noise), '\n']); 
fprintf(['Position State Noise: \t',num2str(Position_State_Noise), '\n']); 
fprintf(['Color Detection Aproxmated Range: \t',num2str(Color_State_Noise), '\n']);
fprintf(['Target RGB Color: \t','[',num2str(Target_Color),']', '\n']); 
%% Webcam/Stored Video Source Decision
if(isempty(conf))
    fprintf(['Video Name: \t',videoName,'\n']);
    Stored_Video(videoName,Number_Of_Particles,Target_Color,Position_State_Noise,Velocity_State_Noise,Color_State_Noise);
else
    fprintf(['Frame Capture Limit: \t',frameCaptureLimit,'\n']);
    Webcam_Function(str2num(frameCaptureLimit),Number_Of_Particles,Target_Color,Position_State_Noise,Velocity_State_Noise,Color_State_Noise);
end
%% Next Functions
%%
% <http://www.mathworks.com MathWorks> 