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

%% Left Proximal Link

Xpl = Linkage.Proximal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ypl = Linkage.Proximal.Length*[0 0 0 0 -1 -1 -1 -1];
Zpl = Linkage.Proximal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

proximalLeftCoord = [Xpl; Ypl; Zpl];

PLtheta = Linkage.Proximal.Left.Theta;

for a = 1:length(PLtheta)
    proximalLeftCoords(:, :, a) = proximalLeftCoord' * [1 0 0; 0 cos(PLtheta(a)) sin(PLtheta(a)); 0 -sin(PLtheta(a)) cos(PLtheta(a))];
end

%% Right Proximal Link

Xpr = Linkage.Proximal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ypr = Linkage.Proximal.Length*[0 0 0 0 1 1 1 1];
Zpr = Linkage.Proximal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

proximalRightCoord = [Xpr; Ypr; Zpr];

PRtheta = Linkage.Proximal.Right.Theta;

for a = 1:length(PRtheta)
    proximalRightCoords(:, :, a) = proximalRightCoord' * [1 0 0; 0 cos(PRtheta(a)) sin(PRtheta(a)); 0 -sin(PRtheta(a)) cos(PRtheta(a))];
end

%% Left Distal Link

Xdl = Linkage.Distal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ydl = Linkage.Distal.Length*[0 0 0 0 1 1 1 1];
Zdl = Linkage.Distal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

distalLeftCoord = [Xdl; Ydl; Zdl];

for a = 1:length(PLtheta)
    DLtheta = -pi/2 - atan2((Linkage.EndEffector.Z(a) - abs(Linkage.Proximal.Length * sin(PLtheta(a)))), (Linkage.EndEffector.X(a) - abs(Linkage.Proximal.Length * cos(PLtheta(a)))));
    distalLeftCoords(:, :, a) = distalLeftCoord' * [1 0 0; 0 sin(DLtheta) cos(DLtheta); 0 -cos(DLtheta) sin(DLtheta)];
end

%% Right Distal Link

Xdr = Linkage.Distal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ydr = Linkage.Distal.Length*[0 0 0 0 1 1 1 1];
Zdr = Linkage.Distal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

distalRightCoord = [Xdr; Ydr; Zdr];

for a = 1:length(PRtheta)
    DRtheta = pi/2 + atan2((Linkage.EndEffector.Z(a) - abs(Linkage.Proximal.Length * sin(PRtheta(a)))), (Linkage.EndEffector.X(a) - abs(Linkage.Proximal.Length * cos(PRtheta(a)))));
    distalRightCoords(:, :, a) = distalRightCoord' * [1 0 0; 0 sin(DRtheta) cos(DRtheta); 0 -cos(DRtheta) sin(DRtheta)];
end
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
    view(45, 20);
       
    % Hip -----------------------------

    temphipCoord = rotMatrix * hipCoord;
    HipXs = temphipCoord(1,:) + max(BoomXs);
    HipYs = temphipCoord(2,:) + max(BoomYs);
    HipZs = -temphipCoord(3,:) + mean(BoomZs(5:end));
    % only doing the last four for Zs because those are the four points at
    % the end of the boom

    HipAlphaShape = alphaShape(HipXs', HipYs', HipZs');
    h2 = plot(HipAlphaShape, 'FaceColor', 'white');
    

    % End Effector ------------------------

    % This line is broken now for some reason.  It's the third dimension
    tempeffecotrCoord = rotMatrix * (effectorCoord - [0; Linkage.EndEffector.X(i); Linkage.EndEffector.Z(i)]);
    eeXs = tempeffecotrCoord(1,:)+ mean(HipXs);
    eeYs = tempeffecotrCoord(2,:) + mean(HipYs);
    eeZs = -tempeffecotrCoord(3,:) + min(HipZs);

    EEAlphaShape = alphaShape(eeXs', eeYs', eeZs');
    h3 = plot(EEAlphaShape, 'FaceColor', 'blue');

    % Proximal Left ------------------------
    
    tempProximalLeftCoord = rotMatrix * (proximalLeftCoords(:, :, i)');

    plXs = tempProximalLeftCoord(1,:) + mean(HipXs);
    plYs = tempProximalLeftCoord(2,:) + mean(HipYs);
    plZs = -tempProximalLeftCoord(3,:) + min(HipZs);

    PLAlphaShape = alphaShape(plXs', plYs', plZs');
    h4 = plot(PLAlphaShape, 'FaceColor', 'black');

    % Proximal Right ------------------------
    
    tempProximalRightCoord = rotMatrix * (proximalRightCoords(:, :, i)');

    prXs = tempProximalRightCoord(1,:) + mean(HipXs);
    prYs = tempProximalRightCoord(2,:) + mean(HipYs);
    prZs = -tempProximalRightCoord(3,:) + min(HipZs);

    PRAlphaShape = alphaShape(prXs', prYs', prZs');
    h5 = plot(PRAlphaShape, 'FaceColor', 'black');
    % axis([-2 2 -2 2 0 1.5]);

    % Distal Left ------------------------
    
    tempDistalLeftCoord = rotMatrix * (distalLeftCoords(:, :, i)');

    dlXs = tempDistalLeftCoord(1,:) + mean(plXs(5:end));
    dlYs = tempDistalLeftCoord(2,:) + mean(plYs(5:end));
    dlZs = -tempDistalLeftCoord(3,:) + mean(plZs(5:end));

    DLAlphaShape = alphaShape(dlXs', dlYs', dlZs');
    h6 = plot(DLAlphaShape, 'FaceColor', 'white');

    % Distal Right ------------------------
    
    tempDistalRightCoord = rotMatrix * (distalRightCoords(:, :, i)');

    drXs = tempDistalRightCoord(1,:) + mean(prXs(5:end));
    drYs = tempDistalRightCoord(2,:) + mean(prYs(5:end));
    drZs = -tempDistalRightCoord(3,:) + mean(prZs(5:end));

    DRAlphaShape = alphaShape(drXs', drYs', drZs');
    h7 = plot(DRAlphaShape, 'FaceColor', 'white');
    axis([-2 2 -2 2 0 1.5]);


    % Cleanup ----------------------------
    pause(.05);
    delete(h1)
    delete(h2);
    delete(h3);
    delete(h4);
    delete(h5);
    delete(h6);
    delete(h7);
   

end


