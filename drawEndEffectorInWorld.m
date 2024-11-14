function [h7, eeXs, eeYs, eeZs] =  drawEndEffectorInWorld(rotMatrix, effectorCoord, dlXs, dlYs, dlZs, drXs, drYs, drZs)

% End Effector ------------------------
    tempeffecotrCoord = rotMatrix * effectorCoord;
    eeXs = tempeffecotrCoord(1,:)+ mean([dlXs(5:end) drXs(5:end)]);
    eeYs = tempeffecotrCoord(2,:) + mean([dlYs(5:end) drYs(5:end)]);
    eeZs = -tempeffecotrCoord(3,:) + mean([dlZs(5:end) drZs(5:end)]);

    EEAlphaShape = alphaShape(eeXs', eeYs', eeZs');
    h7 = plot(EEAlphaShape, 'FaceColor', 'blue');
    

end