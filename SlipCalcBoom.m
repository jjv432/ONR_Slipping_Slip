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

    Math, including fixing orientation (off by about a quarter)

    Real measurements of everything

    Make objects that are round closer to round (instead of squares/ low-
    res polys)

    Consider running this, saving all of the alpha shapes, THEN plotting.
    This will allow for realistic dts as there will be (relatively) little
    processing time, and the delay can just be set to the dt of the boom
    measurements instead of some arbitrary value.

    Hip looks like it slides across boom when close to the ground. Not sure
    why
    
%}

%% Sorting Data
height = t.height;
thetas = t.orientation;
time = t.time;

%x = .15* cos(1:length(thetas));
x = zeros(length(thetas), 1);
z = .1* sin(.001 * 1:length(thetas)) +.10;

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
Hip.Width = 0.2;
Hip.Thickness = 0.15;

Linkage.EndEffector.Radius = .1;
Linkage.EndEffector.Thickness = .1;

Linkage.EndEffector.X = x;
Linkage.EndEffector.Z = z;

Linkage.Proximal.Length = .5;
Linkage.Proximal.Height = .1;
Linkage.Proximal.Thickness = .1;
Linkage.Proximal.Left.X = zeros(length(thetas), 1);
Linkage.Proximal.Left.Z = zeros(length(thetas), 1);


Linkage.Distal.Length = .25;
Linkage.Distal.Thicknes = .1;

boomPlotter(t, Platform, Boom, Hip, Linkage);