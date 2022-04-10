include <Round-Anything/polyround.scad>
include <common.scad>
h=10;
t=1.5;
s=8;
$fs=0.1;
sa = atan(s/2/h);
*for (ang = [0:120:359]) rotate([0,0,ang]){unionMirror([0,1,0])
*translate([-s/2,s*sqrt(3)/2,-h/2]){
multmatrix([
    [sqrt(pow(s,2)+pow(h,2))/h, 0, s/h, 0],
    [0, 1, 0, 0],
    [0, 0, 1, 0]])
polyRoundExtrude([
        [t/2,t/2,t/2],
        [t/2,-t/2,t/2],
        [-t/2,-t/2,t/2],
        [-t/2,t/2,t/2]],
        h,-t/2,-t/2,fn=10);

}
for (xa=[0,180]) rotate([0,xa,0])jointFillet();}
module jointFillet(){
bm = sqrt(pow(h,2)+pow(s,2)/4)/1.5;
sm = s*sqrt(3)/2/1.5;
hyp = sqrt(pow(s,2)+pow(h,2))/1.5;
t1 = t/bm*hyp;
t2 = t/sm*hyp;
te = [t/hyp*sm/2,t/hyp*bm/2];
    translate([-s,0,h/2])
rotate([0,90-sa,0]) translate([0,0,-t/2])
polyRoundExtrude([
    [bm-te.x,-sm-te.y,0],
    [bm+te.x,-sm+te.y,0],
    [t2/2,0,t/4],
    [bm+te.x,sm-te.y,0],
    [bm-te.x,sm+te.y,0],
    [-t2/2,0,t2/2*sm/(hyp-sm)]],
    t,t/2-epsilon,t/2-epsilon,fn=10);
}


module barAngle(p1,p0,p2,t,rscale=1){
    d1 = p1-p0;
    d2 = p2-p0;
    r1 = norm(d1);
    r2 = norm(d2);
    theta1 = atan2(d1.y,d1.x);
    phi1 = -atan2(d1.z,norm([d1.x,d1.y]));
    
    vertNorm = [0,0,1];
    horizPerpD1 = [d1.y,-d1.x,0];
    vertPerpD1 = vertNorm-((d1*vertNorm)/(d1*d1))*d1;
    d2rejd1 = d2-((d1*d2)/(d1*d1))*d1;
    projHoriz = (d2rejd1*horizPerpD1)/norm(horizPerpD1);
    projVert  = (d2rejd1*vertPerpD1)/norm(vertPerpD1);
    xAngle = atan2(-projVert,projHoriz);
    inPlaneAngle = -acos((d1*d2)/r1/r2);
    yjl = -t/2*(1+rscale);
    xjl = yjl/tan(inPlaneAngle/2);
    translate(p0) {
         sphere(r=t/2);
         rotate([xAngle,phi1,theta1]){
             rotate([0,90,0])cylinder(r=t/2,h=r1);
             rotate([0,90,inPlaneAngle])cylinder(r=t/2,h=r2);
             intersection(){
                translate([xjl,yjl,0])rotate([0,0,90])rotate_extrude(angle=180+inPlaneAngle){
                    translate([-yjl,0])scale([1,1/rscale])circle(r=t/2*rscale);
                    translate([-yjl,-t/2])square([-t-t/sin(inPlaneAngle/2),t]);
                }
                linear_extrude(2*t,center=true){
                        polygon([
                            [0,0],
                            [xjl,0],
                            [xjl,-t],
                            [xjl*cos(inPlaneAngle),xjl*sin(inPlaneAngle)]]);
                }
            }
        }    
    }   
}

module barVertex(pVertex,pList) {
    for (i=[0:len(pList)-2])
        for (j=[i+1:len(pList)-1])
            barAngle(pList[i],pVertex,pList[j],1);
}
v = [[-s/2,-s*sqrt(3)/6,-h/2],
     [ s/2,-s*sqrt(3)/6,-h/2],
     [   0, s*sqrt(3)/3,-h/2],
     [-s/2, s*sqrt(3)/6, h/2],
     [ s/2, s*sqrt(3)/6, h/2],
     [   0,-s*sqrt(3)/3, h/2]];
    
    
module cell() {
barVertex(v[0],[v[1],v[2],v[3],v[5]]);
barVertex(v[1],[v[0],v[2],v[4],v[5]]);
barVertex(v[2],[v[1],v[0],v[3],v[4]]);
barVertex(v[3],[v[4],v[5],v[0],v[2]]);
barVertex(v[4],[v[3],v[5],v[1],v[2]]);
barVertex(v[5],[v[3],v[4],v[0],v[1]]);
}

