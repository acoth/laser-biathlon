include <common.scad>
//include <shelify.scad>


bws = 24;
buttHeight = 110;
adjHeight = hLower-bottom-30-2*(tw+gap);
adjThick = 2*(sw1-tw-gap);
adjLength = triggerToButt-triggerX+bws/2+10;
chanW = 10;
chanT = adjThick/2-tw/2;
buttPoints = [
    [buttHeight/2,0,15],
    [buttHeight/2,-37,5],
    [buttHeight/2-15,-25,25],
    [0,-15,buttHeight*1.2+30],
    [-buttHeight/2+15,-25,25],
    [-buttHeight/2,-37,5],
    [-buttHeight/2,0,15]];

adjPoints = concat([ 
    [-adjHeight/2+gap,0,5],
    [-adjHeight/2+gap,50+gap,gap],
    [-adjHeight/2,50+2*gap,gap],
    [-adjHeight/2,adjLength-2,bws/2-epsilon],
    [adjHeight/2,adjLength-2,bws/2-epsilon],
    [adjHeight/2,50+2*gap,gap],
    [adjHeight/2-gap,50+gap,gap],
    [adjHeight/2-gap,0,5]],buttPoints);
    
function chanPoints(length) =   [[chanT/2,-chanW,chanT],
                [chanT/2,chanW,chanT],
                [length,chanW,chanT],
                [length,-chanW,chanT]];
 
module channel(to,length) {
     unionMirror([0,0,1])translate([0,0,-adjThick/2+to])rotate([0,0,90])
        polyRoundExtrude(offsetRPoints(-to,chanPoints(length)) ,chanT,max(0,chanT/2+to),max(-chanT/2+to,-chanT),fn=10);
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
        difference(){
        translate([0,0,-bws/2+tw]) 
            polyRoundExtrude(offsetRPoints(tw,buttPoints),bws-2*tw,bws/3-tw,bws/3-tw, fn=10);
            cube([2*(chanW+tw),120,chanT],center=true);
        }
         difference(){translate([0,0,-adjThick/2+tw])
                polyRoundExtrude(offsetRPoints(tw,adjPoints),adjThick-2*tw,adjThick/2-tw,adjThick/2-tw,fn=10);
                translate([0,20,0])channel(tw,adjLength);
                cube([2*(chanW+tw),1000,chanT/2+tw*1.5],center=true);
                
        }
        //translate([0,adjLength,0])cube([100,bws,100],center=true);
        channel(-epsilon,adjLength);
        for (hn = [0:10])
        translate([0,15+4*cf*hn,0])cylinder(r=3,h=100,center=true);
        unionMirror([1,0,0])translate([-chanW-chanT/2-tw,-2,0])rotate([0,0,90])triArray(1,8,20-tw,1.5*tw,adjThick,tw*0.75,-tw*0.75,-tw*0.75);
    }
}
module buttHole(to,length){
    translate([to,0,0])difference(){
        rotate([0,90,0]) polyRoundExtrude([
                [ adjHeight/2+gap+to, adjThick/2+gap+to,adjThick/2+gap+to],
                [ adjHeight/2+gap+to,-adjThick/2-gap-to,adjThick/2+gap+to],
                [-adjHeight/2-gap-to,-adjThick/2-gap-to,adjThick/2+gap+to],
                [-adjHeight/2-gap-to, adjThick/2+gap+to,adjThick/2+gap]],
            length-bws/2+gap,gap+to,0,fn=10);
        translate([-chanT-tw,0,0])rotate([90,90,0]) channel(-gap-epsilon-to,length+tw);
    }
}

if (is_undef($in_lower)) {
    butt(0);
*    difference(){
        buttHole(tw,adjLength);
        buttHole(0,adjLength);
    }
}