function [h1, BoomXs, BoomYs, BoomZs] =  drawArmInWorld(rotMatrix, armCoord, Boom)

 % Boom --------------------------------
    % X, Y, Z of the end of the boom
    temparmCoord = rotMatrix * armCoord;
    BoomXs = temparmCoord(1,:);
    BoomYs = temparmCoord(2,:);
    BoomZs = -temparmCoord(3,:) + Boom.VerticalDisplacement;

    BoomAlphaShape = alphaShape(BoomXs', BoomYs', BoomZs');
    h1 = plot(BoomAlphaShape, 'FaceColor', 'white');
    %view(45, 20);

end