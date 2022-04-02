include <common.scad>
include <laserHousing.scad>
include <sightMount.scad>
include <rearSight.scad>

$fa=2.5;
$fs=.25;

hw=18.5;
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

laserL = 30;
laserD = 10;

backExt = laserL+sqrt(pow(laserL,2)+pow(laserD,2))-ri+stickLength+2*tw;
supLength = 300-backExt;
sightXSep = 500;
barrelExt = sightXSep-supLength-backExt-yy;
adjustMin = 50;
adjustMax = supLength-rUpper-tw;

//hx = -hh+f*cf+tw+nh;


support2();
//translate([supLength+barrelExt,0,0]) sightMount();
translate([-backExt,0,hLower])sight(3,-3);

module support2(){
    mirror([0,0,1]) rotate([0,90,0]) difference() {
        union(){
            //main body
            translate([0,0,-backExt])polyRoundExtrude([
                    [hUpper,hw,rUpper],
                    [hUpper,-hw,rUpper],
                    [hLower,-hw,rLower],
                    [hLower,hw,rLower]],
                supLength+backExt,rUpper,0,fn=10);
            //barrel extension
            polyRoundExtrude([
                    [(rMinBarrel+tw)*2,0,tw+ri],
                    [-rMinBarrel-tw+epsilon, (rMinBarrel+tw)*sqrt(3),tw+ri],
                    [-rMinBarrel-tw+epsilon,-(rMinBarrel+tw)*sqrt(3),tw+ri]],
                supLength+barrelExt,ri,0,fn=10);
            translate([notch+2*rMinBarrel,0,supLength+barrelExt])sightMount();
        }
        translate([0,0,tw]){
        //nut slot
            polyRoundExtrude([
                    [-rMinBarrel-tw,    nr,ri],
                    [-rMinBarrel-tw,   -nr,ri],
                    [-rMinBarrel-tw-nh,-nr,ri],
                    [-rMinBarrel-tw-nh, nr,ri]],
                supLength+barrelExt+2*epsilon,0,ri,fn=10);
            //bolt slot
            translate([hLower+tw,0,0])rotate([0,-90,0]) polyRoundExtrude([
                    [adjustMin,cf,cf],
                    [adjustMax,cf,cf],
                    [adjustMax,-cf,cf],
                    [adjustMin,-cf,cf]],
                tw+2*epsilon,-tw/2,-tw/2,fn=10);
            //upper
                unionMirror([0,1,0])polyRoundExtrude([
                        [hUpper-tw,tw*2.5/sqrt(3),ri],
                        [hUpper-3*rMinBarrel-tw/2,(3*rMinBarrel-tw/2)/sqrt(3)+tw*2.5/sqrt(3),ri],
                        [hUpper-tw,upperFlat+tw,ri]],
                    supLength+2*epsilon,0,ri,fn=10);
        }
        //barrel hole
        translate([0,0,-epsilon]) {
            polyRoundExtrude([
                    [rMinBarrel*2,0,ri],
                    [-rMinBarrel, rMinBarrel*sqrt(3),ri],
                    [-rMinBarrel,-rMinBarrel*sqrt(3),ri]],
                supLength+barrelExt+2*epsilon,-ri,0,fn=10);
            // boreouts
            unionMirror([0,1,0]) {
                //lower
                translate([0,0,-backExt+tw])polyRoundExtrude([
                        [hLower+tw,nr+tw,ri],
                        [hLower+tw,hw-tw,rLower-tw],
                        [hLower+rLower,hw-tw,ri],
                        [-rMinBarrel-tw,nr+tw,ri]],
                    supLength+backExt+2*epsilon,0,ri,fn=10);
                //middle
                translate([0,0,-backExt+tw])polyRoundExtrude([
                        [hLower+rLower+tw,hw-tw,ri],
                        [hUpper-rUpper+2*tw,hw-tw,rUpper],
                        [hUpper-tw,upperFlat+2*tw,tw*1.5],
                        [hUpper-3*rMinBarrel-tw/2,(3*rMinBarrel)/sqrt(3)+tw*4/sqrt(3),ri]],
                    supLength+backExt+2*epsilon,0,ri,fn=10);
                
            }
        }
        translate([-rMinBarrel,0,-laserL-sqrt(pow(laserD,2)+pow(laserL,2))+ri+epsilon])       rotate([-90,0,-90])stickHole();
        rotate([0,-90,180])laserHousingHole(laserD,laserL);
    }
}
module stickHole(){ 
    polyRoundExtrude([
            [ stickWidth/2, 0, ri],
            [ stickWidth/2, stickLength, ri],
            [-stickWidth/2, stickLength, ri],
            [-stickWidth/2, 0, ri]],
        stickHeight,ri,ri,fn=10);
}
//stickHole();

