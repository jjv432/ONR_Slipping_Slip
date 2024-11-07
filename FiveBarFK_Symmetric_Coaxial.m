function [X, Y] = FiveBarFK_Symmetric_Coaxial(M1,M2,L1,L2)
% a function to calculate the forward kinematics of a symmetric and coaxial
% five bar linkage. Written by Derek Vasquez 6 June 2024.

% Edited by Jack Vranicar 04 Novemeber 2024


Theta = (M1+M2)/2;
Lb = L1*sqrt(2*(1-cos(M2-M1)));
psi34 = acos(Lb^2/(2*Lb*L2))-asin((L1/Lb)*sin(M2-M1));
R = sqrt(L1^2+L2^2-2*L1*L2*cos(psi34));

X = R*cos(Theta);
Y = R*sin(Theta);

end