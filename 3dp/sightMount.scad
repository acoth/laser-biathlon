include <common.scad>

rb = 15-tw/2;
pfo = 0;
pl = 19.5;
pw = 5.5;
notch = 2.5;
ph = 2*rMinBarrel+notch+tw*(0.5);
fn=10;


module sightMount(){    
    translate([0,0,-pl-tw]) {
        rotate([0,0,-90]) {
            difference(){polyRoundExtrude([  
                        [pw+tw/2,tw/2,tw/2],
                        [notch,tw/2,tw/2],
                        [0,-notch+tw/2,tw/8],
                        [-notch,tw/2,tw/2],
                        [-pw-tw/2,tw/2,tw/2],
                        [-(rMinBarrel+tw/2)*sqrt(3),-notch-rMinBarrel*3-tw,tw+ri],
                        [(rMinBarrel+tw/2)*sqrt(3),-notch-rMinBarrel*3-tw,tw+ri],
                        ],
                    pl+tw,tw/2-.01,tw/2-.01,fn=fn);
                unionMirror([1,0,0])translate([0,0,-epsilon]) polyRoundExtrude([
                        [pw-tw/2,-tw/2,ri],
                        [tw*1.2,-notch,ri],
                        [(rMinBarrel+tw/2)*sqrt(3)-tw,-notch-rMinBarrel*3+1.5*tw,ri]],
                pl+tw+2*epsilon,-ri,-ri,fn=fn);
            }
            translate([0,0,pl+tw-tf]){
                polyRoundExtrude(
                   [[ notch+tw,-tf/2,tf/2],
                    [ notch+tw,tf/2,tf/2],
                    [-notch-tw,tf/2,tf/2],
                    [-notch-tw,-tf/2,tf/2]],
                   tf,tf/2-0.01,tf/2-0.01,fn=fn);
                sphere(r=tf/2);
            }
            txo = tp/2;
            unionMirror([1,0,0]) {
                for(os = [tw,pl-3-tw]) translate([0,0,os+tw/2])
                     polyRoundExtrude([ [pw+tw/2,0,0],
                                        [pw+tw/2,tw/2+tp+1*tf,tf],
                                        [pw+tw/2-2*tp,tw/2+tp+1*tf,tf],
                                        [pw+tw/2-2*tp,tw/2+tp-0.5*tf,tf/2],
                                        [pw+tw/2-2*tp+tf,tw/2+tp-0.5*tf,tf/2],
                                        [pw+tw/2-2*tp+tf,tw/2+tp+0.0*tf,tf/2],
                                        [pw+tw/2-tf,tw/2+tp,tf/2],
                                        [pw+tw/2-tf,0,0]],
                                        3,tf/2-.01,tf/2-.01,fn=fn);
                translate([pw+tw/2-tf,0,0])
                    polyRoundExtrude([  [0,      -tf/2, tf/2],
                                        [tf,  -tf/2, tf/2],
                                        [tf,  tw/2+txo, tf+txo-tf*sin(22.5)],
                                        [tf-tp,tw/2+txo+tp,tf/2],
                                        [-2+tf/sqrt(2)/2,     tw/2+txo+2-tf/sqrt(2), tf/2],
                                        [0,      tw/2+txo-tf*sin(22.5), txo-tf*sin(22.5)]],
                                     tw,0,tf/2-.01,fn=fn);
            }
        }
    }      
}

module frontSight(h){
    riRing=1;
    tRing = 0.8;
    x = h-(ph+tw/2+tp/2);
    pe = pw+tw/2-tp;

    // mount plate
    difference(){
        translate([0,0,h-x-tp])rotate([90,0,-90])
            polyRoundExtrude([[pe,tp/2,tp/4],
                              [pw+tw/2-2.5*tp,tp/2,tp/2],
                              [5,x,tp/2],
                              [-5,x,tp/2],
                              [-pw-tw/2+2.5*tp,tp/2,tp/2],
                              [-pe,tp/2,tp/4],
                              [-pe,-tp/2,tp/4],
                              [-notch,-tp/2,tp/4],
                              [0,-notch-tp/2,tp/2],
                              [notch,-tp/2,tp/4],
                              [pe,-tp/2,tp/4]],
                            pl,tp/2-.01,tp/2-.01,fn=fn);
        translate([0,0,h])rotate([0,90,0])cylinder(r=4.5,h=100,center=true);
        unionMirror([0,1,0])translate([-pl-tw/2,pw-tp*1,0])cube([tw,10,100]);
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