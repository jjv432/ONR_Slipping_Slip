function [h2, HipXs, HipYs, HipZs] =  drawHipInWorld(rotMatrix, hipCoord, BoomXs, BoomYs, BoomZs)

% Hip -----------------------------

    temphipCoord = rotMatrix * hipCoord;
    HipXs = temphipCoord(1,:) + mean(BoomXs(5:end));
    HipYs = temphipCoord(2,:) + mean(BoomYs(5:end));
    HipZs = -temphipCoord(3,:) + mean(BoomZs(5:end));
    % only doing the last four because those are the four points at
    % the end of the boom

    HipAlphaShape = alphaShape(HipXs', HipYs', HipZs');
    h2 = plot(HipAlphaShape, 'FaceColor', 'white');

end