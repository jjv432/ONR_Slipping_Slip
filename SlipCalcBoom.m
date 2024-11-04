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

    End effecter X and Y should just be calculated atp, or only can use
    real x and z
    
%}

%% Sorting Data
height = t.height;
thetas = t.orientation* 10; % Why off by this factor?
time = t.time;

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

Linkage.Proximal.Length = .25;
Linkage.Proximal.Height = .1;
Linkage.Proximal.Thickness = .1;
Linkage.Proximal.Left.Theta =  0 * ones(length(thetas), 1);
Linkage.Proximal.Right.Theta =  0 * ones(length(thetas), 1);

Linkage.Distal.Length = .57;
Linkage.Distal.Height = .1;
Linkage.Distal.Thickness = .1;

x = 0*ones(length(thetas), 1);
z = -sqrt(Linkage.Distal.Length^2 - Linkage.Proximal.Length^2) * ones(length(thetas), 1);


Linkage.EndEffector.X = x;
Linkage.EndEffector.Z = z;

boomPlotter(t, Platform, Boom, Hip, Linkage);