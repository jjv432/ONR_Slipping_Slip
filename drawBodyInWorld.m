function [h, BodyXs, BodyYs, BodyZs] =  drawBodyInWorld(rotMatrix, Coords, ParentXs, ParentYs, ParentZs, i, color)

    tempProximalLeftCoord = rotMatrix * (Coords(:, :, i)');

    BodyXs = tempProximalLeftCoord(1,:) + mean(ParentXs(5:end));
    BodyYs = tempProximalLeftCoord(2,:) + mean(ParentYs(5:end));
    BodyZs = -tempProximalLeftCoord(3,:) + mean(ParentZs(5:end));% + .1*Hip.Height; %FIND THE REAL VALUE

    BodyAlphaShape = alphaShape(BodyXs', BodyYs', BodyZs');
    h = plot(BodyAlphaShape, 'FaceColor', color);


end