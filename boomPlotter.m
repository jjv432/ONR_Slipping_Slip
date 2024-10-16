function boomPlotter(Platform ,Boom, Hip, Linkage)

%% Platform generation
plat_angles = linspace(0, 2*pi, 100);

PlatformInnerX = Platform.InnerDiameter * cos(plat_angles);
PlatformInnerY = Platform.InnerDiameter * sin(plat_angles);

PlatformOuterX = Platform.OuterDiameter * cos(plat_angles);
PlatformOuterY = Platform.OuterDiameter * sin(plat_angles);

Xs = [PlatformInnerX, PlatformOuterX, PlatformOuterX, PlatformInnerX]';
Ys = [PlatformInnerY, PlatformOuterY, PlatformOuterY, PlatformInnerY]';

LowZ = zeros(numel(plat_angles), 1);
HighZ = .5 * ones(numel(plat_angles), 1);

Zs = [LowZ; LowZ; HighZ; HighZ];

figure();
Platform.AlphaShape = alphaShape(Xs, Ys, Zs);
plot(Platform.AlphaShape, 'FaceColor', 'black')

%% Boom Generation

%{
    !!!!!!!    
    Need to put the actual transforms in here, these are an approximation
    for now. This is assuming Z is relatively small. Theres definitely a
    sin or cos wrong somewhere too
%}

drawTheta = linspace(0,2*pi, length(Boom.Theta));
R = Boom.Diameter/2;
CircleX = R*cos(drawTheta);
CircleY = R*sin(drawTheta);

figure();
for i = 1:5:length(Boom.Theta)

    BoomEndX = Boom.Length.*cos(Boom.Theta(i));
    BoomEndY = Boom.Length.*sin(Boom.Theta(i));
    BoomEndZ = Boom.Length.*sin(Boom.Phi(i)) + Boom.VerticalDisplacement;

    RealCircleX = CircleX .* cos(Boom.Theta(i));
    RealCircleY = CircleY .* sin(Boom.Theta(i));

    BeginningX = RealCircleX;
    BeginningY = RealCircleY;

    EndX = RealCircleX + BoomEndX;
    EndY = RealCircleY + BoomEndY;

    % Right?
    CircleZ = R*sin(drawTheta).*cos(Boom.Phi(i)) + Boom.VerticalDisplacement;

    BeginningZ = CircleZ;
    EndZ = CircleZ + BoomEndZ;
    Xs = [BeginningX'; EndX'];
    Ys = [BeginningY'; EndY'];
    Zs = [BeginningZ'; EndZ'];

    tempAlphaShape = alphaShape(Xs, Ys, Zs);
    plot(tempAlphaShape, 'FaceColor', 'red')
    axis([0 2.5 0 2.5 0 1])
    pause(.01);



    %clf

end