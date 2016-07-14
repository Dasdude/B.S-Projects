function Listener(src,evnt)
global HOMOGRAPHYSAMPLESCOUNT 
global HOMOGRAPHYSAMPLES
inp = evnt.Character
if(inp== ' ')
    disp('Click on Center of The Target')
    sc =HOMOGRAPHYSAMPLESCOUNT
    TargetCenter=ginput(1);
    HOMOGRAPHYSAMPLES(:,1,sc)= TargetCenter;
    disp('Click on Top Of The Target');
    TargetTop = ginput(1);
    HOMOGRAPHYSAMPLES(:,2,sc)= TargetTop;
    HOMOGRAPHYSAMPLESCOUNT =sc + 1;
    clc;
end

end