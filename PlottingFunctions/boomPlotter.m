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
    
    % Add CoordLenght to the draw function!
    CoordLength = size(armCoord, 1);

    % Draw Arm
    [h1, BoomXs, BoomYs, BoomZs] = drawBodyInWorld(rotMatrix, armCoord', zeros(CoordLength), zeros(CoordLength), Boom.VerticalDisplacement*ones(CoordLength), 1, 'black');

    % Draw Hip
    [h2, HipXs, HipYs, HipZs] =  drawBodyInWorld(rotMatrix, hipCoord', BoomXs, BoomYs, BoomZs, 1, 'white');

    % Draw Proximal Left
    [h3, plXs, plYs, plZs] =  drawBodyInWorld(rotMatrix, proximalLeftCoords, HipXs, HipYs, HipZs, i, 'blue');

    % Draw Proximal Right
    [h4, prXs, prYs, prZs] =  drawBodyInWorld(rotMatrix, proximalRightCoords, HipXs, HipYs, HipZs, i, 'blue');

    % Draw Distal Left
    [h5, dlXs, dlYs, dlZs] =  drawBodyInWorld(rotMatrix, distalLeftCoords, plXs, plYs, plZs, i, 'black');

    % Draw Distal Right
    [h6, drXs, drYs, drZs] =  drawBodyInWorld(rotMatrix, distalRightCoords, prXs, prYs, prZs, i, 'black');

    % Draw End Effector
    % Should fix this so that it requires it to be in the middle of the two
    % distal, quick fix for now
    [h7, eeXs, eeYs, eeZs] =  drawBodyInWorld(rotMatrix, effectorCoord', dlXs, dlYs, dlZs, 1, 'blue');

    view(90+BoomAnglesGround(i)*180/pi, 10)
    drawnow;


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


