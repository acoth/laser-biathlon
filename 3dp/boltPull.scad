$fa=1;
$fs=0.1;

linear_extrude(height=7){
    difference(){
        offset(r=1)offset(r=-1)union(){
            translate([0,0]){square([22,12],center=true);
            for (pm=[-1,1]) translate([11*pm,0])circle(r=6);}
            difference(){
                polygon(points=[[17,0],[17,-15],[10,-15],[-17,-4],[-17,0]]);
                translate([37,-7.5])circle(r=21.2);
            }
        }
        square([22,6],center=true);
        translate([11,0])circle(r=3);
    }
}