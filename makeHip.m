function hipCoord = makeHip(Hip)

% Assuming hip is symmetric about its connection to the arm (vertically)
% starting at vertex at min x, min y, min z. Making coordinates such that
% its easy to line up with the left face, not the center

Xh = Hip.Thickness*[0, 0, 0, 0, 1, 1, 1, 1];
Yh = Hip.Width*[-.5, .5, .5, -.5, -.5, .5, .5, -.5];
Zh = Hip.Height*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];


hipCoord = [Xh; Yh; Zh];

end