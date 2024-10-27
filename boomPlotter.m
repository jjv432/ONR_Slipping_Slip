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

%% Boom Arm 


BoomAnglesGround = data.orientation;
BoomAnglesVertical = data.tilt/(4*4960); %CHECK THIS!

%https://en.wikipedia.org/wiki/Rotation_matrix
alphas = BoomAnglesGround;
betas = BoomAnglesVertical;
gammas = zeros(length(alphas), 1);

% These are the coordinates of the alpha shape for the arm when t = 0
% (theta and phi == 0)
Xv = Boom.Length.*[0, 0, 0, 0, 1, 1, 1, 1];
Yv = (Boom.Diameter/2).*[0, 1, 0, -1, -1, 0, 1, 0];
Zv = (Boom.Diameter/2).*[1, 0, -1, 0, 0, -1, 0, 1];

armCoord = [Xv; Yv; Zv];

for i = 1:10:length(alphas)

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

    % X, Y, Z of the end of the boom
    temparmCoord = rotMatrix * armCoord;
    
    BoomAlphaShape = alphaShape(temparmCoord(1, :)', temparmCoord(2, :)', (-temparmCoord(3, :)' + Boom.VerticalDisplacement));
    h1 = plot(BoomAlphaShape, 'FaceColor', 'white');
    pause(.5);
    delete(h1)
   

end


