$fs=0.25;
$fa=2.5;
fn = 10;
//include <common.scad>
include <Round-Anything/polyround.scad>

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


*rearAdj(3);
%cube(37,center=true);

    //use <rearAdj.scad>
*translate([-144.5,0,-6.5])    rearAdj(3);
*translate([-95,0,0]){
    *m5ink();
    m5Mount();
}
*color("red")laser();
*laserHousing();
*barrel(tt);
*foot(140,rb+4);
*sightMount(barrelLength);
*translate([barrelLength-pfo,0,0])sight(13.5);
/*
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

module triHole(x,y,r,ang){
        translate([x,y,-t/4])
        rotate([0,0,ang])
        polyRoundExtrude([
                        [-r,-r*sqrt(3)/3,t/2],
                        [r,-r*sqrt(3)/3,t/2],
                        [0,r*sqrt(3)*2/3,t/2]],
                        3*t+.01,-t*0,-t*0,fn=3);
}
module triArray(start,end,pitch){
    dx = end.x-start.x;
    dy = end.y-start.y;
    py = pitch*sqrt(3)/2;
    
    for  (yi = [0:(dy/py-0.5)*2]){
        xrs = (abs(yi%4-1.5) > 1) ? 1 : 0.5;
        for (xi = [xrs:(dx/pitch-0.5)])
               triHole( start.x+xi*pitch,
                        start.y+(yi-(yi%2)/3+0.5)*py/2,
                        pitch/2-t,180*(yi%2));
    }
}*/