module intVert(p0,s,h) {
    translate(p0){
   for (ang = [0:60:359])
       barAngle([s*cos(ang),s*sin(ang),0],[0,0,0],[s*cos(ang+60),s*sin(ang+60),0],t);
   for (angi = [0:2]) {
       ang = 120*angi+90*sign(h);
       for (pm = [-1,1]) barAngle([s*cos(ang)*sqrt(3)/3,s*sin(ang)*sqrt(3)/3,h],[0,0,0],[s*cos(ang+pm*30),s*sin(ang+pm*30),0],t);
       barAngle([s*cos(ang)*sqrt(3)/3,s*sin(ang)*sqrt(3)/3,h],[0,0,0],[s*cos(ang+120)*sqrt(3)/3,s*sin(ang+120)*sqrt(3)/3,h],t);   
   }
   }
}
//cell();
gridX = s;
gridY = gridX*sqrt(3)/2;


function computeZ(p) = let(rv=2-norm(p)/10) (rv<0) ? 0 : ((rv>1) ? 1 : rv);
function uPoint(xi,yi) = [gridX*(xi+sign(yi)*(yi%2)/2),yi*gridY];
function vPoint(xi,yi) = [gridX*(xi+sign(yi)*(yi%2)/2-0.5),(yi-1/3)*gridY];
function fullU(xi,yi) = let(u=uPoint(xi,yi))[each u,h/2*computeZ(u)];
function fullV(xi,yi) = [each vPoint(xi,yi),-h/2*computeZ(vPoint(xi,yi))];
function uok(u) = u.z>0;
function vok(v) = v.z<0;


barAngle([10,0,0],[0,0,0],[0,10,0],1);

*for (yi=[0]) for (xi=[0]){
    xyadj = xi-1+(yi%2)*sign(yi);
    u = fullU(xi,yi);
    if (uok(u)) {
        ai = [[xi+1,yi],[xyadj+1,yi+1],[xyadj,yi+1],[xi-1,yi],[xyadj,yi-1],[xyadj+1,yi-1]];   
        vai = [[xi,yi],[xi+1,yi],[xyadj+1,yi+1]];
        okadj = [ for (a=ai) let(u=fullU(a[0],a[1])) if (uok(u)) u];
        okvadj = [ for (a=vai) let(v=fullV(a[0],a[1])) if (vok(v)) v];
        for (k = [0:len(okadj)-1]) {
            barAngle(okadj[k],u,okadj[(k+1)%len(okadj)],t);
            for (m = [0:len(okvadj)-1])
                barAngle(okadj[k],u,okvadj[m],t);
        }
        for (k=[0:len(okvadj)-1])
            barAngle(okvadj[k],u,okvadj[(k+1)%len(okvadj)],t);
    }
    v = fullV(xi,yi);
    *if (vok(v)) {
        ai = [[xi+1,yi],[xyadj+1,yi+1],[xyadj,yi+1],[xi-1,yi],[xyadj,yi-1],[xyadj+1,yi-1]];   
        vai = [[xi-1,yi],[xi,yi],[xyadj,yi-1]];
        okadj = [ for (a=ai) let(v=fullV(a[0],a[1])) if (vok(v)) v];
        okvadj = [ for (a=vai) let(u=fullU(a[0],a[1])) if (uok(u)) u];
        for (k = [0:len(okadj)-2]) {
            barAngle(okadj[k],v,okadj[k+1],t);
            for (m = [0:len(okvadj)-1])
                barAngle(okadj[k],v,okvadj[m],t);
        }
        barAngle(okadj[len(okadj)-1],v,okadj[0],t);
    }  
}



se = s+t*(2*sqrt(3)/2);
sr = 0.5*t;
sf = s-t*sqrt(3)/2;
*translate([0,0,-h/2-t+epsilon]) difference(){
    polyRoundExtrude([
        [se,0,sr],
        //[se/2,se*sqrt(3)/2,sr],
        [-se/2,se*sqrt(3)/2,sr],
        //[-se,0,sr],
        [-se/2,-se*sqrt(3)/2,sr],
        //[se/2,-se*sqrt(3)/2,sr]
    ],
    t,0,0,fn=10);
    plateHole();
    for (ang = [60:120:359])
    rotate([0,0,ang]) translate([s,0,0])plateHole();
    
}
module plateHole(){
    translate([0,0,-epsilon])
    polyRoundExtrude([
        [sf,0,t*sqrt(3)/3],
        [-sf/2,sf*sqrt(3)/2,t*sqrt(3)/3],
        [-sf/2,-sf*sqrt(3)/2,t*sqrt(3)/3]],
    t+2*epsilon,-t/2,-t/2,fn=10);
}
