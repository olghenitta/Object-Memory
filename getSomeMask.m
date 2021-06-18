function masks = getSomeMask(p)
%
% p.sig = 25;
% p.siz = 100;
% 
% p.sig = p.sig*1.3;
[X,Y] = meshgrid(-p.siz:p.siz,-p.siz:p.siz);
visual.bgColor = 0.8;
visual.white = 1;

Mask = ones(2*p.siz+1, 2*p.siz+1, 2) * visual.bgColor;
m = visual.white * (1 - (-0.5 + 5*exp(-((X/(1.2*p.sig)).^2)-((Y/(1.2*p.sig)).^2))));
m(m>0.97) = visual.white;
m(m<=0.97) = 0;

Mask(:, :, 4) = m;
Mask(:, :, 3) = p.MColor(3);
Mask(:, :, 2) = p.MColor(2);
Mask(:, :, 1) = p.MColor(1);

Mask1 = Mask(1:(end-1)/2,   :,:);
Mask2 =  Mask((end+1)/2:end-1, :,:);
masks.Mask1 = Mask1;
masks.Mask2 = Mask2;
%global visual 

% %size = 25;
% visual.bgColor = 1;%[0.1922 0.2353 0.2980];
% visual.white = 0;
% [X,Y] = meshgrid(-size:size,-size:size);%meshgrid(-p.siz:p.siz,-p.siz:p.siz);
% 
% Mask = ones(2*size+1, 2*size+1, 2) * visual.white;
% Mask(:, :, 2) = visual.bgColor * (1 - (-((X).^2)-((Y).^2)));
 end
