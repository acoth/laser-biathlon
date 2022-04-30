include <Round-Anything/polyround.scad>

quality =  (is_undef(quality)) ? 1 :quality;

//horizSightSep = 466;
leftHanded = false;
gap = 1;
tf = 0.8;
tw = 1.5;
epsilon = .01;
fn=3*quality;
nr = 6.5;
rMinBarrel = (nr-tw/2)/sqrt(3);
hw=18.5;
mil=.0254;
lw = 16;
a = 11.5;
b = 2;
c = sqrt(a*a+b*b);
x=35;
y=15;
t=1.2;
rSpring=0.6;
f = (2*rSpring+t)/c;
yy = y+4*b+3*f*a;
rearSightDepth = yy+8*t;
cf = 6.75/2;
sw1 = 8.5;
triggerTop = 10+epsilon;
triggerDrop = triggerTop+25;

gripHeight = 70;
handHeight = 20;

triggerToButt = 216;
triggerX = 77;


sw2 = 4;

nh = nr;

ri = tw/2;
hUpper = rMinBarrel*2+tw-ri;
hLower = -nh-tw-0*cf-rMinBarrel-tw;
bottom = hLower-triggerDrop-gripHeight;

    stickWidth  = 25.5;
    stickLength = 48.2;
    stickHeight = 13.7;

rLower = nh+tw;
rUpper = rLower;
upperFlat = hw-rUpper;
tp = 1;
laserL = 30;
laserD = 10;

backExt = laserL+sqrt(pow(laserL,2)+pow(laserD,2))-ri+stickLength+1.5*tw+300*mil;
supLength = 300-backExt;
aspect = 1.8;
sightXSep = 469;
m3nr=3;

barrelExt = sightXSep-supLength-backExt-yy;
adjustMin = 50;
adjustMax = supLength-aspect*rUpper-tw-cf;

// Produce a symmetrical copy of child object, mirrored around plane with
// specified normal vector
module unionMirror(mirNorm) {
    children();
    mirror(mirNorm) children();
}

module barpp(r,v1,v2){
    dx=v2.x-v1.x;
    dy=v2.y-v1.y;
    dz=v2.z-v1.z;
    length = sqrt(dx*dx+dy*dy+dz*dz);
    phi = acos(dz/length);
    theta = atan2(dy,dx);
    translate(v1)rotate([0,phi,theta]) cylinder(r=r,h=length);    
}

module triHole(r,h,rr,rh1,rh2){
    translate([0,0,-h/2-epsilon]) polyRoundExtrude([
                    [-r,-r*sqrt(3)/3,rr],
                    [r,-r*sqrt(3)/3,rr],
                    [0,r*sqrt(3)*2/3,rr]],
                    h+2*epsilon,rh1,rh2,fn=3*quality);
}
module triArray(rows,cols,pitch,w,h, rr,rh1,rh2){
    py = pitch*sqrt(3)/2;
    
    for  (yi = [0:2*rows-1]){
        xrs = (abs(yi%4-1.5) > 1) ? 1 : 0.5;
        for (xi = [xrs:cols])
            translate([xi*pitch, (yi-(yi%2)/3+0.5)*py/2, 0])
               rotate([0,0,180*(yi%2)])triHole( pitch/2-w*sqrt(3)/2, h, rr,rh1,rh2);
    }
}
module upperBody(to) {
    translate([0,0,-backExt]) scale([1,1,aspect])polyRoundExtrude([
                    [hUpper+to,hw+to,rUpper+to],
                    [hUpper+to,-hw-to,rUpper+to],
                    [hLower-to,-hw-to,rLower+to],
                    [hLower-to,hw+to,rLower+to]],
                (supLength+backExt)/aspect,rUpper+to,0,fn=10);
}
module barFillet(r,q1,q2){
    
    p1 = (q1.z<q2.z) ? q1 : q2;
    p2 = (q1.z<q2.z) ? q2 : q1;    
        
    d = p2-p1;
    theta = atan2(d.y,d.x);
    horizDist = norm([d.x,d.y]);
    translate(p1) rotate([0,0,theta])
    multmatrix([
        [norm([horizDist,d.z])/d.z, 0, horizDist/d.z, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0]])
    polyRoundExtrude([
        [r/2,r/2,r/2-epsilon],
        [r/2,-r/2,r/2-epsilon],
        [-r/2,-r/2,r/2-epsilon],
        [-r/2,r/2,r/2-epsilon]],
        d.z,-r/2+epsilon,-r/2+epsilon,fn=10);
    
}

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
