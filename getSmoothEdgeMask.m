function Mask = getSmoothEdgeMask(p)
%
% 2013 by Martin Rolfs

global visual 

p.sig = p.sig - 0.3*p.sig;
[X,Y] = meshgrid(-p.siz:p.siz,-p.siz:p.siz);

Mask = ones(2*p.siz+1, 2*p.siz+1, 2) * visual.bgColor;
m = visual.white * (1 - (-0.5 + 5*exp(-((X/(1.5*p.sig)).^2)-((Y/(1.5*p.sig)).^2))));
m(m>visual.white) = visual.white;
m(m<0) = 0;

Mask(:, :, 4) = m;
Mask(:, :, 3) = p.MColor(3)/2;
Mask(:, :, 2) = p.MColor(2)/2;
Mask(:, :, 1) = p.MColor(1)/2;
