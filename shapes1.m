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
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, bgColor, [100 100 1100 900]); %black);

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
draftColor = [0.5 0 0.5];
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
rotateAll = 45;
lineWidth = 3;
    
Screen('FillArc',window,arcColor1,rect72out, 0-leftover+rotateAll, 135+leftover*2)
Screen('FillArc',window,draftColor,rect72in, 0-leftover+rotateAll, 135+leftover*2)

Screen('FillArc',window,arcColor2,rect72out,180-leftover+rotateAll, 135+leftover*2)
Screen('FillArc',window,draftColor,rect72in,180-leftover+rotateAll, 135+leftover*2)

Screen('FrameRect', window, dotColor, rect72out, lineWidth);
Screen('FrameRect', window, dotColor, rect72in, lineWidth);

Screen('DrawDots', window, [design.stiPosi(:,1)'; design.stiPosi(:,2)'], 15, dotColor, [xCenter, yCenter]);

% Flip to the screen
Screen('Flip', window);
% imageArray = Screen('GetImage', window, rectImage);
% imwrite(imageArray, 'princess_image8.jpg')

KbStrokeWait;

% Clear the screen
sca;