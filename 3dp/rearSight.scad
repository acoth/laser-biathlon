// Todo: 
// More Skeletonization?

include <common.scad>



springw = y-2*(t+gap);
range = 3;
tPlate = 1;
rApertureFit = 3;
rAperture = 0.25;
plateHeight = rAperture+2*range+tPlate/2+1;
plateWidth = (y+gap)/2;
knobR = m3nr+0.6;
nStops = 4;
rStop = 0.5;
rbot = 2;

module clickStops() {
    for (angle = [0:360/nStops:359]) rotate([0,0,angle])
        translate([knobR/2,0,0]) {
            rotate([0,90,0])cylinder(r=rStop,h=knobR/2,$fs=0.1);
            sphere(r=rStop,$fs=0.1);
            translate([knobR/2,0,0])sphere(r=rStop,$fs=0.1);
        }
}

module scis2d(b){
    c = sqrt(a*a+b*b);
    f = (2*rSpring+t)/c;
    translate([a/2-f*b/2+rSpring+t,0]){
        translate([0,0.5*b+0.5*f*a])rotate(atan(b/a))square([c,t],center=true);
        translate([0,1.5*b+1.5*f*a]) rotate(-atan(b/a))square([c,t],center=true);
        translate([-(a/2-f*b/2),0])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
        translate([a/2-f*b/2,b+f*a])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([-10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([-10.1,0])square(20,center=true);
        }
        translate([-(a/2-f*b/2),2*b+2*f*a])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
    }
}

module aperturePlate(){
    rotate([0,90,0]) difference() {

            unionMirror([0,1,0]){ unionMirror([1,0,0]) polyRoundExtrude([
                    [ plateHeight, plateWidth,t/2],
                    [ plateHeight, y/2-t-gap,t/2],
                    [ y/2-2*t, y/2-t-gap,0],
                    [ y/2-2*t, -t, 0],
                    [ -t ,-t ,0],
                    [ -t,plateWidth,0]],
                tPlate,tPlate/2-epsilon,tPlate/2-epsilon,fn=5*quality);
            polyRoundExtrude([
                    [rApertureFit*sqrt(3)/2,rApertureFit/2,t/2],
                    [0,rApertureFit,t/2],
                    [-rApertureFit*sqrt(3)/2,rApertureFit/2,t/2],
                    [-rApertureFit*sqrt(3)/2,-t/2,0],
                    [rApertureFit*sqrt(3)/2,-t/2,0]],
                2*tPlate+t,tPlate/2,0,fn=5*quality);
        }
        rotate_extrude() {
            translate([0,tPlate/2-epsilon])difference(){
                union(){
                    translate([(rAperture+tPlate/2)/2,0])
                        square([rAperture+tPlate/2,10],center=true);
                    translate([0,tPlate])
                        square([rAperture+tPlate,10]);
                    translate([rAperture+tPlate/2,tPlate])    circle(r=tPlate/2);
                    translate([0,tPlate+t])
                        square([rAperture+1.5*tPlate,10]);
                    
                }
                translate([rAperture+tPlate/2,0])circle(r=tPlate/2);
                translate([rAperture+1.5*tPlate,1*tPlate+t])circle(r=tPlate/2);
            }
        }
    }
}

module vert(skew){
    rTri = (y-7*t)*2/3;
    translate([0,0,yy/2+t+springw/2]) difference() {
        union() {
            rotate([-90,0,0]) translate([0,-skew,0]) difference(){
                    linear_extrude(height=springw,convexity=10,center=true){
                        difference(){
                            square([x,y],center=true);
                            translate([0,rTri/4])rotate(30)offset(r=t)circle(r=rTri,$fn=3);
                            unionMirror([1,0])translate([(rTri+2.5*t)*2/sqrt(3),-rTri/4])rotate(-30)offset(r=t)circle(r=rTri,$fn=3);
                            translate([-x/2,0])offset(r=tPlate/2)square([tPlate,y-4*t-tPlate],center=true);
                        }
                        for (pm=[-1,1]) rotate(90+90*pm) 
                            unionMirror([1,0])translate([-x/2,y/2]) scis2d(2-skew/2*pm);   
                    }
                rotate([0,90,0])cylinder(r=rApertureFit,h=100,center=true,$fn=6);
                translate([3*t,0,0])minkowski(){
                        cube([x,y-6*t,y-6*t-2*gap],center=true);
                        sphere(r=t);
                    }
            }
    
            // Inner Cage
            difference(){
                rotate([0,90,0]) linear_extrude(height=x,center=true,convexity=10){
                    difference(){
                        offset(r=t)square([yy+3*t,y-2*t],center=true);
                        square([yy+2*t,y-2*t],center=true);
                    }        
                }
                rotate([90,0,0]) linear_extrude(height=100,center=true,convexity=10) {
                    for (ang=[0,180]) rotate(ang) offset(r=t){
                            polygon([[x/2-6*t,yy/2-2*t],[0,3*t],[-x/2+6*t,yy/2-2*t]]);
                            polygon([[x/2-4*t,yy/2-6*t],[3*t,0],[x/2-4*t,-yy/2+6*t]]);
                    }
                }
                translate([-x/2,0,0]) minkowski() {
                    cube([2*tp+0*gap,x,x-6*t-gap],center=true);
                    sphere(r=gap/2);
                }
            }
            translate([0,0,skew+y/2-epsilon]) rotate([0,0,30]) cylinder(r1 = m3nr+2*t,r2=m3nr+t,h=t,$fn=6);
        }
        // Vert adjust screwhole
        translate([0,0,skew]){
            rotate([0,0,30])cylinder(r=m3nr,$fn=6,h=y/2-epsilon+0.3);
            cylinder(r=1.75,h=100);
        }
        translate([0,0,yy/2+2.5*t])clickStops();
        
    }
}
module horiz(skew) {
    translate([0,skew,0]) difference(){
        linear_extrude(height=springw,center=true,convexity=10){
            difference() {
                square([x,y],center=true);
                translate([2*t,0])offset(r=t)square([x,y-7*t],center=true);
            }
            for (pm=[-1,1]) rotate(90+90*pm) 
                unionMirror([1,0])translate([-x/2,y/2]) scis2d(2+skew/2*pm); 
            translate([0,-skew]) difference(){
                    offset(r=t)square([x+2.5*t+gap,2*(hw-t)],center=true);
                    offset(r=gap)square([x,yy+2*(t-gap)],center=true);
                }
            }

        // Horiz adjust screwhole
        rotate([90,0,0]) {
            cylinder(r=1.75,h=100);
            cylinder(r=m3nr,h=(y-2*t)/2,$fn=6);
            translate([0,0,skew+hw])clickStops();
        }
        translate([0,-skew,-springw+gap]) cube([x+epsilon,yy+2*t-epsilon,springw],center=true);
    }       
}
module outerHousing() {
    edgePoints = [
            [-springw/2-rbot,hw,rbot],
            [-springw/2+hUpper-hLower-5,hw,rUpper],
            [-springw/2+hUpper-hLower-tw,y/2+range+gap+t,gap],
            [springw/2+x-t/2+gap+t,y/2+range+gap+t,t+gap],
            [springw/2+x-t/2+gap+t,-t,0],
            [springw/2+x-t/2+gap,-t,0],
            [springw/2+x-t/2+gap,y/2+range+gap,gap],
            [-springw/2+hUpper-hLower-t-tw,y/2+range+gap,gap+t],
            [-springw/2+hUpper-hLower-5,yy/2+t,rUpper-t],
            [-springw/2-rbot+t,yy/2+t,rbot-t],
            [-springw/2-rbot+t,11,0],
            [-springw/2-rbot,11,0]];
    endPoints = [ edgePoints[0], edgePoints[1],
                  edgePoints[2],edgePoints[3],
                  edgePoints[4],[edgePoints[0].x,edgePoints[4].y,0]];
    
