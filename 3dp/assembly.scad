opticalParts=0;
$in_assembly = 1;
include <common.scad>
include <upper.scad>
include <lower.scad>
include <handStop.scad>

// Todo:
// bolt
// sling mounting
// carry harness mounting
// cheek rest

difference() {
    union(){
        upperAndRear();
        lower(0);
        translate([0,0,0])handStop(adjustMax-20);
    }
    mirror([0,0,1]) rotate([0,90,0])translate([-rMinBarrel,0,-laserL-sqrt(pow(laserD,2)+pow(laserL,2))+ri+epsilon])       rotate([-90,0,-90])stickHole();
        translate([-backExt-rearSightDepth+52,0,-triggerDrop+9.5]) rotate([90,0,180])
        triggerSwitch();
*    translate([0,-500,0]) cube(1000,center=true);
*    translate([0,0,450]) cube(1000,center=true);
*    translate([300,0,0]) cube(1000,center=true);
}