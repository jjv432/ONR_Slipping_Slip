syms phi theta
nRa = [
    cos(theta), -sin(theta), 0
    sin(theta), cos(theta), 0
    0 0 1
];

aRb = [
    cos(phi) -sin(phi) 0
    sin(phi) cos(phi) 0
    0 0 1

];

nRb = nRa * aRb
