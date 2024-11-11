function [rotMatrix] = boomFrame2WorldFrame(alphas, betas, gammas)
% Rotation angles

for i = 1:length(alphas)
    alpha = alphas(i);
    beta = betas(i);
    gamma = gammas(i);


    % Rotation matrix to get boom end in world frame

    rotMatrix (:, :, :, i) = [
        cos(alpha), -sin(alpha), 0;
        sin(alpha), cos(alpha), 0;
        0, 0, 1

        ] * [

        cos(beta), 0, sin(beta);
        0, 1, 0;
        -sin(beta), 0, cos(beta)

        ] * [

        1, 0, 0;
        0, cos(gamma), -sin(gamma);
        0, sin(gamma), cos(gamma);
        ];

end
end