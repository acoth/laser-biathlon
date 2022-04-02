include <common.scad>

a = 11.5;
b = 2;
c = sqrt(a*a+b*b);
x=35;
y=15;
t=1.2;
rSpring=0.6;
f = (2*rSpring+t)/c;
yy = y+4*b+3*f*a;
m3nr=3;
springw = y-2*(t+gap);

module scis2d(b){
    c = sqrt(a*a+b*b);
    f = (2*rSpring+t)/c;
    translate([a/2-f*b/2+rSpring+t,0]){
        translate([0,0.5*b+0.5*f*a])rotate(atan(b/a))square([c,t],center=true);
        translate([0,1.5*b+1.5*f*a]) rotate(-atan(b/a))square([c,t],center=true);
        translate([-(a/2-f*b/2),0])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
        translate([a/2-f*b/2,b+f*a])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([-10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([-10.1,0])square(20,center=true);
        }
        translate([-(a/2-f*b/2),2*b+2*f*a])difference(){
            circle(r=rSpring+t);
            circle(r=rSpring);
            rotate( atan(b/a))translate([10.1,0])square(20,center=true);
            rotate(-atan(b/a))translate([10.1,0])square(20,center=true);
        }
    }
}
module vert(skew){
    translate([0,0,yy/2+t+springw/2]) difference() {
        union() {
            rotate([-90,0,0]) translate([0,-skew,0]) difference(){
                    linear_extrude(height=springw,convexity=10,center=true){
                        square([x,y],center=true);
                        for (pm=[-1,1]) rotate(90+90*pm) 
                            unionMirror([1,0])translate([-x/2,y/2]) scis2d(2-skew/2*pm);   
                    }
                rotate([0,90,0])rotate([0,0,30])cylinder(r=3,h=100,center=true,$fn=6);
                translate([3*t,0,0])minkowski(){
                        cube([x,y-6*t,y-6*t-2*gap],center=true);
                        sphere(r=t);
                    }
            }
    
            // Inner Cage
            difference(){
                rotate([0,90,0]) linear_extrude(height=x,center=true,convexity=10){
                    difference(){
                        offset(r=t)square([yy+3*t,y-2*t],center=true);
                        square([yy+2*t,y-2*t],center=true);
                    }        
                }
                rotate([90,0,0]) linear_extrude(height=100,center=true,convexity=10) {
                    for (ang=[0,180]) rotate(ang) offset(r=t){
                            polygon([[x/2-6*t,yy/2-2*t],[0,3*t],[-x/2+6*t,yy/2-2*t]]);
                            polygon([[x/2-4*t,yy/2-6*t],[3*t,0],[x/2-4*t,-yy/2+6*t]]);
                    }
                }
            }
        }
        // Vert adjust screwhole
        translate([0,0,skew]){
            rotate([0,0,30])cylinder(r=m3nr,$fn=6,h=y/2-t);
            cylinder(r=1.75,h=100);
        }
    }
}
module horiz(skew) {
    translate([0,skew,0]) difference(){
        linear_extrude(height=springw,center=true,convexity=10){
            difference() {
                square([x,y],center=true);
                offset(r=t)square([x-4*t,y-7*t],center=true);
            }
            for (pm=[-1,1]) rotate(90+90*pm) 
                unionMirror([1,0])translate([-x/2,y/2]) scis2d(2+skew/2*pm); 
            translate([0,-skew]) difference(){
                    offset(r=t)square([x+2.5*t+gap,yy+4*t],center=true);
                    offset(r=gap)square([x,yy+2*(t-gap)],center=true);
                }
            }

        // Horiz adjust screwhole
        rotate([90,0,0]) {
            cylinder(r=1.75,h=100);
            cylinder(r=m3nr,h=(y-2*t)/2,$fn=6);
        }
        translate([0,-skew,-springw+gap]) cube([x+epsilon,yy+2*t-epsilon,springw],center=true);
    }       
}
module sight(skewy,skewz){
    translate([-yy/2-3*t,0,springw/2]){
        horiz(skewy);
        translate([0,skewy,0]) vert(skewz);
    }
}

module outerHousing(skew) {
    r = 2*t+gap; 
    so = 1.5*t+gap;
    si = gap;
    h = yy/2+bt+t;
    dz = h+so+yy/2+bt; 
    dy = y/2+range+so-yy/2-r;
    my = y/2+range+so-dy*(1-(h+so)/dz)-1.125*t;
    f = 1+t/dz/2;
    translate([0,skew,yy/2+bt+2.99]) {
        difference(){
            translate([x2/2-0.74*t,0,0])rotate([0,-90,0])polyRoundExtrude([
                                               [h+so,y/2+range+so,r],
                                               [h+so,-y/2-range-so,r],
                                               [-yy/2-bt,-yy/2-r,0],
                                               [-yy/2-bt,-yy/2-r+1.5*t,0],
                                               [h+si+t/2,-y/2-range-si,r-1.5*t],
                                               [h+si+t/2,y/2+range+si,r-1.5*t],
                                               [-yy/2-bt,yy/2+r-1.5*t,0],
                                               [-yy/2-bt,yy/2+r,0]],
                                              x2-1.48*t,0*t,0*t,fn=fn  );
        }
        for (pm=[-1,1])
        translate([0.75*t+(x2/2-t*0.75)*pm,0,0])rotate([0,-90,0]) difference(){
            polyRoundExtrude([
                    [h+so,y/2+range+so,r],
                    [h+so,-y/2-range-so,r],
                    [h+so-f*dz,-(y/2+range+so-f*dy),t],                   
                    [h+so-f*dz,(y/2+range+so-f*dy),t]],
                1.5*t,0.5*t,0.5*t,fn=fn  );
            translate([0,0,-epsilon]) polyRoundExtrude([ 
                    [h+si-r,y/2+range+si-r,r],
                    [h+si-r,-y/2-range-si+r,r],
                    [-8.5-3*pm,-yy/2+1.5*t-dy*((2*r+3*t)/dz),r],
                    [-8.5-3*pm,yy/2-1.5*t+dy*((2*r+3*t)/dz),r]],
                1.5*t+2*epsilon,-0.74*t,-0.74*t,fn=fn  );
        }
    }
}


module rearAdj(skew){
    rotate([0,0,180]) translate([0,-skew,0]){   
        difference(){
            union() {
                translate([0,0,0])linear_extrude(height=springw,center=true,convexity=10){
                    square([x,y],center=true);
                    for (pm=[-1,1]) rotate(90+90*pm) 
                unionMirror([1,0])translate([-x/2,y/2]) scis2d(2-skew/2*pm); 
                    translate([0,skew])difference(){
                        offset(r=0.75*t)square([x+2.5*t+g,yy+3.5*t+g],center=true);
                        offset(r=g)square([x,yy],center=true);
                    }
                }
                vert(skew);
                *outerHousing(skew);
            }

            // Horiz adjust screwhole
            rotate([-90,0,0]) {
                cylinder(r=1.75,h=100);
                cylinder(r=m3nr,h=(y-2*t)/2,$fn=6);
            }
            
            
            translate([0,0,-10]){  
                cube([x-4*t,y-5*t,28-2*t],center=true);
                cube([8,y-5*t,28],center=true);
            }
        }
    }
}