module m5ink(){
    translate([0,0,baseline+tt+.01])
linear_extrude(height=16){
    difference(){
        offset(r=3.875)offset(-3.875)square([2*m5l,2*m5w],center=true);
        for (pm1 = [-1,1]) for (pm2 = [-1,1])
        translate([pm1*24.125,pm2*16.125])circle(d=4.75);
    }
}
}
module m5Mount(){
    ri= 0.5;
    translate([0,0,baseline+.01])
    difference(){
        polyRoundExtrude([  [m5l+tt+ri,m5w+tt+ri,4.5+ri+tt/2],
                            [-m5l-tt-ri,m5w+tt+ri,10],
                            [-m5l-tt-ri-4,(yy+g)/2+2*t,10],
                            [-m5l-tt-ri-8,(yy+g)/2+1.35*t,0],
                            [-m5l-tt-ri-8,(yy+g)/2+0.35*t,0],
                            [-m5l-tt-ri-1,(yy+g)/2+0.35*t,0],
                            [-m5l-tt-ri-1,-(yy+g)/2-0.35*t,0],
                            [-m5l-tt-ri-8,-(yy+g)/2-0.35*t,0],
                            [-m5l-tt-ri-8,-(yy+g)/2-1.35*t,0],
                            [-m5l-tt-ri-4,-(yy+g)/2-2*t,10], 
                            [-m5l-tt-ri,-m5w-tt-ri,10],
                            [m5l+tt+ri,-m5w-tt-ri,4.5+ri+tt/2]],
                        14.5+tt,tt/2-.01,tt/2-.01,fn=fn);
        translate([0,0,tt])
            polyRoundExtrude([  [m5l+ri,m5w+ri,4.5+ri],
                            [-m5l-ri,m5w+ri,4.5+ri],
                            [-m5l-ri,-m5w-ri,4.5+ri],
                            [m5l+ri,-m5w-ri,4.5+ri]],
                        14.51,-tt/2,ri,fn=fn);
        for (pm1 = [-1,1]) for (pm2 = [-1,1]) translate([pm1*24.125,pm2*16.125])
            cylinder(d=4.75,h=100,center=true);
        translate([0,m5w+ri-.01,0])rotate([-90,0,0]) 
                        polyRoundExtrude([[-18,-13,tt/2],
                                          [-18,-3,tt/2],
                                          [0  ,-3,tt/2],
                                          [0  ,-13,tt/2]],
                                        tt+.02,-tt/2,-tt/2,fn=fn);
        translate([0,m5w+ri-.01,0])rotate([-90,0,0]) 
                        polyRoundExtrude([[21,-13,tt/2],
                                          [21,-3,tt/2],
                                          [8  ,-3,tt/2],
                                          [8  ,-13,tt/2]],
                                        tt+.02,-tt/2,-tt/2,fn=fn);
        translate([m5l+ri-.01,0,0])rotate([0,90,0]) 
                        polyRoundExtrude([[-3,-7,tt/2],
                                          [-3,7,tt/2],
                                          [-13,7,tt/2],
                                          [-13,-7,tt/2]],
                                        tt+.02,0,-tt/2,fn=fn);
        translate([0,0,-.01])rotate([0,0,0]) 
                        polyRoundExtrude([[20,-16,tt/2],
                                          [20,-9,tt/2],
                                          [-3,-9,tt/2],
                                          [-3,-16,tt/2]],
                                        tt+.02,-tt/2,-tt/2,fn=fn);
    }

}
module laserHousing(){
    s = 11/sqrt(2);
    translate([0,0,-0.5*sqrt(2)]){
        rotate([0,-90,0]) difference(){
            polyRoundExtrude([[s+tt,0,tt],
                                [0,s+tt,tt],
                                [-s-tt,0,tt],
                                [0,-s-tt,tt]],
                            30,tt/2,tt/2,fn=fn);
            translate([0,0,-.01])polyRoundExtrude([[s,0,3],
                              [0,s,3],
                              [-s,0,4.5],
                              [0,-s,3]],
                            30.02,-tt/2,-tt/2,fn=fn);
        }
        
                                    
        
        difference(convexity=10){
            rotate([90,0,0]) linear_extrude(height = 3,center=true,convexity=10){
            for (pm=[-1,1])translate([-15+9*pm,-6.5])difference(){
                scale([2,1.1])circle(3);
                offset(-1)scale([2,1.1])circle(3);
                translate([0,-20])square(40,center=true);
            }
            }
            translate([0,0,1.55])rotate([0,90,0])cylinder(r=5,h=100,center=true);
        }
    }
    rotate([0,-90,0])
           polyRoundExtrude([[baseline,s+tt/sqrt(2),tt/2],
                             [baseline,-s-tt/sqrt(2),tt/2],
                             [0,-s-tt/sqrt(2),tt],
                             [0,-7,tt/2],
                             [baseline+3,-7,tt/2],
                             [baseline+3,7,tt/2],
                             [0,7,tt/2],
                             [0,s+tt/sqrt(2),tt]],
                            65+tt/2,0,tt/2-.01,fn=fn);
    unionMirror([0,1,0]){
        barpp(tt/2,[-30+tt/2,s,-0.5*sqrt(2)],[-65-tt/2,16,4.5]);
        barpp(tt/2,[-30+tt/2,s,-0.5*sqrt(2)],[-65-tt/2,16,baseline+tt/2]);

    }
}

    
module laser(){
    rotate([0,-90,0])cylinder(r=5,h=30);
    translate([-32.5,0,-2.5])cube([5,3,5],center=true);
}
module barrel(t){
    hp=[[-tt/2,0,7.75-sqrt(0.5)],[-tt/2,7.75,-sqrt(0.5)],[-tt/2,0,-7.75-sqrt(0.5)],[-tt/2,-7.5,-sqrt(0.5)]];

    bp=[[  crossPitch,0,rb],
        [  crossPitch,sqrt(3)/2*rb,-rb/2],
        [  crossPitch,-sqrt(3)/2*rb,-rb/2],
        [2*crossPitch,0,-rb],
        [2*crossPitch,sqrt(3)/2*rb,rb/2],
        [2*crossPitch,-sqrt(3)/2*rb,rb/2]];
    barpp(tt/2,hp[0],bp[0]);
    barpp(tt/2,hp[0],bp[1]);
    barpp(tt/2,hp[1],bp[0]);
    barpp(tt/2,hp[1],bp[1]);
    barpp(tt/2,hp[2],bp[1]);
    barpp(tt/2,hp[2],bp[2]);
    barpp(tt/2,hp[3],bp[2]);
    barpp(tt/2,hp[0],bp[2]);
    barpp(tt/2,hp[3],bp[0]);
    barpp(tt/2,hp[2],bp[3]);
    barpp(tt/2,hp[1],bp[4]);
    barpp(tt/2,hp[3],bp[5]);
    

