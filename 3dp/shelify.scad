include <Round-Anything/polyround.scad>

rPoints = [
[0,0,3],
[10,0,1],
[10,2,1],
[2,2,1],
[10,10,1],
[0,10,1]];

function offsetRP(t,p0,p1,p2) = let(
    d10 = [p1.x-p0.x,p1.y-p0.y], 
    d12 = [p1.x-p2.x,p1.y-p2.y],
    u10 = d10/norm(d10),
    u12 = d12/norm(d12),
    v012= (u10+u12)/norm(u10+u12),
    side = sign(cross(u12,u10)),
    o012= v012*t*side*sqrt(2/(1-u10*u12))
    
    ) [p1.x+o012.x,p1.y+o012.y,p1.z+side*t];

function offsetRPoints(t,rPoints) = let(np=len(rPoints))
[ for (k = [0:np-1]) offsetRP(t,rPoints[k],rPoints[(k+1)%np],rPoints[(k+2)%np])];
    