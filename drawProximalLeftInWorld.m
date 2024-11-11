function [h3, plXs, plYs, plZs] =  drawProximalLeftInWorld(rotMatrix, proximalLeftCoords, HipXs, HipYs, HipZs, i)

% Proximal Left ------------------------
    

    tempProximalLeftCoord = rotMatrix * (proximalLeftCoords(:, :, i)');

    plXs = tempProximalLeftCoord(1,:) + mean(HipXs(5:end));
    plYs = tempProximalLeftCoord(2,:) + mean(HipYs(5:end));
    plZs = -tempProximalLeftCoord(3,:) + mean(HipZs(5:end));% + .1*Hip.Height; %FIND THE REAL VALUE

    PLAlphaShape = alphaShape(plXs', plYs', plZs');
    h3 = plot(PLAlphaShape, 'FaceColor', 'black');


end