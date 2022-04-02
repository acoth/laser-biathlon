include <common.scad>
tp = 1;
rb = 15-tw/2;
pfo = 0;
pl = 19.5;
pw = 5.5;
notch = 2.5;
ph = 2*rMinBarrel+notch+tw*(0.5);
fn=10;


module sightMount(){
 /*  cp = [   [-2*crossPitch,0,rb],
            [  -crossPitch, sqrt(3)/2*rb,rb/2],
            [  -crossPitch,-sqrt(3)/2*rb,rb/2],
            [            0,0,rb],
            [            0, sqrt(3)/2*rb,-rb/2],
            [            0,-sqrt(3)/2*rb,-rb/2]];
    

    pp = [[-pl-pfo, pw,ph],
          [-pl-pfo,-pw,ph],
          [   -pfo,-pw,ph],
          [   -pfo, pw,ph]];*/
    
    translate([0,0,-pl-tw]) {
        /*union(){
            barpp(tw/2,cp[0],pp[0]);
            barpp(tw/2,cp[0],pp[1]);
            barpp(tw/2,cp[1],pp[1]);
            barpp(tw/2,cp[1],pp[0]);
            barpp(tw/2,cp[2],pp[1]);
            barpp(tw/2,cp[2],pp[0]);
            barpp(tw/2,cp[2],pp[2]);
            barpp(tw/2,cp[1],pp[3]);
            barpp(tw/2,cp[5],pp[2]);
            barpp(tw/2,cp[4],pp[3]);
        }*/
        rotate([0,0,-90]) {
            difference(){polyRoundExtrude([  
                        [pw+tw/2,tw/2,tw/2],
                        [notch,tw/2,tw/2],
                        [0,-notch+tw/2,tw/8],
                        [-notch,tw/2,tw/2],
                        [-pw-tw/2,tw/2,tw/2],
                        [-(rMinBarrel+tw/2)*sqrt(3),-notch-rMinBarrel*3-tw,tw+ri],
                        [(rMinBarrel+tw/2)*sqrt(3),-notch-rMinBarrel*3-tw,tw+ri],
                        ],
                    pl+tw,tw/2-.01,tw/2-.01,fn=fn);
                unionMirror([1,0,0])translate([0,0,-epsilon]) polyRoundExtrude([
                        [pw-tw/2,-tw/2,ri],
                        [tw*1.2,-notch,ri],
                        [(rMinBarrel+tw/2)*sqrt(3)-tw,-notch-rMinBarrel*3+1.5*tw,ri]],
                pl+tw+2*epsilon,-ri,-ri,fn=fn);
                        
                
            }
            translate([0,0,pl+tw-tf]){
                polyRoundExtrude(
                   [[ notch+tw,-tf/2,tf/2],
                    [ notch+tw,tf/2,tf/2],
                    [-notch-tw,tf/2,tf/2],
                    [-notch-tw,-tf/2,tf/2]],
                   tf,tf/2-0.01,tf/2-0.01,fn=fn);
                sphere(r=tf/2);
            }
            txo = tp/2;
            unionMirror([1,0,0]) {
                for(os = [tw,pl-3-tw]) translate([0,0,os+tw/2])
                     polyRoundExtrude([ [pw+tw/2,0,0],
                                        [pw+tw/2,tw/2+tp+1*tf,tf],
                                        [pw+tw/2-2*tp,tw/2+tp+1*tf,tf],
                                        [pw+tw/2-2*tp,tw/2+tp-0.5*tf,tf/2],
                                        [pw+tw/2-2*tp+tf,tw/2+tp-0.5*tf,tf/2],
                                        [pw+tw/2-2*tp+tf,tw/2+tp+0.0*tf,tf/2],
                                        [pw+tw/2-tf,tw/2+tp,tf/2],
                                        [pw+tw/2-tf,0,0]],
                                        3,tf/2-.01,tf/2-.01,fn=fn);
                translate([pw+tw/2-tf,0,0])
                    polyRoundExtrude([  [0,      -tf/2, tf/2],
                                        [tf,  -tf/2, tf/2],
                                        [tf,  tw/2+txo, tf+txo-tf*sin(22.5)],
                                        [tf-tp,tw/2+txo+tp,tf/2],
                                        [-2+tf/sqrt(2)/2,     tw/2+txo+2-tf/sqrt(2), tf/2],
                                        [0,      tw/2+txo-tf*sin(22.5), txo-tf*sin(22.5)]],
                                     tw,0,tf/2-.01,fn=fn);
            }
        }
    }      
}