    rt = rb+tt;
    ri = rb+tt*(1-sqrt(3));
    rotate([0,90,0])rotate([0,0,60]){
        for(osn=[1:barrelLength/crossPitch-1]) {
            translate([0,0,crossPitch*(osn+0.5)])
                for (pm=[-1,1]) {
                    for (rang = [30*(1+pow(-1,osn)):120:359])   
                        rotate([0,atan((barrelOuter-t)/2/crossPitch),rang]) translate([0,pm*(barrelOuter-t)*sqrt(3)/4,0])
                            cylinder(r=t/2,h=sqrt(pow(crossPitch,2)+pow(barrelOuter/2,2)),center=true);
                        rotate([0,0,30*(pm*pow(-1,osn))]) translate([0,0,pm*crossPitch/2]){
                           difference(){
                               translate([0,0,-tt/2]) polyRoundExtrude([[0,rt,tt/2],[rt*sqrt(3)/2,-rt/2,tt/2],[-rt*sqrt(3)/2,-rt/2,tt/2]],tt,tt/2-.01,tt/2-.01,fn=fn,10);
                              translate([0,0,-tt/2-.005])polyRoundExtrude([[0,ri,tt/2],[ri*sqrt(3)/2,-ri/2,tt/2],[-ri*sqrt(3)/2,-ri/2,tt/2]],tt+.01,-tt/2,-tt/2,fn=fn,10);  
                           }
                    }
                }   
        }
        for (s=[0,1])
        translate([0,0,crossPitch*(1+s)])linear_extrude(height=barrelLength-crossPitch*(1+2*s)){
            for (rang=[60*s:120:359])
                rotate(rang)
                    translate([barrelOuter/2-t/2,0]) circle(r=t/2);
        }
    }
}


module foot(mx,my){
    nx = floor(mx/crossPitch);
    nParity = nx%2;
    
    difference(){
        translate([mx,0,baseline]) 
            polyRoundExtrude([  [3,my+3,4],
                                [3,-my-3,4],
                                [-3,-my-3,4],
                                [-3,my+3,4]],
                            2,tt/2,0,fn=fn,10);
        for (pm=[-1,1]) translate([mx,pm*my,baseline-1])cylinder(r=1.6,h=100);
    }
    
    np = [[(nx+  nParity)*crossPitch,0,-rb],
          [(nx+  nParity)*crossPitch,rb*sqrt(3)/2,rb/2],
          [(nx+  nParity)*crossPitch,-rb*sqrt(3)/2,rb/2],
          [(nx+1-nParity)*crossPitch,rb*sqrt(3)/2,-rb/2],
          [(nx+1-nParity)*crossPitch,-rb*sqrt(3)/2,-rb/2]];
    sp = [[mx-2+nParity*4, my-3,baseline+tt/2],
          [mx-2+nParity*4,-my+3,baseline+tt/2],
          [mx+2-nParity*4, my-3,baseline+tt/2],
          [mx+2-nParity*4,-my+3,baseline+tt/2]];
    barpp(tt/2,np[0],sp[0]);
    barpp(tt/2,np[0],sp[1]);
    barpp(tt/2,np[1],sp[0]);
    barpp(tt/2,np[2],sp[1]);
    barpp(tt/2,np[3],sp[2]);
    barpp(tt/2,np[4],sp[3]);
    barpp(tt/2,np[4],sp[2]);
    barpp(tt/2,np[3],sp[3]);
} 

module sightMount(barrelLength){
   cp = [   [-2*crossPitch,0,rb],
            [  -crossPitch, sqrt(3)/2*rb,rb/2],
            [  -crossPitch,-sqrt(3)/2*rb,rb/2],
            [            0,0,rb],
            [            0, sqrt(3)/2*rb,-rb/2],
            [            0,-sqrt(3)/2*rb,-rb/2]];
    

