function boomPlotter(data, Platform ,Boom, Hip, Linkage)

%% Platform
plat_angles = linspace(0, 2*pi, 100);

PlatformInnerX = Platform.InnerDiameter * cos(plat_angles);
PlatformInnerY = Platform.InnerDiameter * sin(plat_angles);

PlatformOuterX = Platform.OuterDiameter * cos(plat_angles);
PlatformOuterY = Platform.OuterDiameter * sin(plat_angles);

Xs = [PlatformInnerX, PlatformOuterX, PlatformOuterX, PlatformInnerX]';
Ys = [PlatformInnerY, PlatformOuterY, PlatformOuterY, PlatformInnerY]';

LowZ = zeros(numel(plat_angles), 1);
HighZ = Platform.Thickness * ones(numel(plat_angles), 1);

Zs = [LowZ; LowZ; HighZ; HighZ];

figure();
hold on
Platform.AlphaShape = alphaShape(Xs, Ys, Zs);
plot(Platform.AlphaShape, 'FaceColor', 'blue')
xlabel('X')
ylabel('Y')
zlabel('Z')

axis([-2 2 -2 2 -2 2])
pause(1)

%% Data sorting


BoomAnglesGround = data.orientation;
BoomAnglesVertical = data.tilt/(4*4960); %CHECK THIS!

%https://en.wikipedia.org/wiki/Rotation_matrix
alphas = BoomAnglesGround;
betas = BoomAnglesVertical;
gammas = zeros(length(alphas), 1);

%% Boom Arm 

% These are the coordinates of the alpha shape for the arm when t = 0
% (theta and phi == 0)

% Looking top down, x is right, y is forward, z is up. Starting with phi
% and theta 0 with respect to x-axis

Xba = Boom.Length.*[0, 0, 0, 0, 1, 1, 1, 1];
Yba = (Boom.Diameter/2).*[0, 1, 0, -1, -1, 0, 1, 0];
Zba = (Boom.Diameter/2).*[1, 0, -1, 0, 0, -1, 0, 1];

armCoord = [Xba; Yba; Zba];

%% Hip

% Assuming hip is symmetric about its connection to the arm (vertically)
% starting at vertex at min x, min y, min z. Making coordinates such that
% its easy to line up with the left face, not the center

Xh = Hip.Thickness*[0, 0, 0, 0, 1, 1, 1, 1];
Yh = Hip.Width*[-.5, .5, .5, -.5, -.5, .5, .5, -.5];
Zh = Hip.Height*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];


hipCoord = [Xh; Yh; Zh];

%% End Effecter
% Making coordinates so that it's easier to line up with center

Xee = Linkage.EndEffector.Thickness*[-.5, -.5, -.5, -.5, -.5, .5, .5, .5, .5, .5];
Yee = Linkage.EndEffector.Radius*[cos(0), cos(pi/4), cos(pi/2), cos(3*pi/4), cos(pi), cos(pi), cos(3*pi/4), cos(pi/2), cos(pi/4), cos(0)];
Zee = Linkage.EndEffector.Radius*[sin(0), sin(pi/4), sin(pi/2), sin(3*pi/4), sin(pi), sin(pi), sin(3*pi/4), sin(pi/2), sin(pi/4), sin(0)];

effectorCoord = [Xee; Yee; Zee];

%% Moving the bodies
for i = 1:10:length(alphas)
    
    % Rotation angles
    alpha = alphas(i);
    beta = betas(i);
    gamma = gammas(i);


    % Rotation matrix to get boom end in world frame

    rotMatrix = [    
        cos(alpha), -sin(alpha), 0;
        sin(alpha), cos(alpha), 0;
        0, 0, 1
    
    ] * [
    
        cos(beta), 0, sin(beta);
        0, 1, 0;
        -sin(beta), 0, cos(beta)
    
    ] * [
    
        1, 0, 0;
        0, cos(gamma), -sin(gamma);
        0, sin(gamma), cos(gamma);
    ];
    
    % Boom --------------------------------
    % X, Y, Z of the end of the boom
    temparmCoord = rotMatrix * armCoord;
    BoomXs = temparmCoord(1,:);
    BoomYs = temparmCoord(2,:);
    BoomZs = -temparmCoord(3,:) + Boom.VerticalDisplacement;

    BoomAlphaShape = alphaShape(BoomXs', BoomYs', BoomZs');
    h1 = plot(BoomAlphaShape, 'FaceColor', 'white');
    view(98, 8);


    % Hip ---------------------------------

    temphipCoord = rotMatrix * hipCoord;
    HipXs = temphipCoord(1,:) + max(BoomXs);
    HipYs = temphipCoord(2,:) + max(BoomYs);
    HipZs = -temphipCoord(3,:) + max(BoomZs);

    BoomAlphaShape = alphaShape(HipXs', HipYs', HipZs');
    h2 = plot(BoomAlphaShape, 'FaceColor', 'white');

    % End Effector ------------------------

    tempeffecotrCoord = rotMatrix * (effectorCoord + [0; Linkage.EndEffector.X(i); Linkage.EndEffector.Z(i)]);
    eeXs = tempeffecotrCoord(1,:) + mean(HipXs);
    eeYs = tempeffecotrCoord(2,:) + mean(HipYs);
    eeZs = -tempeffecotrCoord(3,:) + min(HipZs);

    BoomAlphaShape = alphaShape(eeXs', eeYs', eeZs');
    h3 = plot(BoomAlphaShape, 'FaceColor', 'black');


    pause(.05);
    delete(h1)
    delete(h2);
    delete(h3);
   

end


