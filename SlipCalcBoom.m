clc
close all
clearvars
format compact
t = readstruct("BoomData_HandActuated.json");
addpath("PlottingFunctions\");
%{

    World frame: Z up, x-y in-plane with ground 
    0 in vertical axis is the Ground, not the track!
    
%}

%% TODO Notes
%{

    Real measurements of everything

    Get real data for x, z, and thetas

%}

%% Sorting Data
time = t.time;
height = t.height;

thetas = t.orientation* 10; % Why off by this factor?
phis = height * (2*pi)/(4*4096*3); % double check
%% Creating Objects for each part of the system
Platform.OuterDiameter = 1.5;
Platform.InnerDiameter = 1.0;
Platform.Thickness = 0.1; %height between bottom of boom to top of platform

Boom.VerticalDisplacement = .75; % meters %MEASURE
Boom.Length = 1.25; % m
Boom.Diameter = .025; % m
Boom.Phi = phis; % Right?
Boom.Theta = thetas;

Hip.Height = .5;
Hip.Width = 0.2;
Hip.Thickness = 0.15;

Linkage.EndEffector.Radius = .1;
Linkage.EndEffector.Thickness = .1;

Linkage.Proximal.Length = .25;
Linkage.Proximal.Height = .1;
Linkage.Proximal.Thickness = .1;
Linkage.Proximal.Left.Theta = 3*pi/4* ones(length(thetas), 1);
Linkage.Proximal.Right.Theta = 0* ones(length(thetas), 1);

Linkage.Distal.Length = .57;
Linkage.Distal.Height = .1;
Linkage.Distal.Thickness = .1;

[x, z, Phi, R] = FiveBarFK_Symmetric_Coaxial(Linkage.Proximal.Right.Theta,Linkage.Proximal.Left.Theta,Linkage.Proximal.Length,Linkage.Distal.Length);

Linkage.EndEffector.X = -x;
Linkage.EndEffector.Z = -z;

boomPlotter(Platform, Boom, Hip, Linkage, Phi);