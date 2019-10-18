% shapes = [[shape,x,y,color],[]]
% shape 
% 1 - Circle
% 2 - Square
% 3 - Triangle

% color
% 1 - blue
% 2 - green
% 3 - red
% 4 - yellow

% center: (x,y) (250,260)
% maxy = 480
% maxx = 640

% invert y axis
y = 480 - y;

% set origin & 4 quadrants
y = y - 260;
x = x - 250;

radians_angle = arctan(y/x);
if radians_angle < 0
    radians_angle = 2*pi - radians_angle
end