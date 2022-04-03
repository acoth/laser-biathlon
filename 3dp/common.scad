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
/*
barrelLength=300;
barrelOuter = 16;
frontSightSep = 13.5;
supVspace = frontSightSep-barrelOuter*sqrt(3)/4+0.75;
crossPitch=barrelLength/(2*round((barrelLength/(barrelOuter*1.6)-1)/2)+1);
tt=1.5;
tp = 1;
tflex = 0.8;
baseline = -10;
rb = barrelOuter/2-tt/2;
pfo = -10;
pl = 19.5;
pw = 5.5;
notch = 2.5;
ph = rb+notch;
m5w = 20;
m5l = 28;
a = 11.5;
b = 2;
c = sqrt(a*a+b*b);
x=35;

y=15;
t=1.2;
ri=0.6;
g=1;
bt=2;
range=3;
f = (2*ri+t)/c;
yy = y+4*b+3*f*a;
x2 = x+2*g+3*t;
nr=3.1;
skew = 3;
tw=1.5;
hw=17.5;
hh=25;
cf = 6.75/2;
nr = 6.5;
xh = 1;
rh = hw-2*cf;
$fs=0.25;
$fa=2.5;
f = 1.25;
nh = nr;
*/

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
