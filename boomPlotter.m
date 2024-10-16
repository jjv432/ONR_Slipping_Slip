function boomPlotter(Platform ,Boom, Hip, Linkage)

%% Platform generation
plat_angles = linspace(0, 2*pi, 100);

PlatformInnerX = Platform.InnerDiameter * cos(plat_angles);
PlatformInnerY = Platform.InnerDiameter * sin(plat_angles);

PlatformOuterX = Platform.OuterDiameter * cos(plat_angles);
PlatformOuterY = Platform.OuterDiameter * sin(plat_angles);

Xs = [PlatformInnerX, PlatformOuterX]
Ys = [PlatformInnerY, PlatformOuterY];

Xs = [Xs, PlatformOuterX, PlatformInnerX]
Ys = [Ys,  PlatformOuterY, PlatformInnerY]

Zs = [zeros(length(plat_angles), 1); zeros(length(plat_angles), 1); Platform.Thickness* ones(length(plat_angles),1); Platform.Thickness* ones(length(plat_angles), 1)]



figure();
fill3(Xs, Ys, Zs, 'k')

end