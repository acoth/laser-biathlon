include <common.scad>

module laserHousing(){
    s = 11/sqrt(2);
    translate([0,0,-0.5*sqrt(2)]){
        rotate([0,-90,0]) difference(){
            polyRoundExtrude([[s+tw,0,tw],
                                [0,s+tw,tw],
                                [-s-tw,0,tw],
                                [0,-s-tw,tw]],
                            30,tw/2,tw/2,fn=fn);
            translate([0,0,-.01])polyRoundExtrude([[s,0,3],
                              [0,s,3],
                              [-s,0,4.5],
                              [0,-s,3]],
                            30.02,-tw/2,-tw/2,fn=fn);
        }
        
                                    
        
        difference(convexity=10){
            rotate([90,0,0]) linear_extrude(height = 3,center=true,convexity=10){
            for (pm=[-1,1])translate([-15+9*pm,-6.5])difference(){
                scale([2,1.1])circle(3);
                offset(-1)scale([2,1.1])circle(3);
                translate([0,-20])square(40,center=true);
            }
            }
            translate([0,0,1.55])rotate([0,90,0])cylinder(r=5,h=100,center=true);
        }
    }    
}

module laserHousingHole(d,h){
    s = (d+1)/sqrt(2);
    difference() {
        rotate([0,-90,0]) 
            translate([0,0,-epsilon])union(){
                translate([-0.5*sqrt(2),0,0]) polyRoundExtrude([
                        [s,0,3],
                        [0,s,3],
                        [-s,0,4.5],
                        [0,-s,3]],
                    h+2*epsilon,-ri,0,fn=10);
                translate([0,0,h-epsilon]) polyRoundExtrude([
                        [-s,-s,s],
                        [-s,s,s],
                        [hUpper+epsilon,s,tw],
                        [hUpper+epsilon,hw,0],
                        [2*hUpper,0,0],
                        [hUpper+epsilon,-hw,0],
                        [hUpper+epsilon,-s,tw]],
                    sqrt(pow(h,2)+pow(d,2))+ri,ri,ri,fn=10);
            }
                        
                                    
        
        difference(convexity=10){
            rotate([90,0,0]) linear_extrude(height = 3,center=true,convexity=10){
            for (pm=[-1,1])translate([-15+9*pm,-6.5])difference(){
                scale([2,1.1])circle(3);
                offset(-1)scale([2,1.1])circle(3);
                translate([0,-20])square(40,center=true);
            }
            }
            translate([0,0,1.55])rotate([0,90,0])cylinder(r=5,h=100,center=true);
        }
    }    
}
    
module laser(){
    rotate([0,-90,0])cylinder(r=5,h=30);
    translate([-32.5,0,-2.5])cube([5,3,5],center=true);
}