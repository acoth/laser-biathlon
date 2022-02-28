$fa=1;
$fs=0.1;
module bolt(){
    cylinder(r=.488*25.4/2,h=.159*25.4,$fn=6);
    cylinder(r=0.220*25.4/2,h=100);
}

difference(){
    union(){
        cube([15,13,12],center=true);
        translate([0,0,-4])linear_extrude(height=7,center=true){
    offset(r=3)offset(r=-3)square([15,30],center=true);
}
    }
    bolt();
    translate([0,0,-45])rotate([0,90,0])cylinder(r=40,h=100,center=true);
    linear_extrude(height=100){
    translate([10,0])square([20,0.22*25.4],center=true);
        }
            linear_extrude(height=.159*25.4){
    translate([10,0])square([20,0.488*25.4*sqrt(3)/2],center=true);
        }
}