    inBot = yy/2+t+springw/2-plateHeight-gap/2;
    inTop = inBot+2*plateHeight+gap;
    outBot = yy/2+t+springw/2-range-1;
    outTop = outBot+2*range+2;
    difference() {
        rotate([0,-90,0]) unionMirror([0,1,0]) {
            translate([0,0,-x/2-2*gap])  polyRoundExtrude(
                edgePoints, x+4*gap,0,0,fn=5*quality);
            difference() {
                unionMirror([0,0,1])translate([0,0,-x/2-t-2*gap]) 
                    polyRoundExtrude(endPoints,t+epsilon,0,t,fn=5*quality);
                translate([0,0,-x/2-t-2*gap-epsilon])polyRoundExtrude([
                        [outBot,range+1,t],
                        [outBot,-2*t,t],
                        [outTop,-2*t,t],
                        [outTop,range+1,t]],
                    t+3*epsilon,-t/2,-t/2,fn=5*quality);
             translate([0,0,x/2+2*gap-2*epsilon])polyRoundExtrude([
                        [inBot,plateWidth+gap/2,t],
                        [inBot,-2*t,t],
                        [inTop,-2*t,t],
                        [inTop,plateWidth+gap/2,t]],
                    t+3*epsilon,-t/2,-t/2,fn=5*quality);   
            } 
        }
        translate([0,0,springw/2+x+gap-t/2-epsilon])polyRoundExtrude([
                [  knobR+gap , (knobR+gap+range),knobR+gap],
                [  knobR+gap ,-(knobR+gap+range),knobR+gap],
                [-(knobR+gap),-(knobR+gap+range),knobR+gap],
                [-(knobR+gap),knobR+gap+range,knobR+gap]],
            t+2*epsilon,-t/2,-t/2,fn=5*quality);
        
        unionMirror([0,1,0])
            translate([-x/2,-(y/2+range+gap+t/2),-springw/2+hUpper-hLower])
                rotate([90,0,0])
                    triArray(rows=3,cols=3.5,pitch=x/4,w=t,h=t, rr=t/2,rh1=0,rh2=0);
        unionMirror([1,0,0])rotate([0,0,90])
            translate([-1.5*x/5,x/5,springw/2+x+gap])
                triArray(rows=2,cols=2.5,pitch=x/5,w=t,h=t,rr=t/2,rh1=0,rh2=0);
        rotate([90,0,0])cylinder(r=knobR+gap,h=100);
        
    }
}
module rearSight(skewy,skewz){
    translate([-yy/2-3*t,0,springw/2])difference(){
        
            union(){
                horiz(skewy);
                translate([0,skewy,0]) {
                    vert(skewz);
                    *if (!is_undef(opticalParts)) translate([-x/2,0,skewz+yy/2+t+springw/2])aperturePlate();
                }
                outerHousing();
            }
            translate([-x/2-gap/2,0,-lw+tw+3])rotate([0,-90,0])intersection(){
                cylinder(r=lw-tw,h=100);
                cube([200,22,200],center=true);
            }
        }
}

if (is_undef($submodule))
    rearSight(range,-range);