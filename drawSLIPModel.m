function [h1] = drawSLIPModel(x_vals, y_vals, midpoint_x, params, state)


drawThetas = linspace(0, 2*pi, 100);

% Drawing the original mass shape
mass_radius = params.mass_radius;
mass_xvals = mass_radius * cos(drawThetas);
mass_yvals = mass_radius * sin(drawThetas);

% Drawing the effector;
effector_x = [0 0 1 1];
effector_y = [-.01 .01 .01 -.01];
effector_coords = [effector_x; effector_y];


% Looping over the values from the simulation
for i = 1:200:length(x_vals)

    % Plotting the mass
    moved_mass_x = mass_xvals + x_vals(i);
    moved_mass_y = mass_yvals + y_vals(i);
    h1 = fill(moved_mass_x, moved_mass_y, 'r');


    % This is for the effector.  It changes behavior based on if it's in
    % flight or in stance
    switch state
        case 'stance'
            x_effector_contact = midpoint_x;

            % Adjusting the length of the effector
            L = sqrt( (y_vals(i) - 0)^2 + (x_vals(i) - x_effector_contact)^2);
            effector_coords(1, :) = [0 0 L L];

            % Rotating the effector
            theta = atan2(y_vals(i), x_vals(i) - x_effector_contact);
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            effector_rot = R * effector_coords;

            % Drawing the effector
            h2 = fill(effector_rot(1,:) + x_effector_contact, effector_rot(2,:), 'g');
            drawnow;

            axis([-1 2.5 -.5 1])

            delete(h1);
            delete(h2);

        case 'flight'
            drawnow;
            axis([-1 2.5 -.5 1])

            delete(h1);
    end





end