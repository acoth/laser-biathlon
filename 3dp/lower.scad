include <common.scad>
include <shelify.scad>
include <tritesy.scad>

$fs=0.75;

triggerDrop = 35;
triggerTop = triggerDrop-25;
gripHeight = 70;
handHeight = 20;

sw1 = 8;
sw2 = 4;

bottom = hLower-triggerDrop-gripHeight;

module stockThinning(thin2) {
    rotate([90,0,0]) translate([0,0,-epsilon]) {
        multmatrix([
            [1, 0, -3, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0]])
        polyRoundExtrude([
                [-500,-500,0],
                [-500,500,0],
                [0,500,0],
                [10,hLower-triggerDrop+10,20],
                [-10,hLower-triggerDrop-10,20],
                [12-lw,bottom+5,30],
                [100,bottom,0]],
            thin2,1*(thin2/2-epsilon),1*(-thin2/2-epsilon),fn=10);
    }
   
}

    basePoints = [[200,hLower,2*tw],
                [100,hLower-20,35],
                [150,bottom+handHeight+25,10],
                [150,bottom+handHeight,10],
                [50,bottom+handHeight,10],
                [50,bottom+handHeight+25,10],
                [65,(hLower-triggerDrop+bottom+handHeight+20)/2,10],
                [50,hLower-triggerDrop+5,20],
                [30,hLower-triggerDrop+5,10],
                [25,(hLower-triggerDrop+bottom)/2,200],
                [12,bottom,10],
                [-15,bottom,30],
                [-35,bottom+20,30],
                [-130,bottom+20,10],
                [-130,hLower-10,10],
                [-lw-10,hLower-10,30],
                [-lw,hLower+lw/2,30],
                [200,hUpper+2*lw,2*tw]];
    triggerHolePoints = [[60,hLower-triggerDrop,12.5],
                                 [110,hLower-triggerDrop,12.5],
                                 [110,hLower-triggerTop,12.5],
                                 [60,hLower-triggerTop,12.5]];

module base(to) {
    rotate([90,0,0]) translate([-backExt-rearSightDepth,0,-lw+to])
            polyRoundExtrude( offsetRPoints(to,basePoints) ,2*(lw-to),lw-epsilon-to,lw-epsilon-to,fn=10);
}

module triggerHole(to) {
    rotate([90,0,0]) translate([-backExt-rearSightDepth,0,-lw-epsilon+to]) 
                polyRoundExtrude(offsetRPoints(to,triggerHolePoints),2*(lw+epsilon-to),-lw/2+to,-lw/2+to,fn=10);
}

module lower() {

    difference(){union() { difference(){
        union(){ 
            difference()   { base(0); base(tw);}
            intersection() { base(0);triggerHole(tw);}
        }
        triggerHole(0);
    }
        intersection(){base(0);unionMirror([0,1,0])translate([-backExt-rearSightDepth,lw-tw,0])stockThinning(lw-sw1);}
    }
    unionMirror([0,1,0])translate([-backExt-rearSightDepth,lw,0])stockThinning(lw-sw1);
        translate([0,0,500])cube(1000,center=true);
        translate([-backExt-rearSightDepth/2,0,tw])cube([rearSightDepth+2*epsilon,2*hw+tw,-2*hLower],center=true);
        rotate([0,90,0])upperBody();

        rotate([90,0,0]) translate([-backExt-rearSightDepth,0,-sw1+tw])
        polyRoundExtrude([
                [30-tw,hLower-triggerDrop+5-tw,10-tw],
                [12-tw,bottom+tw,10-tw],
                [-15+tw,bottom+tw,30-tw],
                [-35+tw,bottom+20+tw,30+tw],
                [-150,bottom+20+tw,10],
                [-150,hLower-10-tw,10],
                [30-tw,hLower-10-tw,30]],
            2*sw1-2*tw,sw1-tw-epsilon,sw1-tw-epsilon,fn=10);
        //translate([-670,0,0])cube(1000,center=true);
    }
      
}


if (is_undef($submodule)) lower();