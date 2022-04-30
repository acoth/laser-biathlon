// Todo:
// wire holes
// Fix header to stick
// mounting to lower?

$submodule=1;


include <common.scad>
include <laserHousing.scad>
include <sightMount.scad>
include <rearSight.scad>


*upperAndRear();
module upperAndRear(){
    difference(){
        union(){
            upper();
            translate([-backExt,0,hLower+tw])rearSight(range,-range);
        }
        minkowski(){
            translate([-backExt+4.5-gap+epsilon,0,(hLower+hUpper)/2-tw]) cube([9-2*tw,20-2*tw,20-2*tw],center=true);
            sphere(r=tw);
        }
    }
    *if (!is_undef(opticalParts)) translate([supLength+barrelExt,0,0]) frontSight(14.75);
}

module upper(){
    mirror([0,0,1]) rotate([0,90,0]){
   translate([-rMinBarrel,0,-laserL-sqrt(pow(laserD,2)+pow(laserL,2))+ri+epsilon])       *rotate([-90,0,-90])stickShell(); 
        difference() {
        union(){
            //main body
            upperBody(0);
            //barrel extension
            polyRoundExtrude([
                    [(rMinBarrel+tw)*2,0,tw+ri],
                    [-rMinBarrel-tw+epsilon, (rMinBarrel+tw)*sqrt(3),tw+ri],
                    [-rMinBarrel-tw+epsilon,-(rMinBarrel+tw)*sqrt(3),tw+ri]],
                supLength+barrelExt,ri,0,fn=10);
            translate([notch+2*rMinBarrel,0,supLength+barrelExt])sightMount();
            
        }
        upperPoints = [[hUpper-tw,upperFlat+2*tw,tw*1.5],[hUpper-3*rMinBarrel-tw/2,(3*rMinBarrel)/sqrt(3)+tw*4/sqrt(3),ri]];
        upperAngle = -atan2(upperPoints[0].x-upperPoints[1].x,upperPoints[0].y-upperPoints[1].y);
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
            translate([0,0,supLength-aspect*rUpper])unionMirror([0,1,0])polyRoundExtrude([
                        [hUpper,tw*(2.5/sqrt(3)-1/sqrt(3)),tw],
                        [hUpper-3*rMinBarrel-tw/2,(3*rMinBarrel-tw/2)/sqrt(3)+tw*2.5/sqrt(3),ri],
                        [hUpper,upperFlat+tw*(1+tan(90+upperAngle)),2*tw],
                        [hUpper,upperFlat+5,0],
                        [hUpper*2,upperFlat+5,0],
                        [hUpper*2,-tw,0],
                        [hUpper,-tw,0]],
                    aspect*rUpper*2,0,tw+ri,fn=10);
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
                translate([0,0,-backExt+tw+8.5])polyRoundExtrude([
                        [hLower+rLower+tw,hw-tw,ri],
                        [hUpper-rUpper+2*tw,hw-tw,rUpper],
                        [hUpper-tw,upperFlat+2*tw,tw*1.5],
                        [hUpper-3*rMinBarrel-tw/2,(3*rMinBarrel)/sqrt(3)+tw*4/sqrt(3),ri]],
                    supLength+backExt+2*epsilon,0,0,fn=10);
                
            }
        }
        *translate([-rMinBarrel,0,-laserL-sqrt(pow(laserD,2)+pow(laserL,2))+ri+epsilon])       rotate([-90,0,-90])stickHole();
        rotate([0,-90,180])laserHousingHole(laserD,laserL);
        barrelTriPitch = 3*rMinBarrel+tw;
        topTriPitch = hw-rUpper+tw;
        midTriPitch = 8;
        upperTriPitch = 10;
        union(){for (angle=[0:120:359]) rotate([0,-90,angle])
            translate([0,-(1/(1+sqrt(3)))*barrelTriPitch,rMinBarrel+tw/2])
                triArray(rows=1,
                         cols=(supLength+barrelExt)/barrelTriPitch-2+(angle==0?1.5:0),                     pitch=barrelTriPitch,w=tw,h=tw,rr=ri,rh1=-ri,rh2=0);
        unionMirror([0,1,0])rotate([0,-90,0]){
            translate([0,tw,-hUpper+tw/2]) triArray(rows=1,cols=supLength/topTriPitch-1.5,
                     pitch=topTriPitch,w=tw,h=tw,rr=ri,rh1=0,rh2=-ri);
            translate([0,(3*rMinBarrel)/sqrt(3)+tw*(0.75+4/sqrt(3)),rMinBarrel+tw/2]) triArray(rows=1,cols=supLength/midTriPitch-0.5,
                     pitch=midTriPitch,w=tw,h=tw,rr=ri,rh1=0,rh2=0);
            translate([0,upperPoints[1].y,-upperPoints[1].x]) rotate([upperAngle,0,0]) translate([0,tw/2,-tw/2-epsilon])triArray(rows=1,cols=supLength/upperTriPitch-1,
                     pitch=upperTriPitch,w=tw,h=tw*1.15,rr=ri,rh1=0,rh2=0);
        }
    }
}
}
}
module stickHole(){ 
    polyRoundExtrude([
            [ stickWidth/2, 0, ri],
            [ stickWidth/2, stickLength, ri],
            [-stickWidth/2, stickLength, ri],
            [-stickWidth/2, 0, ri]],
        stickHeight,ri,ri,fn=10);
    polyRoundExtrude([
            [ 400*mil,stickLength-50*mil,0],
            [ 400*mil,stickLength+300*mil,0],
            [-400*mil,stickLength+300*mil,0],
            [-400*mil,stickLength-50*mil,0]],
        100*mil,0,0,fn=10);
    *mirror([0,0,1]) {
        translate([0,0,-100*mil]) polyRoundExtrude([
            [ 400*mil,stickLength-50*mil,0],
            [ 400*mil,stickLength+300*mil,0],
            [-400*mil,stickLength+300*mil,0],
            [-400*mil,stickLength-50*mil,0]],
        100,0,0,fn=10);       
    }
    unionMirror([1,0,0])translate([stickWidth/2-3.75,9.5,0])mirror([0,0,1]){
        translate([0,0,-epsilon])cylinder(r=1.4,h=40);
        translate([0,0,tw])cylinder(r=2.5,h=40);
    }
    translate([0,0,stickHeight-6]) polyRoundExtrude([
            [6,tw,0],
            [-6,tw,0],
            [-6,-20,0],
            [6,-20,0]],
        15,0,ri,fn=10);
     translate([0,0,hLower+rMinBarrel+tw]){polyRoundExtrude([
            [8.5,34,2],
            [-8.5,34,2],
            [-8.5,stickLength+7.8,0.5],
            [8.5,stickLength+7.8,0.5]],
        100,0,0,fn=10);
         translate([0,0,-tw-epsilon])polyRoundExtrude([
            [5.5,34,0],
            [-5.5,34,0],
            [-5.5,stickLength+7.8,0],
            [5.5,stickLength+7.8,0]],
        100,0,0,fn=10);}
    
}
module stickShell(){ 
    difference() {
        translate([0,0,-tw])polyRoundExtrude([
                [ stickWidth/2+tw, -tw, 0],
                [ stickWidth/2+tw, stickLength+tw, 0],
                [-stickWidth/2-tw, stickLength+tw, 0],
                [-stickWidth/2-tw, -tw, 0]],
            stickHeight,0,0,fn=10);
        stickHole();
    }
}
