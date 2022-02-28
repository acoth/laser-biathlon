
$fa=1;
$fs=0.1;
difference(){
    linear_extrude(height=25,convexity=10){
    difference(){
        union(){
            offset(r=0.99)offset(r=-0.99)difference(){
                union(){
                    translate([0,-5])square([1.5*25.4+4,13],center=true);
                    circle(r=8);
                }
                translate([0,-11.5])square([1.5*25.4,20],center=true);
            }
            circle(r=6.35);
        }
        circle(r=5.1);
    }
}
translate([0,0,20])cylinder(r=6.36,h=100);
}
    