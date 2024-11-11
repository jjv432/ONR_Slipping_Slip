function effectorCoord = makeEndEffector(Linkage)

% Making coordinates so that it's easier to line up with center

Xee = Linkage.EndEffector.Thickness*[-.5, -.5, -.5, -.5, -.5, .5, .5, .5, .5, .5];
Yee = Linkage.EndEffector.Radius*[cos(0), cos(pi/4), cos(pi/2), cos(3*pi/4), cos(pi), cos(pi), cos(3*pi/4), cos(pi/2), cos(pi/4), cos(0)];
Zee = Linkage.EndEffector.Radius*[sin(0), sin(pi/4), sin(pi/2), sin(3*pi/4), sin(pi), sin(pi), sin(3*pi/4), sin(pi/2), sin(pi/4), sin(0)];

effectorCoord = [Xee; Yee; Zee];

end