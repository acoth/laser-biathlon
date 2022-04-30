include <common.scad>
include <upper.scad>

stopHeight=30;
stopWidth = hw-rLower;
stopRR = 7.5;
grommitT=3;
slotInT = cf-gap;
stopPoints = [[20,hLower-tw,stopRR+tw],
            [8,hLower-stopHeight,stopRR+tw],
            [-20,hLower-stopHeight,stopRR+tw],
            [-10,hLower-stopHeight/3,20],
            [-18,hLower-tw,stopRR+tw],
            [-18,hLower+rLower+10,0],
            [20,hLower+rLower+10,0]];

shh = [ [2,-34,tw/2],
        [-6,-34,tw/2],
        [-2,-25,25],
        [-7,-14,tw/2],
        [10.5,-14,tw/2]];

module stopBase(to) {
    rotate([90,0,0])translate([0,-gap,-stopWidth+to])
                        polyRoundExtrude(offsetRPoints(to,stopPoints),2*(stopWidth-to),stopRR-to,stopRR-to,fn=10);
}
nuth1 = hLower+tw+2*gap;
nuth2 = -rMinBarrel-tw;

module handStop(aLoc){
    translate([aLoc,0,-gap]){
        difference(){
            union(){
                difference(){                    
                    stopBase(0);
                    stopBase(tw);
                    translate([0,0,50+hLower])cube(100,center=true);
                    unionMirror([0,1,0])rotate([90,0,0])translate([0,-gap,-stopWidth-epsilon])
                    polyRoundExtrude(shh,tw+2*epsilon,-tw/2,-tw/2,fn=10);
                }
                minkowski(){
                    translate([-4,0,hLower-gap])mirror([0,0,1])cylinder(r=cf+tw/2,h=stopHeight+grommitT-tw/2);
                    sphere(r=tw/2);
                }
                intersection(){
                    stopBase(0);
                    translate([0,0,hLower-tw/2])cube([100,100,tw],center=true);
                }
                intersection(){
                    stopBase(0);
                translate([12,0,0])rotate([0,-90,0])polyRoundExtrude([
                        [hLower, slotInT,tw/2+gap],
                        [hLower+tw+gap, slotInT,tw/2],
                        [hLower+tw+gap,-slotInT,tw/2],
                        [hLower,-slotInT,tw/2+gap],
                        [hLower,-slotInT-tw-gap,0],
                        [hLower-tw-epsilon,-slotInT-tw,0],
                        [hLower-tw-epsilon,slotInT+tw,0],
                        [hLower,slotInT+tw+gap,0]],
                   32,tw/2,tw/2,fn=10);
                }
                translate([-9,0,0])rotate([0,-90,0])polyRoundExtrude([
                        [hLower,slotInT,tw/2],
                        [nuth1,slotInT,tw/2+gap],
                        [nuth1,nr-gap,tw/2],
                        [nuth2,nr-gap,tw/2],
                        [nuth2,-nr+gap,tw/2],
                        [nuth1,-nr+gap,tw/2],
                        [nuth1,-slotInT,tw/2+gap],
                        [hLower,-slotInT,tw/2]],
                    12,tw/2,tw/2,fn=10);
            }
            
            translate([-4,0,0])cylinder(r=cf,h=100,center=true);
            translate([-4,0,hLower+tw])cylinder(r=nr,h=100,$fn=6);
        }
        
                
    }
}
if (is_undef($in_assembly)){
difference(){
    union(){
        translate([0,0,gap])handStop(0);
        *upper();
    }
    translate([0,500,0])cube(1000,center=true);
}
}