/*module support(){
translate([-100,0,-hx*2/3])
difference(){
    rotate([90,0,90])difference(){
        union() {
            polyRoundExtrude([[hw,0,1.5*tw],
                              [hw,-hh,rh],
                              [-hw,-hh,rh],
                              [-hw,0,1.5*tw]
                            ],supLength,0,0,fn=10);
            translate([0,hx*2/3,supLength]) polyRoundExtrude([
                              [nr+tw*0.8,hx/3,tw],[-nr-tw*0.8,hx/3,tw],[0,-hx*2/3,tw]],200,0,0,fn=10);
            translate([0,0,supLength])scale([1,1,1.6])rotate([0,-90,180])
                intersection(){
                    rotate_extrude(angle=90)
                        polygon(polyRound([[0,hw,0],[hh,hw,rh],[hh,-hw,rh],[0,-hw,0]],fn=20));
                    rotate([-90,0,0])polyRoundExtrude([[-hw,hw,0],[hh,hw,rh],[hh,-hw,rh],[-hw,-hw,0]],hh,0,1.5*tw,fn=10);
                }
        }
        translate([0,0,-tw]){
            unionMirror([1,0,0]){
                polyRoundExtrude([[hw-tw,-tw,tw/2],
                          [hw-tw,-hh+tw,rh-tw],
                          [cf+tw,-hh+tw,cf-tw],
                          [cf+tw,-hh+f*cf,tw/2],
                          [nr+tw,-hh+f*cf,tw/2],
                          [nr+tw,hx,tw/2]
                         ],
                        5.5*hw+tw/2,tw/2,0,$fn=10);
                translate([0,0,5.5*hw+tw*1.5])polyRoundExtrude([[hw-tw,-tw,tw/2],
                          [hw-tw,-hh+tw,rh-tw],
                          [cf+tw,-hh+tw,cf-tw],
                          [cf+tw,-hh+f*cf,tw/2],
                          [nr+tw,-hh+f*cf,tw/2],
                          [nr+tw,hx,tw/2]
                         ],
                        supLength,0,tw/2,$fn=10);
                polyRoundExtrude([[hw-2*tw,-tw,tw/2],
                          [nr+tw/2,hx+tw/sqrt(2),tw/2],
                          [tw/2,-tw,tw/2]
                         ],
                        supLength+37,tw,tw,$fn=10);
            }
            polyRoundExtrude([[nr-tw/2,hx+tw/sqrt(2),tw/2],
                              [-nr+tw/2,hx+tw/sqrt(2),tw/2],
                              [0,-tw*sqrt(2),tw/2]
                         ],
                        supLength+300,tw,tw,$fn=10);
            
            polyRoundExtrude([[-nr,hx-epsilon,tw/2],
                              [nr,hx-epsilon,tw/2],
                              [nr,hx-nh,tw/2],
                              [-nr,hx-nh,tw/2]],
                supLength+100,tw,tw,$fn=10);
        }
        
        translate([0,hx-.01,cf+0])rotate([0,-90,90])
            polyRoundExtrude([[supLength-2*cf,cf,cf],
                          [0,cf,cf],
                          [0,-cf,cf],
                          [supLength-2*cf,-cf,cf]],
                        hh+hx,-cf,0,fn=10);
        
    }
    translate([0,-nr+tw,hx+tw/4])triArray(1,(supLength+200)/nr/2,2*nr,tw,tw,tw/2,0,0);
    unionMirror([0,1,0]){
        translate([0,tw,-tw/2])triArray(1,(supLength+1.6*hh)/hw,hw,tw,tw,tw/2,-tw/2,0);
        translate([0,hw-tw*0.75,-hw*sqrt(3)/2])rotate([90,0,0])triArray(1,supLength/hw+0.5,hw,tw,tw*1.5,tw/2,0,-tw/2);
        translate([0,0,-tw])rotate([atan2(hx+tw*(1+1/sqrt(2)),nr),0,0])translate([0,tw,0])triArray(1,(supLength+200)/-hx-.5,-hx,tw,tw*1.5,tw/2,0,0);
        translate([0,hw-2*tw,-1.5*tw])rotate([atan2(hx+tw*(1+1/sqrt(2)),nr+2.5*tw-hw),0,0])translate([0,tw,0])triArray(1,7,-hx,tw,tw*1.5,tw/2,0,0);
        translate([-7.5*hx,hw-2*tw,-1.5*tw])rotate([atan2(hx+tw*(1+1/sqrt(2)),nr+2.5*tw-hw),0,0])translate([0,tw,0])triArray(1,(supLength+1.6*hh)/-hx-8.5,-hx,tw,tw*1.5,tw/2,0,0);
    }
}
}*/