    pp = [[-pl-pfo, pw,ph],
          [-pl-pfo,-pw,ph],
          [   -pfo,-pw,ph],
          [   -pfo, pw,ph]];
    
    translate([barrelLength,0,0]) {
        union(){
            barpp(tt/2,cp[0],pp[0]);
            barpp(tt/2,cp[0],pp[1]);
            barpp(tt/2,cp[1],pp[1]);
            barpp(tt/2,cp[1],pp[0]);
            barpp(tt/2,cp[2],pp[1]);
            barpp(tt/2,cp[2],pp[0]);
            barpp(tt/2,cp[2],pp[2]);
            barpp(tt/2,cp[1],pp[3]);
            barpp(tt/2,cp[5],pp[2]);
            barpp(tt/2,cp[4],pp[3]);
        }
        translate([-pl-tt/2-pfo,0,ph]) rotate([90,0,90]) {
            polyRoundExtrude([  [pw+tt/2,tt/2,tt/2],
                                [notch,tt/2,tt/2],
                                [0,-notch+tt/2,tt/8],
                                [-notch,tt/2,tt/2],
                                [-pw-tt/2,tt/2,tt/2],
                                [-pw-tt/2,-tt/2,tt/2],
                                //[-notch-tt*sin(22.5),-tt/2,tt/2],
                                [0,-notch+tt/2-tt*sqrt(2),tt/2],
                                //[notch+tt*sin(22.5),-tt/2,tt/2],
                                [pw+tt/2,-tt/2,tt/2]
            ],
                            pl+tt,tt/2-.01,tt/2-.01,fn=fn);
            translate([0,0,pl+tt-tflex]){
                polyRoundExtrude(
                   [[ notch+tt,-tflex/2,tflex/2],
                    [ notch+tt,tflex/2,tflex/2],
                    [-notch-tt,tflex/2,tflex/2],
                    [-notch-tt,-tflex/2,tflex/2]],
                   tflex,tflex/2-0.01,tflex/2-0.01,fn=fn);
                sphere(r=tflex/2);
            }
            txo = tp/2;
            unionMirror([1,0,0]) {
                for(os = [tt,pl-3-tt]) translate([0,0,os+tt/2])
                     polyRoundExtrude([ [pw+tt/2,0,0],
                                        [pw+tt/2,tt/2+tp+1*tflex,tflex],
                                        [pw+tt/2-2*tp,tt/2+tp+1*tflex,tflex],
                                        [pw+tt/2-2*tp,tt/2+tp-0.5*tflex,tflex/2],
                                        [pw+tt/2-2*tp+tflex,tt/2+tp-0.5*tflex,tflex/2],
                                        [pw+tt/2-2*tp+tflex,tt/2+tp+0.0*tflex,tflex/2],
                                        [pw+tt/2-tflex,tt/2+tp,tflex/2],
                                        [pw+tt/2-tflex,0,0]],
                                        3,tflex/2-.01,tflex/2-.01,fn=fn);
                translate([pw+tt/2-tflex,0,0])
                    polyRoundExtrude([  [0,      -tflex/2, tflex/2],
                                        [tflex,  -tflex/2, tflex/2],
                                        [tflex,  tt/2+txo, tflex+txo-tflex*sin(22.5)],
                                        [tflex-tp,tt/2+txo+tp,tflex/2],
                                        [-2+tflex/sqrt(2)/2,     tt/2+txo+2-tflex/sqrt(2), tflex/2],
                                        [0,      tt/2+txo-tflex*sin(22.5), txo-tflex*sin(22.5)]],
                                     tt,0,tflex/2-.01,fn=fn);
            }
        }
    }      
}
module sight(h){
    riRing=1;
    tRing = 0.8;
    x = h-(ph+tt/2+tp/2);
    pe = pw+tt/2-tp;

