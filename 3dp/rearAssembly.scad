$fs=.25;
$fa=2.5;
fn = 20;
include <Round-Anything/polyround.scad>

barrelLength=90;
barrelOuter = 12.5;
frontSightSep = 13.5;
supVspace = frontSightSep-barrelOuter*sqrt(3)/4+0.75;
crossPitch=barrelLength/(2*round((barrelLength/(barrelOuter*1.6)-1)/2)+1);
tt=1.5;
tp = 1;
tflex = 0.8;
baseline = -10;
rb = barrelOuter/2-tt/2;
pfo = -7;
pl = 19.5;
pw = 5.5;
notch = 2.5;
ph = rb+notch;




    use <rearAdj.scad>

*translate([-115,0,-6.5])    rearAdj(3);
*translate([-65,0,-9])m5ink();
*color("red")laser();
*laserHousing();
*barrel(tt);
*foot(45,rb+4);
sightMount(10);
translate([10-pfo,0,0])sight(13.5);
module unionMirror(mirNorm) {
    children();
    mirror(mirNorm) children();
}

module m5ink(){
linear_extrude(height=16){
    offset(r=3)offset(-3)square([56,40],center=true);
}
}
module laserHousing(){
    translate([0,0,-0.5*sqrt(2)]){
        rotate([0,-90,0]) linear_extrude(height = 30){
            rotate(45)
            difference(){
            offset(r=3)square(8,center=true);
            offset(r=3)square(5,center=true);
            }
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
}
    
module laser(){
    rotate([0,-90,0])cylinder(r=5,h=30);
    translate([-32.5,0,-2.5])cube([5,3,5],center=true);
}

module barpp(r,v1,v2){
    dx=v2.x-v1.x;
    dy=v2.y-v1.y;
    dz=v2.z-v1.z;
    length = sqrt(dx*dx+dy*dy+dz*dz);
    phi = acos(dz/length);
    theta = atan2(dy,dx);
    translate(v1)rotate([0,phi,theta]) cylinder(r=r,h=sqrt(dx*dx+dy*dy+dz*dz));    
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
        barpp(tt/2,cp[0],pp[0]);
        barpp(tt/2,cp[0],pp[1]);
        barpp(tt/2,cp[1],pp[1]);
        barpp(tt/2,cp[1],pp[0]);
        barpp(tt/2,cp[2],pp[1]);
        barpp(tt/2,cp[2],pp[0]);
        barpp(tt/2,cp[2],pp[2]);
        barpp(tt/2,cp[1],pp[3]);
        barpp(tt/2,cp[3],pp[2]);
        barpp(tt/2,cp[3],pp[3]);
        barpp(tt/2,cp[5],pp[2]);
        barpp(tt/2,cp[4],pp[3]);
        translate([-pl-tt/2-pfo,0,ph]) rotate([90,0,90]) {
            polyRoundExtrude([  [pw+tt/2,tt/2,tt/2],
                                [notch,tt/2,tt/2],
                                [0,-notch+tt/2,0],
                                [-notch,tt/2,tt/2],
                                [-pw-tt/2,tt/2,tt/2],
                                [-pw-tt/2,-tt/2,tt/2],
                                [-notch-tt/sqrt(8),-tt/2,tt/2],
                                [0,-notch-tt/2-tt/sqrt(8),tt/2+tt/sqrt(8)],
                                [notch+tt/sqrt(8),-tt/2,,tt/2],
                                [pw+tt/2,-tt/2,tt/2]],
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
