$fa=1;
$fs=0.1;

/*module trigger() {
    translate([-9,-20,0]){
        
    scale([1,1.2,1])rotate([0,0,-45])scale([1,1.5,2]){
        rotate_extrude(angle=90){
            translate([10,0]) circle(r=2);
         }
        translate([10,0,0])sphere(r=2);
        translate([0,10,0])scale([2.5,1,1])sphere(r=2);
        *translate([0,10,0])rotate([0,-90,-35])cylinder(r=2,h=5);
    }
    linear_extrude(height=8,center=true){
        difference(){ union(){translate([9,20]){
            difference(){
                union(){
                    circle(r=2.75);
                    translate([0,-2.75])square(5.5,center=true);
                }
                circle(r=1.6);
            }
        }
        
            polygon(points=[[6,-10],[22,-8],[22,0],[11,19],[8,16]]);}
            scale([1,1.2])rotate(-45)scale([1,1.5])circle(r=10);
        }
    }}
}*/

module trigger(){
translate([-30,0,0])
rotate([0,0,-22.5]){
    intersection(){
        union(){
        rotate_extrude(angle=45.1){
            translate([30,0]) {
                scale([1,2])circle(r=2.5);
                translate([0,-5])square([10,10]);
            }
        }
        translate([30,0,0]) scale([1,1,2]){
            sphere(r=2.5);
            rotate([0,90,22.5])cylinder(h=7,r=2.5);
        }
        
    }
            translate([30,0,0]) scale([1,1,2]) rotate([0,90,22.5])linear_extrude(height=100,center=true){
                circle(r=2.5);
                translate([-2.5,0])square([5,100]);
            }
        
    }

}
intersection(){
linear_extrude(height=10,center=true,convexity=10){difference(){union(){
    translate([-30,0]) rotate(22.5)polygon(points=[[30,0],[40,0],[39.8,13],[32.5,13],[30-2.5,0]]);
    translate([-1.25,25]) circle(r=3.77);
    }
    translate([-1.25,25])circle(r=1.7);
}
}
translate([-30,0,0])rotate([90,0,22.5]) linear_extrude(height=100,center=true){
    translate([30,0]){
    scale([1,2])circle(r=2.5);
    translate([0,-5])square([50,10]);}
}
}
}

ro = 5;
*linear_extrude(height=10,center=true){
    translate([7.5,5])square([2,31.01-ro]);
    translate([1.01-ro/2,35])square([17-ro,2],center=true);
    translate([9.5-ro,36-ro])intersection(){
        difference(){
            circle(r=ro);
            circle(r=ro-2);
        }
        square(100);
    }
}
//translate([5,0,0])cube([5,22.5,10],center=true);