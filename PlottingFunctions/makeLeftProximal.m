function proximalLeftCoords = makeLeftProximal(Linkage)

Xpl = Linkage.Proximal.Thickness*[0, 0, 1, 1, 1, 1, 0, 0];
Ypl = Linkage.Proximal.Length*[0 0 0 0 1 1 1 1];
Zpl = Linkage.Proximal.Height*[-.5 .5 .5 -.5 -.5 .5 .5 -.5];

proximalLeftCoord = [Xpl; Ypl; Zpl];

PLtheta = Linkage.Proximal.Left.Theta;

for a = 1:length(PLtheta)
    proximalLeftCoords(:, :, a) = proximalLeftCoord' * [1 0 0; 0 cos(PLtheta(a)) -sin(PLtheta(a)); 0 sin(PLtheta(a)) cos(PLtheta(a))];
end


end