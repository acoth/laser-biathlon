include <common.scad>
include <shelify.scad>


bws = 24;
buttHeight = 110;
adjHeight = hLower-bottom-30-2*(tw+gap);
adjThick = 2*(sw1-tw-gap);
adjLength = triggerToButt-triggerX+bws/2+10;
chanW = 10;
chanT = adjThick/2-tw;
buttPoints = [
    [buttHeight/2,0,15],
    [buttHeight/2,-37,5],
    [buttHeight/2-15,-25,25],
    [0,-15,buttHeight*1.2+30],
    [-buttHeight/2+15,-25,25],
    [-buttHeight/2,-37,5],
    [-buttHeight/2,0,15]];

adjPoints = concat([ 
    [-adjHeight/2,0,5],
    [-adjHeight/2,adjLength,bws/2-epsilon],
    [adjHeight/2,adjLength,bws/2-epsilon],
    [adjHeight/2,0,5]],buttPoints);
    
chanPoints =   [[chanT/2,-chanW,chanT],
                [chanT/2,chanW,chanT],
                [adjLength,chanW,chanT],
                [adjLength,-chanW,chanT]];
 
module channel(to) {
     unionMirror([0,0,1])translate([0,0,-adjThick/2+to])rotate([0,0,90])
        polyRoundExtrude(offsetRPoints(-to,chanPoints) ,chanT+to,max(0,chanT/4-to),-chanT/2+to,fn=10);
}
 
module butt(ext){
    translate([-ext,0,0]) 
    rotate([90,90,0])
    difference(){
        union(){
            translate([0,0,-bws/2])
                polyRoundExtrude(buttPoints,bws,bws/3,bws/3, fn=10);
            translate([0,0,-adjThick/2])
                polyRoundExtrude(adjPoints,adjThick,adjThick/2,adjThick/2,fn=10);
        }
        translate([0,0,-bws/2+tw]) 
            polyRoundExtrude(offsetRPoints(tw,buttPoints),bws-2*tw,bws/3-tw,bws/3-tw, fn=10);
        
         difference(){translate([0,0,-adjThick/2+tw])
                polyRoundExtrude(offsetRPoints(tw,adjPoints),adjThick-2*tw,adjThick/2-tw,adjThick/2-tw,fn=10);
                channel(tw);
                
        }
        translate([0,adjLength,0])cube([100,bws,100],center=true);
        channel(-epsilon);
    }
}

if (is_undef($in_lower)) butt(0);
