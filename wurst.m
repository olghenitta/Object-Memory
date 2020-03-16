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
bgColor = [0.98 0.78 0.97];
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor); %black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Svens's variables
design.tarecc   = 6; 
np              = 8;
ang             = 0:2/np*pi:(2-1/np)*pi; 
visual.ppd      = 51.556;
[dpx, dpy]      = pol2cart(ang,design.tarecc*visual.ppd);
design.stiPosi  = round([dpx' dpy']);   % 1 is right relative center then clockwise     
% Parameters for drawing stuff
wurstRadDeg     = 1.5; % how far from ref. points my arcs are located (how thick is the wurst) 
wurstRadPix     = visual.ppd*wurstRadDeg;  
leftover        = 10.0;                 % degrees for arc ends relative ref points

%rectangle relative stimulus Position
rect72P = [design.stiPosi(5,1)-wurstRadPix design.stiPosi(7,2)-wurstRadPix...
    design.stiPosi(1,1)+wurstRadPix  design.stiPosi(3,2)+wurstRadPix];
rect72out = [xCenter yCenter xCenter yCenter] + rect72P;
rectDecrease = [wurstRadPix wurstRadPix -wurstRadPix -wurstRadPix]*2;
rect72in = rect72out +rectDecrease;
%rectIncrease  = -rectDecrease
rectImage = rect72out - rectDecrease*2;
% Set the color of the rect to nice and princessy
arcColor2 = [0.95 0.97 0.59];
arcColor1 = [0.78 0.96 0.99];
dotColor  = [0.91 0.70 0.97];

% Take a random ref stimulus
refStim = 7; % This is top vertical, basis is calculated from this point and then is rotated
stim1 =  4; %randi([1 np/2]);
switch stim1
    case 1
        rotateAll = 0;
    case 2
        rotateAll = 45;
    case 3 
        rotateAll = 90;
    case 4
        rotateAll = 135;
end
% if stim1 == 7
%     rotateAll = 45;
% else
%     rotateAll = 0;
% end

    
% Line coordinates
leftoverExp = 10;
line_coords = [xCenter  design.stiPosi(refStim,1)+xCenter; yCenter+design.stiPosi(refStim,2)+wurstRadPix design.stiPosi(refStim,2)-wurstRadPix+yCenter];

% Rotation Matrix for lines
rotation1 = [cosd(-leftoverExp+rotateAll) -sind(-leftoverExp+rotateAll); sind(-leftoverExp+rotateAll) cosd(-leftoverExp+rotateAll)];

xyPointOut = ceil([design.stiPosi(refStim,1) design.stiPosi(refStim,2)-wurstRadPix]');
xyPointIn = ceil([design.stiPosi(refStim,1) design.stiPosi(refStim,2)+wurstRadPix]');

xyRotatedOut = ceil(rotation1*xyPointOut)+ [xCenter;yCenter];
xyRotatedIn = ceil(rotation1*xyPointIn)+ [xCenter;yCenter];

rotation2 = [cosd(135+leftoverExp+rotateAll) -sind(135+leftoverExp+rotateAll); sind(135+leftoverExp+rotateAll) cosd(135+leftoverExp+rotateAll)];

xy2RotatedOut = ceil(rotation2*xyPointOut)+ [xCenter;yCenter];
xy2RotatedIn = ceil(rotation2*xyPointIn)+ [xCenter;yCenter];

rotation3 = [cosd(-45+leftoverExp+rotateAll) -sind(-45+leftoverExp+rotateAll); sind(-45+leftoverExp+rotateAll) cosd(-45+leftoverExp+rotateAll)];

xy3RotatedOut = ceil(rotation3*xyPointOut)+ [xCenter;yCenter];
xy3RotatedIn = ceil(rotation3*xyPointIn)+ [xCenter;yCenter];

rotation4 = [cosd(180-leftoverExp+rotateAll) -sind(180-leftoverExp+rotateAll); sind(180-leftoverExp+rotateAll) cosd(180-leftoverExp+rotateAll)];

xy4RotatedOut = ceil(rotation4*xyPointOut)+ [xCenter;yCenter];
xy4RotatedIn = ceil(rotation4*xyPointIn)+ [xCenter;yCenter];


lineCoords = [xyRotatedIn(1) xyRotatedOut(1) xy2RotatedIn(1) xy2RotatedOut(1) xy3RotatedIn(1) xy3RotatedOut(1) xy4RotatedIn(1) xy4RotatedOut(1);
    xyRotatedIn(2) xyRotatedOut(2) xy2RotatedIn(2) xy2RotatedOut(2) xy3RotatedIn(2) xy3RotatedOut(2) xy4RotatedIn(2) xy4RotatedOut(2)];
% Width of the lines for our frame
lineWidth = 3;

% Screen('FrameRect', window, dotColor, rect72out, lineWidth);
% Screen('FrameRect', window, dotColor, rect72in, lineWidth);

Screen('FrameArc',window,arcColor1,rect72out, 0-leftover+rotateAll, 135+leftover*2, lineWidth, lineWidth) 
Screen('FrameArc',window,arcColor1,rect72in,  0-leftover+rotateAll, 135+leftover*2, lineWidth, lineWidth) 

Screen('FrameArc',window,arcColor2,rect72out, 180-leftover+rotateAll, 135+leftover*2, lineWidth, lineWidth)
Screen('FrameArc',window,arcColor2,rect72in,  180-leftover+rotateAll, 135+leftover*2, lineWidth, lineWidth)

%Screen('DrawLines', window, line_coords, lineWidth, arcColor1) %, [xCenter yCenter]);
Screen('DrawLines', window, lineCoords, lineWidth, [arcColor1' arcColor1' arcColor1' arcColor1' arcColor2' arcColor2' arcColor2' arcColor2']) %,
%Screen('FrameRect', window, rectColor, rect2, lineWidth);
%Screen('FrameArc',window,arcColor,rect3, 0, 180, lineWidth, lineWidth)
%Screen('FrameArc',window,arcColor,rect2, 0, 180, lineWidth, lineWidth)

Screen('DrawDots', window, [design.stiPosi(:,1)'; design.stiPosi(:,2)'], 15, dotColor, [xCenter, yCenter]);

% Flip to the screen
Screen('Flip', window);
imageArray = Screen('GetImage', window, rectImage);
imwrite(imageArray, 'princess_image8.jpg')

KbStrokeWait;

% Clear the screen
sca;