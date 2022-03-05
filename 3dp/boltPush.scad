$fa=1;
$fs=0.1;
module bolt(){
    cylinder(r=.5*25.4/2,h=.18*25.4,$fn=6);
    cylinder(r=0.250*25.4/2,h=100);
}

rotate([0,-90,0])difference(){
    union(){
        translate([0,0,0.25])linear_extrude(height=12,center=true){
            offset(r=3)offset(r=-3)square([15,13.5],center=true);
        }
        
        intersection(){
            rotate([0,-90,0])linear_extrude(height=20,center=true){
                translate([-46,0]){
                    difference(){
                        circle(r=45);
                        circle(r=40);
                    }
                }
            }
            scale([1,2,1])
                cylinder(r=7.5,h=20,center=true);
        }
 
    }
    bolt();  
    linear_extrude(height=100){
    translate([10,0])square([20,0.25*25.4],center=true);
        }
            linear_extrude(height=.18*25.4){
    translate([10,0])square([20,0.488*25.4*sqrt(3)/2],center=true);
        }
}
