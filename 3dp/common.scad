include <Round-Anything/polyround.scad>

quality = 1;
horizSightSep = 500;
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
$fa=2.5;
$fs=.25;


cf = 6.75/2;

nh = nr;

ri = tw/2;
hUpper = rMinBarrel*2+tw-ri;
hLower = -nh-tw-0*cf-rMinBarrel-tw;
    stickWidth  = 25.5;
    stickLength = 48.2;
    stickHeight = 13.7;

rLower = nh+tw;
rUpper = rLower;
upperFlat = hw-rUpper;
tp = 1;

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
