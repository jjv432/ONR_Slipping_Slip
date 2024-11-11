function [h5, dlXs, dlYs, dlZs] =  drawDistalLeftInWorld(rotMatrix, distalLeftCoords, plXs, plYs, plZs, i)

 % Distal Left ------------------------
    
    tempDistalLeftCoord = rotMatrix * (distalLeftCoords(:, :, i)');

    dlXs = tempDistalLeftCoord(1,:) + mean(plXs(5:end));
    dlYs = tempDistalLeftCoord(2,:) + mean(plYs(5:end));
    dlZs = -tempDistalLeftCoord(3,:) + mean(plZs(5:end));

    DLAlphaShape = alphaShape(dlXs', dlYs', dlZs');
    h5 = plot(DLAlphaShape, 'FaceColor', 'white');

end