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

    Real measurements of everything

    Fix angle issues

    Get real data for x, z, and thetas

    ROTATE THEN TRANSLATE
    Hip is detaching from boom arm

    Z value for ee is off now. Rotation matrices are hiding the problem im
    pretty sure
    
    Distal approach seems wrong.  I think what I need to do is something
    closer to the approach in Derek's function.  Alpha' and 'Beta' as I
    drew on the board will always be the same, it's just the average of the
    two that will change.  So the linkage only moves up and down on a line
    that is drawn as the average of the two motor angles

    FiveBarFK_Symmetric_Coaxial is returning values of x and z when angle 1
    is 0 that are unacceptable to the function
    
    Distal equation gives a lot of problems rn. Back to the drawing board
    with the function and figure out how to find those angles.  Take
    advantage of Derek's function returning theta and R between the links
    instead of just X and Y?

    Distal link rotation matrix is off!
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
Linkage.Proximal.Left.Theta =   pi* ones(length(thetas), 1);
Linkage.Proximal.Right.Theta = 0* ones(length(thetas), 1);

Linkage.Distal.Length = .57;
Linkage.Distal.Height = .1;
Linkage.Distal.Thickness = .1;

% Returns x and z as if theta is up!(Quadrant 1 and 2)
for g = 1:length(Linkage.Proximal.Left.Theta)
    [x(g), z(g)] = FiveBarFK_Symmetric_Coaxial(Linkage.Proximal.Right.Theta(g),Linkage.Proximal.Left.Theta(g),Linkage.Proximal.Length,Linkage.Distal.Length);
end


% Both need to be negative becasuse fo the way the function above works
Linkage.EndEffector.X = -x;
Linkage.EndEffector.Z = -z;


boomPlotter(Platform, Boom, Hip, Linkage);