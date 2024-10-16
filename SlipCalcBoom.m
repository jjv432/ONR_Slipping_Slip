clc
close all
clearvars
format compact
t = readstruct("BoomData_HandActuated.json");
%{

    World frame: Z up, x-y in-plane with ground
    
%}

L = 2;
x = 1;
z = 1;
h = 0.5;

%% Sorting Data
height = t.height;
thetas = t.orientation;
time = t.time;

x = .01*ones(length(thetas), 1);
z = .01* sin(1:length(thetas));

phis = height * (2*pi)/(4*4096*3);

%% Creating Objects for each part of the system
Platform.OuterDiameter = 1.5;
Platform.InnerDiameter = 1.0;
Platform.Thickness = 0.001; %height between bottom of boom to top of platform

Boom.VerticalDisplacement = 0.05; % meters 
Boom.Length = 1.25; % m
Boom.Diameter = .025; % m
Boom.Phi = phis;
Boom.Theta = thetas;

Hip.Height = 1; 
Hip.Width = 0.5;
Hip.Thickness = 0.5;

Linkage.EndEffector = x; % FIX!

boomPlotter(Platform, Boom, Hip, Linkage);


%% Plotting
for i = 1:length(thetas)

phi = phis(i);
theta = thetas(i);

nRb = [
    cos(phi)*cos(theta) - sin(phi)*sin(theta), - cos(phi)*sin(theta) - cos(theta)*sin(phi), 0;
    cos(phi)*sin(theta) + cos(theta)*sin(phi),   cos(phi)*cos(theta) - sin(phi)*sin(theta), 0;
    0, 0, 1
    ];


bx_hat =  nRb(:,1);
bz_hat = nRb(:,3);

no_r_fo(:, i) = (L + x(i))* nRb(:, 1) + z(i) * nRb(:,3) + h*[0; 0; 1];
end
%%
% figure()
for j = 1:i
    hold on
plot3(no_r_fo(1,j), no_r_fo(2,j), no_r_fo(3,j), '.')
pause(.1)
axis([-2.5 2.5 -2.5  2.5 0 1])
view(-45, 15);
end

% figure()
% for j = 1:i
%     hold on
% plot(no_r_fo(2,j), no_r_fo(1,j), '.')
% pause(.1)
% %axis([0 2.5 0.25 .75])
% axis('auto')
% end
