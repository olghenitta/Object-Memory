% To do:
% Now arcs are hardcoded for ref stim # 7 (top)
% they should work for four ref stim 
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2 );

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Set the color of the rect to nice and princessy
bgColor = [0.98 0.78 0.97];
% Randomization of the shape color will happen in genDesign
arcColors = [0.95 0.97 0.59; 0.78 0.96 0.99];
ColorOrder = randperm(2);
arcColor1 = arcColors(ColorOrder(1), :);
arcColor2 = arcColors(ColorOrder(2), :);
dotColor  = [0.91 0.70 0.97];
draftColor = [0.5 0 0.5];%bgColor;%;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor, [100 100 1100 900]); %black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
visual.ppd      = 51.556;

% stimulus variables later will be defined as a function input
nstim           = 6;
design.tarecc   = 6; %dva
tareccPix       = round(design.tarecc*visual.ppd);
wurstRadDeg     = 1; % how far from ref. points my arcs are located (how thick is the wurst) 
wurstRadPix     = visual.ppd*wurstRadDeg;  

ang             = 0:2/nstim*pi:(2-1/nstim)*pi; 
[dpx, dpy]      = pol2cart(ang,design.tarecc*visual.ppd);
design.stiPosi  = round([dpx' dpy']);   % 1 is right relative center then clockwise     

% Parameters for drawing stuff

segment1        = 360/nstim;
leftover        = 0.2* segment1;            % how far from the stimulus centers arcs extend 

%rectangle relative stimulus Position
rect72out = [xCenter yCenter xCenter yCenter] - [tareccPix tareccPix -tareccPix  -tareccPix] - [wurstRadPix wurstRadPix -wurstRadPix -wurstRadPix];
rectDecrease = [wurstRadPix wurstRadPix -wurstRadPix -wurstRadPix]*2;
rect72in = rect72out +rectDecrease;


% Take a random ref stimulus
stim1 = randi([1 nstim/2]);
% switch stim1
%     case 1
%         rotateAll = 0;
%     case 2
%         rotateAll = segment1;
%     case 3 
%         rotateAll = segment1*2;
%     case 4
%         rotateAll = segment1*3;
% end

lineWidth = 3;
arcAngle = segment1*(nstim/2-1);    

% theta = segment1*stim1+leftover*0.9;
% R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% newCenter = (R*(design.stiPosi(1,:))')';
% newOval = [newCenter + [-wurstRadPix -wurstRadPix] newCenter + [wurstRadPix wurstRadPix]];
% 
% theta2 = -arcAngle-leftover*1.8;
% R2 = [cosd(theta2) -sind(theta2); sind(theta2) cosd(theta2)];
% newCenter2 = (R2*newCenter')';
% newOval2 = [newCenter2 + [-wurstRadPix -wurstRadPix] newCenter2 + [wurstRadPix wurstRadPix]];
% Screen('FillOval', window, [arcColor1; arcColor1]',[([xCenter yCenter xCenter yCenter]+newOval); ([xCenter yCenter xCenter yCenter]+newOval2)]')
% Screen('FillArc',window,arcColor1,rect72out, 0-leftover+rotateAll, arcAngle+leftover*2)
% %Screen('FillArc',window,draftColor,rect72in, 0-leftover+rotateAll, arcAngle+leftover*2)
% 
% Screen('FillArc',window,arcColor2,rect72out,180-leftover+rotateAll, arcAngle+leftover*2)
% %Screen('FillArc',window,draftColor,rect72in,180-leftover+rotateAll, arcAngle+leftover*2)
% Screen('FillOval', window, bgColor, rect72in)

refStimPos1 = design.stiPosi(stim1,:); %later will be generalized
center4 = [xCenter yCenter xCenter yCenter];

stimReArc1 = atan2d(refStimPos1(1), -refStimPos1(2));% arc is drawn clockwise from vertical 
startArc1 = stimReArc1-arcAngle-leftover;
entireArc = arcAngle+2*leftover;%;+leftover;

refStimPos2 = design.stiPosi(stim1+1,:);
stimReArc2 = atan2d(refStimPos2(1), -refStimPos2(2));% arc is drawn clockwise from vertical 
startArc2 = stimReArc2 -leftover;

Screen('FillArc',window,arcColor1,rect72out, startArc1, entireArc)
Screen('FillArc',window,arcColor2,rect72out, startArc2, entireArc)
Screen('FillOval', window, bgColor, rect72in)

%Arc Ends
%rotate first ref point
theta = -leftover;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
oval1 = design.stiPosi(stim1,:)*R;
oval2 = design.stiPosi(stim1+(nstim/2),:)*R;
newOval = round([[oval1(1) oval1(2)] + [-wurstRadPix -wurstRadPix] [oval1(1) oval1(2)] + [wurstRadPix wurstRadPix]]);
newOval2 = round([[oval2(1) oval2(2)] + [-wurstRadPix -wurstRadPix] [oval2(1) oval2(2)] + [wurstRadPix wurstRadPix]]);
theta2 = -theta;
R2 = [cosd(theta2) -sind(theta2); sind(theta2) cosd(theta2)];
oval3 = design.stiPosi(stim1+1,:)*R2;
if mod((stim1+nstim/2)+1,nstim) ==0
    index = nstim;
else
    index = mod((stim1+nstim/2)+1,nstim);
end
oval4 = design.stiPosi(index,:)*R2;
newOval3 = round([[oval3(1) oval3(2)] + [-wurstRadPix -wurstRadPix] [oval3(1) oval3(2)] + [wurstRadPix wurstRadPix]]);
newOval4 = round([[oval4(1) oval4(2)] + [-wurstRadPix -wurstRadPix] [oval4(1) oval4(2)] + [wurstRadPix wurstRadPix]]);
Screen('FillOval', window, arcColor1, newOval+center4)
Screen('FillOval', window, arcColor2, newOval2+center4)
Screen('FillOval', window, arcColor2, newOval3+center4)
Screen('FillOval', window, arcColor1, newOval4+center4)
Screen('DrawDots', window, [design.stiPosi(:,1)'; design.stiPosi(:,2)'], 15, dotColor, [xCenter, yCenter]);



% Flip to the screen
Screen('Flip', window);
% imageArray = Screen('GetImage', window, rectImage);
% imwrite(imageArray, 'princess_image8.jpg')



KbStrokeWait;

% Clear the screen
sca;