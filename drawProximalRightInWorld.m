function [h4, prXs, prYs, prZs] =  drawProximalRightInWorld(rotMatrix, proximalRightCoords, HipXs, HipYs, HipZs, i)

 % Proximal Right ------------------------
    
    tempProximalRightCoord = rotMatrix * (proximalRightCoords(:, :, i)');

    prXs = tempProximalRightCoord(1,:) + mean(HipXs(5:end));
    prYs = tempProximalRightCoord(2,:) + mean(HipYs(5:end));
    prZs = -tempProximalRightCoord(3,:) + mean(HipZs(5:end)); %+ .1*Hip.Height; %FIND THE REAL VALUE

    PRAlphaShape = alphaShape(prXs', prYs', prZs');
    h4 = plot(PRAlphaShape, 'FaceColor', 'black');


end