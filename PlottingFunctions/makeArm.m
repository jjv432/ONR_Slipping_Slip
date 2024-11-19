function armCoord = makeArm(Boom)

% These are the coordinates of the alpha shape for the arm when t = 0
% (theta and phi == 0)

% Looking top down, x is right, y is forward, z is up. Starting with phi
% and theta 0 with respect to x-axis

Xba = Boom.Length.*[0, 0, 0, 0, 1, 1, 1, 1];
Yba = (Boom.Diameter/2).*[0, 1, 0, -1, -1, 0, 1, 0];
Zba = (Boom.Diameter/2).*[1, 0, -1, 0, 0, -1, 0, 1];

armCoord = [Xba; Yba; Zba];

end