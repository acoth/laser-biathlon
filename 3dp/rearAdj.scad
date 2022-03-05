$fs=0.25;
$fa=5;

a = 11.5;
b = 2;
c = sqrt(a*a+b*b);
x=35;
y=15;
t=1.2;
ri=0.6;
g=1;
bt=2;
range=3;
f = (2*ri+t)/c;
yy = y+4*b+3*f*a;

nr=3.1;
skew = 3;

module scis2d(b){
    c = sqrt(a*a+b*b);
    f = (2*ri+t)/c;
    translate([a/2-f*b/2+ri+t,0]){
        translate([0,0.5*b+0.5*f*a])rotate(atan(b/a))square([c,t],center=true);
        translate([0,1.5*b+1.5*f*a]) rotate(-atan(b/a))square([c,t],center=true);
        translate([-(a/2-f*b/2),0])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
        translate([a/2-f*b/2,b+f*a])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([-10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([-10.1,0])square(20,center=true);
        }
        translate([-(a/2-f*b/2),2*b+2*f*a])difference(){
            circle(r=ri+t);
            circle(r=ri);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
    }
}
module vert(){
    translate([0,0,yy/2+bt+3]){rotate([-90,0,0])translate([0,skew,0])difference(){
        linear_extrude(height=11,convexity=10,center=true){
            difference(){
                square([x,y],center=true);
                
            }
            for (a1=[0,180]) {
                for (a2=[0,180])
                    rotate([0,a1,a2])
                        translate([-x/2,y/2]) scis2d(a2/180*skew+2-skew/2);
                translate([0,-(yy/2+t+bt/2+skew)]) square([x,bt],center=true);
            }
        }
 

    rotate([0,90,0])cylinder(r=0.5,h=100,center=true);
    translate([-3*t,0,0])minkowski(){
        cube([x,y-6*t,y-6*t-2*g],center=true);
        sphere(r=t);
    }
   
    }

   // Inner Cage
    difference(){
        rotate([0,90,0])
            linear_extrude(height=x,center=true,convexity=10){
                difference(){
                    offset(r=t)square([yy+2*bt,y-2*t],center=true);
                    square([yy+2*bt,y-2*t],center=true);
                }        
            }
        rotate([90,0,0])
            linear_extrude(height=100,center=true,convexity=10){
                for (ang=[0,180])
                    rotate(ang){
                        offset(r=t)polygon(points=[[x/2-6*t,yy/2-2*t],[0,3*t],[-x/2+6*t,yy/2-2*t]]);
                        offset(r=t)polygon(points=[[x/2-4*t,yy/2-6*t],[3*t,0],[x/2-4*t,-yy/2+6*t]]);
                    }
                }
    }
}
}

module trap(r) {
    minkowski(){
        rotate([0,-90,0])linear_extrude(height = x,center=true){
                polygon(points=[[yy/2+bt+t,y/2+range],[yy/2+bt+t,-y/2-range],[-yy/2-bt,-yy/2],[-yy/2-bt,yy/2]]);
        }
    sphere(r=r);
    }
}
intersection(){
difference(){
    union() {
        translate([0,0,-10.5])linear_extrude(height=14,convexity=10){
            difference(){
                square([x,y],center=true);
                *square([7,2.75],center=true);
            }
            for (a1=[0,180])
                for (a2=[0,180])
                    rotate([0,a1,a2])
                        translate([-x/2,y/2]) scis2d(-a2/180*skew+2+skew/2);
            translate([0,skew])difference(){
                offset(r=4*t+g)square([x-4*t,yy],center=true);
                offset(r=g)square([x,yy],center=true);
            }
        }
        vert();
        translate([0,skew,yy/2+bt+3])
            difference(){
                trap(2*t+g);
                trap(g+t/2);
                translate([0,0,-yy/2-bt-25])cube(50,center=true);
            }
            
            
    }
    translate([0,skew,0]){
    for (pm=[-1,1]){
    translate([pm*(x/2+g/2),0,yy/2+bt+3])rotate([0,pm*90,0] )linear_extrude(height=100){
        offset(r=1)square(2*(range+1-pm),center=true);
    }
    translate([pm*12,0,-7])rotate([90,0,0]) cylinder(r=1.75,h=100,center=true);
    }    
    
    rotate([90,0,0]) cylinder(r=1.75,h=100,center=true);
    
    translate([0,0,-23.5])cube([100,1.5*25.4,40],center=true);
    translate([0,0,-23.25])cube([35.5,32,40],center=true);
    
    translate([0,0,yy+2*bt+3*t+g])linear_extrude(height=100){
        translate([0,range+1])circle(r=nr+1);
        translate([0,-range-1])circle(r=nr+1);
        square([2*nr+2,2*range+2],center=true);
    }
}
rotate([90,0,0]) cylinder(r=nr,h=y-2*t,$fn=6,center=true);
translate([0,0,-10]){rotate([0,0,30]){
        cylinder(r=nr,$fn=6,h=10+bt+yy/2+3+y/2-t);
        cylinder(r=nr+0.25,$fn=6,h=10+bt+yy/2+3);}
        cylinder(r=1.75,h=100);
        cube([x-4*t,y-5*t,28-2*t],center=true);
        cube([8,y-5*t,28],center=true);
    }
}
rotate([90,0,0])linear_extrude(height=100,center=true){
    translate([0,48.5])offset(r=9)square([24,100],center=true);
}
}