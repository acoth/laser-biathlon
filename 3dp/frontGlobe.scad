$fs=0.1;
$fa=1;
sep = 25;
sang = 180-atan(3.5/sep);
difference(){
        linear_extrude(height=15,convexity=10){
        difference(){
            union(){
                circle(r=7.5);
                translate([0,-10]) square([3.5,7],center=true);
                translate([0,-13]) square([5,1.2],center=true);
            }
            circle(r=0.5*25.4/2);
            translate([0,-10]) square([1,10],center=true);
        }
        translate([0,sep])
    difference(){
        union(){
            circle(r=5);
            rotate(sang) square([1.2,sep-6]);
            mirror([1,0,0])rotate(sang) square([1.2,sep-6]);
        }
        circle(r=4);
    }
    }
    translate([0,-10.5,7.5])rotate([0,90,0])cylinder(r=1.75,h=20,center=true);
    translate([11.76,-10.5,7.5])rotate([0,90,0])cylinder(r=3,h=20,center=true);
    translate([-11.76,-10.5,7.5])rotate([0,90,0])cylinder(r=3,h=20,center=true);
}

translate([0,sep,0]) 
    difference(){ 
        linear_extrude(height=1.2,convexity=10){
            rotate(45)difference(){
                union(){
                    circle(r=2.2);
                    square([0.4,9],center=true);
                    square([9,0.4],center=true);
                }
                circle(r=1.8);
            }
        }
        *scale([2,1,1])cylinder(r1=4.5,r2=0,h=4);
    }
