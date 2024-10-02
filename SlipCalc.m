clc
close all
format compact

%% 

% Parses all of the marker data from the test.  Uses the interpolated
% positinos for each of the X, Y, Z coordinates for each marker (the latter
% half of the columns)

%T = optitrack_R2();

% hand tuned prominence, will need to figure out an inteligent way to do
% this in the future

marker1maxes = islocalmax(T.BoomLeg_2406Marker1Y, "MinProminence", 0.005);
%marker1mins = islocalmin(T.BoomLeg_2406Marker1Y, "MinProminence", 0.004);
marker1mins = islocalmin(T.BoomLeg_2406Marker1Y);


%% Finding the local minima just before and after the local maxima

groundBegin = [];
groundEnd = [];

for z = 1:length(marker1maxes)
    beginFound = 0;
    endFound = 0;

    if marker1maxes(z)

        t = z;
        while (beginFound==0)
            
            if marker1mins(t) == 1
                groundBegin = [groundBegin, t];
                beginFound = 1;
            else
                t = t-1;
            end

        end

        s = z;
        while(endFound==0)

            if marker1mins(s) == 1
                groundEnd = [groundEnd, s];
                endFound = 1;
            else
                s = s+1;
            end

        end
    end

end



figure()
    plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
    hold on
    plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
    hold on 
    plot(T.Time(groundBegin), T.BoomLeg_2406Marker1Y(groundBegin), 'go')
    hold on 
    plot(T.Time(groundEnd), T.BoomLeg_2406Marker1Y(groundEnd), 'bo')
    ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])

%% Organizing the beginning and end of the ground portions

groundIndexes = sort([allMins, allMaxes]);
groundIndexes = groundIndexes(2:(end-1));

figure()
    plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
    hold on
    plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
    hold on 
    for a = 1:2:length(groundIndexes)
        fill([T.Time(groundIndexes(a)),T.Time(groundIndexes(a)), T.Time(groundIndexes(a+1)), T.Time(groundIndexes(a+1))], [min(T.BoomLeg_2406Marker1Y) .06 .06 min(T.BoomLeg_2406Marker1Y)], 'b')
        alpha(.05)
    end
    ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])


%% Change in arc length

% how do I get slip from this? Definitely can treat as linear; dtheta is so
% small approx as straight line

% Normalize values, take RSS, then compare magnitude? Normalize on
% beginning to get beginning slip, then normalize on end to get end slip?
% Doesn't let you account for slipping in the middle, though this is less
% likely...

figure()
plot(T.BoomLeg_2406Marker1X(groundIndexes(1):groundIndexes(2)), T.BoomLeg_2406Marker1Z(groundIndexes(1):groundIndexes(2)))
hold on
plot(T.BoomLeg_2406Marker1X(groundIndexes(1)), T.BoomLeg_2406Marker1Z(groundIndexes(1)), 'ro')
hold on
plot(T.BoomLeg_2406Marker1X(groundIndexes(2)), T.BoomLeg_2406Marker1Z(groundIndexes(2)), 'go')


%% Old/ proven stuff

% figure()
% 
% plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
%     hold on
%     plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
%     hold on 
%     plot(T.Time(marker1mins), T.BoomLeg_2406Marker1Y(marker1mins), 'go')
%     ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])


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
%https://www.mathworks.com/help/matlab/ref/islocalmax.html#d126e916404

% %Hand tuned prominence values
% marker1maxes = islocalmax(T.BoomLeg_2406Marker1Y, "MinProminence", 0.005);
% marker2maxes = islocalmax(T.BoomLeg_2406Marker2Y, "MinProminence", 0.007);
% marker3maxes = islocalmax(T.BoomLeg_2406Marker3Y, "MinProminence", 0.005);

% figure()
%     subplot(3, 1, 1)
%     plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
%     hold on
%     plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
%     ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])
% 
%     subplot(3, 1, 2)
%     plot(T.Time, T.BoomLeg_2406Marker2Y, 'k')
%     hold on
%     plot(T.Time(marker2maxes), T.BoomLeg_2406Marker2Y(marker2maxes), 'rx')
%     ylim([min(T.BoomLeg_2406Marker2Y), (max(T.BoomLeg_2406Marker2Y(marker2maxes))*1.1)])
% 
%     subplot(3, 1, 3)
%     plot(T.Time, T.BoomLeg_2406Marker3Y, 'k')
%     hold on
%     plot(T.Time(marker3maxes), T.BoomLeg_2406Marker3Y(marker3maxes), 'rx')
%     ylim([min(T.BoomLeg_2406Marker3Y), (max(T.BoomLeg_2406Marker3Y(marker3maxes))*1.1)])
% 
% 
% 


% clf
% figure()
% 
% pause(.01)
% for i = 1:length(T.Time)
%     hold on
%     plot(T.Time(i), T.BoomLeg_2406Marker1Y(i), '.k')
% 
% 
% 
%     axis([min(T.Time), max(T.Time), 0, .1])
%     pause(.01)
% 
% 
% end