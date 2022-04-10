include <Round-Anything/polyround.scad>
include <common.scad>
h=10;
t=1.5;
s=8;
$fs=0.25;
sa = atan(s/2/h);



module barAngle(p1,p0,p2,t,rscale=0.5){
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
    echo ([xjl,yjl])
    translate(p0) {
         sphere(r=t/2);
         rotate([xAngle,phi1,theta1]){
             rotate([0,90,0])cylinder(r=t/2,h=r1);
             rotate([0,90,inPlaneAngle])cylinder(r=t/2,h=r2);
             intersection(){
                translate([xjl,yjl,0])rotate([0,0,90])rotate_extrude(angle=180+inPlaneAngle){
                    translate([-yjl,0])circle(r=t/2);
                    translate([-yjl,-t/2])square([100,t]);
                }
                linear_extrude(2*t,center=true){
                        polygon([
                            [0,0],
                            [xjl,0],
                            [xjl,yjl],
                            [xjl*cos(inPlaneAngle),xjl*sin(inPlaneAngle)]]);
                }
            }
        }    
    }   
}


gridX = s;
gridY = gridX*sqrt(3)/2;


function computeZ(p) = let(rv=2-norm(p)/10) (rv<0) ? 0 : ((rv>1) ? 1 : rv);
function uPoint(xi,yi) = [gridX*(xi+sign(yi)*(yi%2)/2),yi*gridY];
function vPoint(xi,yi) = [gridX*(xi+sign(yi)*(yi%2)/2-0.5),(yi-1/3)*gridY];
function fullU(xi,yi) = let(u=uPoint(xi,yi))[each u,h/2*computeZ(u)];
function fullV(xi,yi) = [each vPoint(xi,yi),-h/2*computeZ(vPoint(xi,yi))];
function uok(u) = u.z>0;
function vok(v) = v.z<0;

for (yi=[-10:10]) for (xi=[-10:10]){
    xyadj = xi-1+(yi%2)*sign(yi);
    u = fullU(xi,yi);
    if (uok(u)) {
        ai = [[xi+1,yi],[xyadj+1,yi+1],[xyadj,yi+1],
              [xi-1,yi],[xyadj  ,yi-1],[xyadj+1,yi-1]];   
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
