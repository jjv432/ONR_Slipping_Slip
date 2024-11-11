function distalRightCoords = makeRightDistal(Linkage, Phi)

Xdr = Linkage.Distal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ydr = Linkage.Distal.Length*[0 0 0 0 1 1 1 1];
Zdr = Linkage.Distal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

distalRightCoord = [Xdr; Ydr; Zdr];

L1 = Linkage.Proximal.Length;
L2 = Linkage.Distal.Length;

PRtheta = Linkage.Proximal.Right.Theta;
PLtheta = Linkage.Proximal.Left.Theta;

for a = 1:length(PRtheta)

    alpha = PRtheta(a)- Phi(a);
    sigma = pi - alpha;
    beta = asin(sin(sigma) * L1/L2);
    DRtheta = (Phi(a) + pi + beta);

    distalRightCoords(:, :, a) = distalRightCoord' * [1 0 0; 0 cos(DRtheta) -sin(DRtheta); 0 sin(DRtheta) cos(DRtheta)];
end

end