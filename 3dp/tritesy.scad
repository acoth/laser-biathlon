include <common.scad>

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
    translate(p0) {
         sphere(r=t/2);
         rotate([xAngle,phi1,theta1]){
             rotate([0,90,0])cylinder(r=t/2,h=r1);
             rotate([0,90,inPlaneAngle])cylinder(r=t/2,h=r2);
             /*intersection(){
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
            }*/
        }    
    }   
}





module vertexGen(xi,yi,zi,zFunction,t=1.5,fullU,fullV,uok,vok) {
    
    fullP = (zi>0) ? fullU : fullV;
    fullQ = (zi>0) ? fullV : fullU;
    okp   = (zi>0) ? uok : vok;
    okq   = (zi>0) ? vok : uok;
           
    xyadj = xi-1+(yi%2)*sign(yi);
    p = fullP(xi,yi,zFunction);
    if (okp(p)) {
        pai = [[xi+1,yi],[xyadj+1,yi+1],[xyadj,yi+1],
               [xi-1,yi],[xyadj  ,yi-1],[xyadj+1,yi-1]];   
        qai = [[xi-1+zi,yi],[xi+zi,yi],[xyadj+zi,yi-1+2*zi]];
        okpadj = [ for (a=pai) let(p=fullP(a[0],a[1],zFunction)) if (okp(p)) p];
        okqadj = [ for (a=qai) let(q=fullQ(a[0],a[1],zFunction)) if (okq(q)) q];
        if (len(okpadj)>1) for (k = [0:len(okpadj)-1]) {
            barAngle(okpadj[k],p,okpadj[(k+1)%len(okpadj)],t);
            *for (m = [0:len(okqadj)-1])
                barAngle(okpadj[k],p,okqadj[m],t);
        }
        if (len(okqadj)>1)for (k=[0:len(okqadj)-1])
            barAngle(okqadj[k],p,okqadj[(k+1)%len(okqadj)],t);
    }    
}

module cellFill(lowerLeft,upperRight,gridX,thickness,zFunction) {
    gridY = sqrt(3)/2*gridX;
    xArray = [floor(lowerLeft.x/gridX-1) : ceil(upperRight.x/gridX+1)];
    yArray = [floor(lowerLeft.y/gridY-1) : ceil(upperRight.y/gridY+1)];

    fullU = function (xi,yi,zFunction) let(u=[gridX*(xi+sign(yi)*(yi%2)/2),yi*gridY])
                                [each u,zFunction(u)];
    fullV = function (xi,yi,zFunction) let(v=[gridX*(xi+sign(yi)*(yi%2)/2-0.5),(yi-1/3)*gridY])
                                [each v,-zFunction(v)];
    uok = function (u) u.z>0;
    vok = function (v) v.z<0;

    for (xi = xArray) for (yi = yArray) for (zi = [0,1]) 
        vertexGen(xi,yi,zi,zFunction,thickness,fullU,fullV,uok,vok);
}

