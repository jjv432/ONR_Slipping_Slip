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
axis([-2 2 -2 2 -2 2])
pause(1)

%% Boom Arm 


BoomAnglesGround = data.orientation;
BoomAnglesVertical = data.tilt/(4*4960); %CHECK THIS!

%https://en.wikipedia.org/wiki/Rotation_matrix
alphas = BoomAnglesGround;
betas = BoomAnglesVertical;
gammas = zeros(length(alphas), 1);

for i = 1:length(alphas)

    alpha = alphas(i);
    beta = betas(i);
    gamma = gammas(i);

temp = [    
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

R(:, i) = temp * [Boom.Length; 0; 0] - [0; 0; Boom.VerticalDisplacement];

X = [0 R(1,i)];
Y = [0 R(2,i)];
Z = [-Boom.VerticalDisplacement R(3,i)];

h = line(X, Y, -Z, 'LineWidth', 5, 'Color', 'black');
pause(.1)
%view(45, 45)
delete(h);

end