    // mount plate
    difference(){
        translate([0,0,h-x])rotate([90,0,-90])
            polyRoundExtrude([[pe,tp/2,tp/4],
                              [pw+tt/2-2.5*tp,tp/2,tp/2],
                              [5,x,tp/2],
                              [-5,x,tp/2],
                              [-pw-tt/2+2.5*tp,tp/2,tp/2],
                              [-pe,tp/2,tp/4],
                              [-pe,-tp/2,tp/4],
                              [-notch,-tp/2,tp/4],
                              [0,-notch-tp/2,tp/2],
                              [notch,-tp/2,tp/4],
                              [pe,-tp/2,tp/4]],
                            pl,tp/2-.01,tp/2-.01,fn=fn);
        translate([0,0,h])rotate([0,90,0])cylinder(r=4.5,h=100,center=true);
        unionMirror([0,1,0])translate([-pl-tt/2,pw-tp*1,0])cube([tt,10,100]);
    }
    
    
    rotate([0,90,180]) translate([-h,0,pl/2]){
        rotate_extrude(){
                translate([4.5,0])
                    offset(r=0.5)square([0.01,pl],center=true);
        }
        difference(){
            for(pm=[-1,1]) rotate([0,90,pm*45])cylinder(r=0.3,h=9,center=true);
            cylinder(r=riRing+tRing/2,h=10,center=true);
        }
        rotate_extrude(){
            translate([riRing+tRing/2,0]) circle(r=tRing/2);
        }
    }          
}


