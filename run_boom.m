%{
    Only get data from the boom; don't run motors
%}

% Set run parameters
stride_frequency = 2; % Hz
num_loops = 50;

% Create connection to boom ROS network
boom = BoomController();

pause(5);
% Start recording
boom.startRecording(floor(num_loops / stride_frequency * 50));


% Pause until the action is done
period = num_loops / stride_frequency; % s
pauseSafe(boom, period + 1.0);

% Stop recording
boom.stopRecording();

% Get results from boom encoders
boom_data = parseBoomData(boom.BoomData);