opticalParts=0;
include <common.scad>
include <upper.scad>
include <lower.scad>
include <handStop.scad>
$in_assembly = 1;

// Todo:
// perforate butt
// hand stop
// check hardware sizings
// bolt?
// sling mounting?

difference() {
    union(){
        upperAndRear();
        lower();
        handStop(adjustMax-20);
    }
    mirror([0,0,1]) rotate([0,90,0])translate([-rMinBarrel,0,-laserL-sqrt(pow(laserD,2)+pow(laserL,2))+ri+epsilon])       rotate([-90,0,-90])stickHole();
*    translate([0,-500,0]) cube(1000,center=true);
*    translate([0,0,450]) cube(1000,center=true);
*    translate([300,0,0]) cube(1000,center=true);
}