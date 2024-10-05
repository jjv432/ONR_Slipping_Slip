clc
close all
format compact

%% TO DO
%{

    Deal with take files that contain NaN. Better way than just skipping
    past them?
%}

%% Intro 
% Parses all of the marker data from the test.  Uses the interpolated
% positinos for each of the X, Y, Z coordinates for each marker (the latter
% half of the columns)



%%
cd 'Global Boom'
FileNames = strcat('Global Boom/', string(ls("*csv")));
cd ..;


% Marker count then number of rigid bodies
MarkerInfos = [
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    3, 1;
    ];

% Every row is a new test, numerous columns for numerous bodies
BodyNameLists = [
    "Leg";
    "Leg";
    "Leg";
    "Leg";
    "Leg";
    "Leg";
    "Leg";
    "Leg";
    "Leg";

    ];

normalizeBools = [
    1
    1
    1
    1
    1
    1
    1
    1
    1

    ];

saveBools = [
    0
    0
    0
    0
    0
    0
    0
    0
    0

    ];


FileNames([2 5:end]) = [];

MinProminenceValues = [
    0.005
    0.005
    0.005
    0
    0.005
    0.005
    0.005
    ];

for i = 1:length(FileNames)
    clearvars -except FileNames MarkerInfos BodyNameLists normalizeBools saveBools i MinProminenceValues
    T = optitrackInterp(FileNames(i, :), MarkerInfos(i, :), BodyNameLists(i, :), normalizeBools(i), saveBools(i));


    % hand tuned prominence, will need to figure out an inteligent way to
    % do this in the future

    marker1maxes = islocalmax(T.BoomLeg_2406Marker1Y, "MinProminence", MinProminenceValues(i));
    %marker1mins = islocalmin(T.BoomLeg_2406Marker1Y, "MinProminence",
    %0.004);
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



    %% Organizing the beginning and end of the ground portions

    groundIndexes = sort([groundBegin, groundEnd]);
    groundIndexes = groundIndexes(2:(end-1));


    %% Change in arc length

    % how do I get slip from this? Definitely can treat as linear; dtheta
    % is so small approx as straight line

    % Normalize values, take RSS, then compare magnitude? Normalize on
    % beginning to get beginning slip, then normalize on end to get end
    % slip? Doesn't let you account for slipping in the middle, though this
    % is less likely...

%% Plotting

    figure()

    subplot(3,1,1)
    plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
    hold on
    plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
    hold on
    plot(T.Time(groundBegin), T.BoomLeg_2406Marker1Y(groundBegin), 'go')
    hold on
    plot(T.Time(groundEnd), T.BoomLeg_2406Marker1Y(groundEnd), 'bo')
    ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])

    title(strcat("Results from i = ", num2str(i)))

    subplot(3,1,2)
    plot(T.Time, T.BoomLeg_2406Marker1Y, 'k')
    hold on
    plot(T.Time(marker1maxes), T.BoomLeg_2406Marker1Y(marker1maxes), 'rx')
    hold on
    for a = 1:2:length(groundIndexes)
        fill([T.Time(groundIndexes(a)),T.Time(groundIndexes(a)), T.Time(groundIndexes(a+1)), T.Time(groundIndexes(a+1))], [min(T.BoomLeg_2406Marker1Y) .06 .06 min(T.BoomLeg_2406Marker1Y)], 'b')
        alpha(.05)
    end
    ylim([min(T.BoomLeg_2406Marker1Y), (max(T.BoomLeg_2406Marker1Y(marker1maxes))*1.1)])

    

    subplot(3,1,3)
    plot(T.BoomLeg_2406Marker1X(groundIndexes(1):groundIndexes(2)), T.BoomLeg_2406Marker1Z(groundIndexes(1):groundIndexes(2)))
    hold on
    plot(T.BoomLeg_2406Marker1X(groundIndexes(1)), T.BoomLeg_2406Marker1Z(groundIndexes(1)), 'ro')
    hold on
    plot(T.BoomLeg_2406Marker1X(groundIndexes(2)), T.BoomLeg_2406Marker1Z(groundIndexes(2)), 'go')
end