module scis2d(b){
    c = sqrt(a*a+b*b);
    f = (2*ri+t)/c;
    translate([a/2-f*b/2+ri+t,0]){
        translate([0,0.5*b+0.5*f*a])rotate(atan(b/a))square([c,t],center=true);
        translate([0,1.5*b+1.5*f*a]) rotate(-atan(b/a))square([c,t],center=true);
        translate([-(a/2-f*b/2),0])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
        translate([a/2-f*b/2,b+f*a])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([-10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([-10.1,0])square(20,center=true);
        }
        translate([-(a/2-f*b/2),2*b+2*f*a])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
    }
}
module vert(skew){
    translate([0,0,yy/2+bt+3]){rotate([-90,0,0])translate([0,skew,0])difference(){
        linear_extrude(height=11,convexity=10,center=true){
            difference(){
                square([x,y],center=true);
                
            }
            for (a1=[0,180]) {
                for (a2=[0,180])
                    rotate([0,a1,a2])
                        translate([-x/2,y/2]) scis2d(a2/180*skew+2-skew/2);
                translate([0,-(yy/2+t+bt/2+skew)]) square([x,bt],center=true);
            }
        }
    rotate([0,90,0])cylinder(r=3,h=100,center=true,$fn=6);
    translate([-3*t,0,0])minkowski(){
            cube([x,y-6*t,y-6*t-2*g],center=true);
            sphere(r=t);
        }
    }

   // Inner Cage
    difference(){
        rotate([0,90,0])
            linear_extrude(height=x,center=true,convexity=10){
                difference(){
                    offset(r=t)square([yy+2*bt,y-2*t],center=true);
                    square([yy+2*bt,y-2*t],center=true);
                }        
            }
        rotate([90,0,0])
            linear_extrude(height=100,center=true,convexity=10){
                for (ang=[0,180])
                    rotate(ang){
                        offset(r=t)polygon(points=[[x/2-6*t,yy/2-2*t],[0,3*t],[-x/2+6*t,yy/2-2*t]]);
                        offset(r=t)polygon(points=[[x/2-4*t,yy/2-6*t],[3*t,0],[x/2-4*t,-yy/2+6*t]]);
                    }
                }
    }
}
}
module outerHousing(skew) {
    r = 2*t+g; 
    so = 1.5*t+g;
    si = g;
    h = yy/2+bt+t;
    dz = h+so+yy/2+bt; 
    dy = y/2+range+so-yy/2-r;
    my = y/2+range+so-dy*(1-(h+so)/dz)-1.125*t;
    f = 1+t/dz/2;
    translate([0,skew,yy/2+bt+2.99]) {
        difference(){
            translate([x2/2-0.74*t,0,0])rotate([0,-90,0])polyRoundExtrude([
                                               [h+so,y/2+range+so,r],
                                               [h+so,-y/2-range-so,r],
                                               [-yy/2-bt,-yy/2-r,0],
                                               [-yy/2-bt,-yy/2-r+1.5*t,0],
                                               [h+si+t/2,-y/2-range-si,r-1.5*t],
                                               [h+si+t/2,y/2+range+si,r-1.5*t],
                                               [-yy/2-bt,yy/2+r-1.5*t,0],
                                               [-yy/2-bt,yy/2+r,0]],
                                              x2-1.48*t,0*t,0*t,fn=fn  );
            *unionMirror([0,1,0])translate([t,my,0])rotate([atan(dz/dy),0,0]){
                triArray([-x2/2+t,-yy/2-bt],[x2/2-t,0],8);
            }
        }
        for (pm=[-1,1])
        translate([0.75*t+(x2/2-t*0.75)*pm,0,0])rotate([0,-90,0]) difference(){
            polyRoundExtrude([ [h+so,y/2+range+so,r],
                               [h+so,-y/2-range-so,r],
                               [h+so-f*dz,-(y/2+range+so-f*dy),t],
                               
                               [h+so-f*dz,(y/2+range+so-f*dy),t]],
                              1.5*t,0.5*t,0.5*t,fn=fn  );
            translate([0,0,-.01])polyRoundExtrude([ [h+si-r,y/2+range+si-r,r],
                               [h+si-r,-y/2-range-si+r,r],
                               [-8.5-3*pm,-yy/2+1.5*t-dy*((2*r+3*t)/dz),r],
                               
                               [-8.5-3*pm,yy/2-1.5*t+dy*((2*r+3*t)/dz),r]],
                              1.5*t+.02,-0.74*t,-0.74*t,fn=fn  );
        }
    }
}


module rearAdj(skew){
    rotate([0,0,180]){
        translate([0,-skew,0]){
            intersection(){
                difference(){
                    union() {
                        translate([0,0,-10.5])linear_extrude(height=14,convexity=10){
                            difference(){
                                square([x,y],center=true);
                                *square([7,2.75],center=true);
                            }
                            for (a1=[0,180])
                                for (a2=[0,180])
                                    rotate([0,a1,a2])
                                        translate([-x/2,y/2]) scis2d(-a2/180*skew+2+skew/2);
                            translate([0,skew])difference(){
                                offset(r=0.75*t)square([x+2.5*t+g,yy+3.5*t+g],center=true);
                                offset(r=g)square([x,yy],center=true);
                            }
                        }
                        vert(skew);
                        outerHousing(skew);
     
                    }
                    translate([0,skew,0]){
                        for (pm=[-1,1]){
                            *translate([pm*(x/2+g/2),0,yy/2+bt+3])rotate([0,pm*90,0])
                                linear_extrude(height=100) offset(r=1) square(2*(range+1-pm),center=true);
                            translate([pm*12,0,-7])rotate([90,0,0]) cylinder(r=1.75,h=100,center=true);
                        }    
                        translate([0,0,-23.5])cube([100,1.5*25.4,40],center=true);
                        translate([0,0,-23.25])cube([35.5,32,40],center=true);                        
                        translate([0,0,yy+2*bt+3*t+g])linear_extrude(height=100){
                            translate([0,range+1])circle(r=nr+1);
                            translate([0,-range-1])circle(r=nr+1);
                            square([2*nr+2,2*range+2],center=true);
                        }
                    }
                    // Horiz adjust screwhole
                    rotate([-90,0,0]) {
                        cylinder(r=1.75,h=100);
                        cylinder(r=nr,h=(y-2*t)/2,$fn=6);
                    }
                    // Vert adjust screwhole
                    translate([0,0,yy/2+bt+3-skew]){
                        rotate([0,0,30])cylinder(r=nr,$fn=6,h=y/2-t);
                        cylinder(r=1.75,h=100);
                    }
                    
                    translate([0,0,-10]){  
                        cube([x-4*t,y-5*t,28-2*t],center=true);
                        cube([8,y-5*t,28],center=true);
                    }
                }
                rotate([90,0,0]) linear_extrude(height=100,center=true)
                    translate([0,48.5])offset(r=9)square([24,100],center=true);   
            }
        }
    }
}