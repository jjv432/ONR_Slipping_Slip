clc
close all
format compact

%% 

% Parses all of the marker data from the test.  Uses the interpolated
% positinos for each of the X, Y, Z coordinates for each marker (the latter
% half of the columns)

%T = optitrack_R2();

% figure()
% hold on
%     plot(T.Time, T.BoomLeg_2406Marker1Y)
%     plot(T.Time, T.BoomLeg_2406Marker2Y)
%     plot(T.Time, T.BoomLeg_2406Marker3Y)

% figure()
% plot3(T.BoomLeg_2406Marker1X, T.BoomLeg_2406Marker1Z, T.BoomLeg_2406Marker1Y)
% hold off

% Really a lucky guess with prominence here. We'll see how well it works in
% the future

plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
hold on
plot(T.Time(islocalmax(T.BoomLeg_2406Marker1Y, "MinProminence", 0.005)), T.BoomLeg_2406Marker1Y(islocalmax(T.BoomLeg_2406Marker1Y, "MinProminence", 0.005)), 'rx')





clf
figure()

pause(.01)
for i = 1:length(T.Time)
    hold on
    plot(T.Time(i), T.BoomLeg_2406Marker1Y(i), '.k')
  
    
    
    axis([min(T.Time), max(T.Time), 0, .1])
    pause(.01)


end