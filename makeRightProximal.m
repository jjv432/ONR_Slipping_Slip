function proximalRightCoords = makeRightProximal(Linkage)

Xpr = Linkage.Proximal.Thickness*[0, 0, 1, 1, 1, 1, 0, 0];
Ypr = Linkage.Proximal.Length*[0 0 0 0 1 1 1 1];
Zpr = Linkage.Proximal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

proximalRightCoord = [Xpr; Ypr; Zpr];

PRtheta = Linkage.Proximal.Right.Theta;

for a = 1:length(PRtheta)
    proximalRightCoords(:, :, a) = proximalRightCoord' * [1 0 0; 0 cos(PRtheta(a)) -sin(PRtheta(a)); 0 sin(PRtheta(a)) cos(PRtheta(a))];
end


end