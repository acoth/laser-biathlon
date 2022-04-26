opticalParts=0;
include <common.scad>
include <upper.scad>
include <lower.scad>
difference() {
    union(){
        upper();
        translate([-backExt,0,hLower+tw])rearSight(range,-range);
        lower();
    }
*    translate([0,-500,0]) cube(1000,center=true);
*    translate([0,0,450]) cube(1000,center=true);
    translate([300,0,0]) cube(1000,center=true);
}