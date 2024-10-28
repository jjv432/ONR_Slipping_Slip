clc
close all
clearvars
format compact
t = readstruct("BoomData_HandActuated.json");
%{

    World frame: Z up, x-y in-plane with ground 
    0 in vertical axis is the Ground, not the track!
    
%}

%% TODO Notes
%{
    
    Make alpha shapes end on the first element (wrap them around) to make
    it not do the clipping thing?
    
%}

%% Sorting Data
height = t.height;
thetas = t.orientation;
time = t.time;

x = zeros(length(thetas), 1);
z = .15* sin(1:length(thetas)) +.15;

phis = height * (2*pi)/(4*4096*3); % double check

%% Creating Objects for each part of the system
Platform.OuterDiameter = 1.5;
Platform.InnerDiameter = 1.0;
Platform.Thickness = 0.1; %height between bottom of boom to top of platform

Boom.VerticalDisplacement = .75; % meters %MEASURE
Boom.Length = 1.25; % m 
Boom.Diameter = .025; % m
Boom.Phi = phis;
Boom.Theta = thetas;

Hip.Height = .5; 
Hip.Width = 0.25;
Hip.Thickness = 0.25;

Linkage.EndEffector.Radius = .1;
Linkage.EndEffector.Thickness = .1;

Linkage.EndEffector.X = x;
Linkage.EndEffector.Z = z;

boomPlotter(t, Platform, Boom, Hip, Linkage);