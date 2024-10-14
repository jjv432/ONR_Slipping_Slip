
clc
close all
clearvars
format compact
t = readstruct("BoomData_HandActuated.json");
%{

    Get height to return for the boom!
    
%}

L = 2;
x = 1;
z = 1;
h = 0.5;

%%
height = t.height;
thetas = t.orientation;
time = t.time;

x = .01*ones(length(thetas), 1);
z = .01* sin(1:length(thetas));

phis = height * (2*pi)/(4*4096*3);

for i = 1:length(thetas)

phi = phis(i);
theta = thetas(i);

nRb = [cos(phi)*cos(theta) - sin(phi)*sin(theta), - cos(phi)*sin(theta) - cos(theta)*sin(phi), 0;
cos(phi)*sin(theta) + cos(theta)*sin(phi),   cos(phi)*cos(theta) - sin(phi)*sin(theta), 0;
                                      0,                                           0, 1];


bx_hat =  nRb(:,1);
bz_hat = nRb(:,3);

no_r_fo(:, i) = (L + x(i))* nRb(:, 1) + z(i) * nRb(:,3) + h*[0; 0; 1];
end
%%
% figure()
% for j = 1:i
%     hold on
% plot3(no_r_fo(1,j), no_r_fo(2,j), no_r_fo(3,j), '.')
% pause(.1)
% axis([0 1 0 1 0 1])
% end

figure()
for j = 1:i
    hold on
plot(no_r_fo(1,j), no_r_fo(3,j), 'xr')
pause(.1)
axis([0 2.5 0.25 .75])
end