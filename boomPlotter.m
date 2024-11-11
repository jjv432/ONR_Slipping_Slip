function boomPlotter(Platform ,Boom, Hip, Linkage, Phi)


%{

 **** Be careful with multiple translations, the lenghts are not rotated
 and therefore are not in the right frame.  Need to make these adjustments
 before the rotation occurs

%}


%% Data sorting

BoomAnglesGround = Boom.Theta;
BoomAnglesVertical = Boom.Phi; %CHECK THIS!

%https://en.wikipedia.org/wiki/Rotation_matrix
alphas = BoomAnglesGround;
betas = BoomAnglesVertical;
gammas = zeros(length(alphas), 1);

%% Platform
drawPlatform(Platform);

%% Boom Arm
armCoord = makeArm(Boom);

%% Hip
hipCoord = makeHip(Hip);

%% End Effecter
effectorCoord = makeEndEffector(Linkage);

%% Left Proximal Link
proximalLeftCoords = makeLeftProximal(Linkage);

%% Right Proximal Link
proximalRightCoords = makeRightProximal(Linkage);

%% Left Distal Link
distalLeftCoords = makeLeftDistal(Linkage, Phi);

%% Right Distal Link
distalRightCoords = makeRightDistal(Linkage, Phi);

%% Rotation Matrices
rotMatrices = boomFrame2WorldFrame(alphas, betas, gammas);

%% Moving the bodies
for i = 1:10:length(alphas)
    axis([-2 2 -2 2 0 2]);
    rotMatrix = rotMatrices(:, :, :, i);

    [h1, BoomXs, BoomYs, BoomZs] = drawArmInWorld(rotMatrix, armCoord, Boom);
    [h2, HipXs, HipYs, HipZs] =  drawHipInWorld(rotMatrix, hipCoord, BoomXs, BoomYs, BoomZs);
    [h3, plXs, plYs, plZs] =  drawProximalLeftInWorld(rotMatrix, proximalLeftCoords, HipXs, HipYs, HipZs, i);
    [h4, prXs, prYs, prZs] =  drawProximalRightInWorld(rotMatrix, proximalRightCoords, HipXs, HipYs, HipZs, i);
    [h5, dlXs, dlYs, dlZs] =  drawDistalLeftInWorld(rotMatrix, distalLeftCoords, plXs, plYs, plZs, i);
    [h6, drXs, drYs, drZs] =  drawDistalRightInWorld(rotMatrix, distalRightCoords, prXs, prYs, prZs, i);
    [h7] =  drawEndEffectorInWorld(rotMatrix, effectorCoord, dlXs, dlYs, dlZs, drXs, drYs, drZs);


    % Cleanup ----------------------------
    pause(.1);
    delete(h1)
    delete(h2);
    delete(h3);
    delete(h4);
    delete(h5);
    delete(h6);
    delete(h7);


end


