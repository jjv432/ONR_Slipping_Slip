function [h6, drXs, drYs, drZs] =  drawDistalRightInWorld(rotMatrix, distalRightCoords, prXs, prYs, prZs, i)

  % Distal Right ------------------------
    
    tempDistalRightCoord = rotMatrix * (distalRightCoords(:, :, i)');

    drXs = tempDistalRightCoord(1,:) + mean(prXs(5:end));
    drYs = tempDistalRightCoord(2,:) + mean(prYs(5:end));
    drZs = -tempDistalRightCoord(3,:) + mean(prZs(5:end));

    DRAlphaShape = alphaShape(drXs', drYs', drZs');
    h6 = plot(DRAlphaShape, 'FaceColor', 'white');
    

end