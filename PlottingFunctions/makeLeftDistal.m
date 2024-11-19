function distalLeftCoords = makeLeftDistal(Linkage, Phi)

Xdl = Linkage.Distal.Thickness*[-.5, -.5, .5, .5, .5, .5, -.5, -.5];
Ydl = Linkage.Distal.Length*[0 0 0 0 1 1 1 1];
Zdl = Linkage.Distal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

distalLeftCoord = [Xdl; Ydl; Zdl];

L1 = Linkage.Proximal.Length;
L2 = Linkage.Distal.Length;

PRtheta = Linkage.Proximal.Right.Theta;
PLtheta = Linkage.Proximal.Left.Theta;
for a = 1:length(PLtheta)

    alpha = PLtheta(a)- Phi(a);
    sigma = pi - alpha;
    beta = asin(sin(sigma) * L1/L2);
    DLtheta = ( Phi(a) + pi + beta);
   
    distalLeftCoords(:, :, a) = distalLeftCoord' * [1 0 0; 0 cos(DLtheta) -sin(DLtheta); 0 sin(DLtheta) cos(DLtheta)];
end

end