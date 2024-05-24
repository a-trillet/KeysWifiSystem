$fn = 150;

include <./lib/threads.scad>
//https://github.com/rcolyer/threads-scad/blob/master/README.md
include <./lib/usefulFunctions.scad>

//todo 
// centrer les fentes 
// faire une boite en dessous pour l'elec

//Box1 info
H1 = 20; // height1
W = 70;
L = 110;
elecL = 70;
walls = 2;
hole = 1;
Length = L + elecL;

// key dim
Wkey = 40;
Tkey = 4;

//trap info
tT = 2;
tTol = 1;
tH =H1-tTol;
tW =W-tTol;
tL =30;
tEcart = Wkey/3; //ecart entre les fentes
trouW = 2;
trapCleanEdge = 0.5;

//box2 info
H2 = 30;

cableY = -elecL+10;
cableZ = 5;
cableW = 8;
cableH = 12;

ledR = 3;
ledX = ledR+10;
ledZ = H2-ledR-5;

//bar info
Wbar = 12;
Hbar = tH;
Lbar = 89;
rotorX = 25;
rotorY = 18;


//Box3 info
H3 = walls;
elecH = 40;

//attaches info
atT = walls;
atHole = 2;
atW = 25;
atTol = 0.5;
atAddL = atW/3;
atHoleX = atW/2;// middle point of the pad
atY = L/3*2;
atX = W/2;

// Closer Infos 
Yc = 5;
Lc = L - Yc -2;
Wc = 10;
Hc =10;
Tc = 2;
Lcb = 40;
Tcb = Tc-0.5;
Anglecb = 10;
Rc = 2;
tolc = 0.2;
Lcyl = Wc + 5;

// screw dimensions 
screwL = L - 2;
screwR = 14;
screwr = 10;
LPin = 5;
rPin = 2;
tolPin = 0.5; // ray
rotorHoleR = 2.5;
rotorHoleW = 3;
rotorL = 10;
rotorTol = 0.1;

//screwTrap
trapScrewR = 16;
trapScrewr = 12;

module Screw(){
    
    difference(){
        AugerThread(screwR, screwr, screwL, 10);
        translate([0,0,-0.1])limit(xmin =-rotorHoleW/2-rotorTol, xmax =  rotorHoleW/2+rotorTol){
           union(){
                translate([0,0,10])sphere(rotorHoleR+rotorTol);
                 cylinder(h=10,r=rotorHoleR+rotorTol);
           }
        }
        translate([0,0,screwL-10+0.1])cylinder(h = LPin +5, r=  rPin + tolPin);
    }
    
}
module old_trap(T,H,L,W){
    difference(){
        cube([W,L,H]);
        translate([W-Wkey-T,T,T])cube([Wkey,L,H-2*T]);
        translate([tW-Wkey,tL-T+0.01,0])polyhedron( points = [
        [T-2*T,0, T],//0
        [Wkey-2*T,0, T],//1
        [Wkey,T,0],//2
        [-2*T,T,0],//3
        [T-2*T,0,tH-T],//4
        [Wkey-2*T,0,tH-T],//5
        [Wkey,T,tH],//6
        [-2*T,T,tH] ],//7
    faces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]] );// left], convexity = N);
    translate([tW-(Wkey-tEcart)/2,-T,T])cube ([trouW,3*T,tH-2*T]);
    translate([tW-(Wkey-tEcart)/2-tEcart,-T,T])cube ([trouW,3*T,tH-2*T]);
    
    }
}
module trap(T,H,L,W){
    difference(){
        union(){
            difference(){
                    cube([W,L,H]);
                    translate([W-Wkey-T,T,T])cube([Wkey,L,H-2*T]);
                }
            limit( ymax = L, ymin = 0.1, xmax = W-0.1, zmax = H -0.1, zmin = 0.1){
                union(){
                translate([0,T,0])cube([W,L/2,H/2-Tkey/2]);
                translate([0,L/2+T,0])scale([W,L/2-T+trapCleanEdge, H/2-Tkey/2])rotate([0,90,0])cylinder(h=1, r= 1);
                }
                translate([0,0,H/2])mirror([0,0,1])translate([0,0,-H/2])union(){
                translate([0,T,0])cube([W,L/2,H/2-Tkey/2]);
                translate([0,L/2+T,0])scale([W,L/2-T+trapCleanEdge, H/2-Tkey/2])rotate([0,90,0])cylinder(h=1, r= 1);
                }
            }
        }
        translate([tW-(Wkey-tEcart)/2,-T,T])cube ([trouW,2*L,tH-2*T]);
        translate([tW-(Wkey-tEcart)/2-tEcart,-T,T])cube ([trouW,2*L,tH-2*T]);
    }
    translate([0,0,H/2-Tkey/2])cube([W,T,Tkey]);
}

module screwTrap(){
    rotate([-90,0,0])translate([(tW-Wkey)/2,-tH/2,-0.1])
    AugerHole(trapScrewR, trapScrewr, tL+0.2,10){
    translate([-(tW-Wkey)/2,tH/2,0.1])rotate([90,0,0])
    trap(tT,tH,tL,tW);
    }
}

module attachesBox1(){
    difference(){
        union(){
            translate([-walls-0.1,0,0])cube([atAddL+atTol+walls+0.1,atW,atT]);
            difference(){
                translate([atAddL+walls-atTol,atW/2,0])cylinder(h=atT, r= atW/2);
                translate([-2*atW+0.1,0,-1])cube(2*atW);
            }
        }
        translate([atHoleX,atW/2,-atT/2])cylinder(h= 2*atT, r = atHole);
    }
}

module Box1(){
    difference(){
        union(){
            translate([0,-elecL,0])difference(){
               minkowski(){
                   cube([W,Length,H1+walls/2]);
                   sphere(walls);
                }
                cube([W,Length,H1+walls/2]);
                // key hole
                translate([W-Wkey-tT,Length-H1,0])cube([Wkey,H1*3,2*H1]);
            }
            difference(){
                translate([0,-walls,0])cube([W,walls, H1]);
                translate([(tW-Wkey)/2+tTol/2 ,-2*walls, tH/2 + tTol/2]) rotate([-90,0,0])cylinder(h= 3*walls, r= rotorHoleR + 0.4);
            }
            translate([(tW-Wkey)/2+tTol/2, L-LPin, tH/2 + tTol/2]) rotate([-90,0,0]) cylinder(h= LPin, r= rPin);
            //add attaches
            translate([W+walls,atY-atW/2,-walls])attachesBox1();
            translate([-walls,atY-atW/2+atW,-walls])rotate([0,0,180])attachesBox1();
            //translate([atX-atW/2,-walls-elecL,-walls])rotate([0,0,270])attachesBox1();
            translate([W+walls,-elecL/2-atW/2,-walls])attachesBox1();
            translate([-walls,-elecL/2+atW/2,-walls])rotate([0,0,180])attachesBox1();
            //add guides
            limit(ymax = L+walls, zmax = H1 +walls/2){translate([W-Wkey-tT,L,H1])rotate([0,90,0])cylinder(h = Wkey+tT, r = H1/2-Tkey/2);};
            limit(ymax = L+walls, zmin = 0){translate([W-Wkey-tT,L,0])rotate([0,90,0])cylinder(h = Wkey+tT, r = H1/2-Tkey/2);};
        }
        // flattening mur
        translate([0,-elecL,1.5*H1+walls/2-0.1])cube([4*W,4*Length,H1], center = true);
        // flattening walls
        translate([-walls/2,-walls/2-elecL,H1])cube([W+walls,Length+walls,H1]);
    }
}

module Box2(){
    difference(){
        union(){
        difference(){
        minkowski(){
           cube([W,L,H2+walls/2]);
           sphere(walls);
        }
            

        cube([W,L,H2+walls/2]);
        translate([0,0,-0.5*H2+0.1])cube([4*W,4*L,H2], center = true);
        translate([0,0,1.5*H2+walls/2-0.1])cube([4*W,4*L,H2], center = true);
        translate([-walls/2,-walls/2,H2])cube([W+walls,L+walls,H2]);
        translate([-3/2*walls, cableY-cableW/2, cableZ-cableH/2])cube([2*walls, cableW, cableH]);
        translate([ledX, L-walls/2, ledZ])rotate([-90,0,0])cylinder(h = 2*walls, r= ledR);
    }
    translate([-walls/3,-walls/3,-walls/2])cube([W+2*walls/3,L+2*walls/3,3*walls/2]);
    }
    translate([rotorX,rotorY, -walls]) cylinder(h = 3*walls, r= rotorHoleR+0.2);
    //hole for wires
    translate([5+rotorHoleR,5+rotorHoleR, -walls]) cylinder(h = 3*walls, r= rotorHoleR+0.2);
    //hole to attach the closer
    translate([W-Lcyl,0,-10])cube([Lcyl,H1+Wc+Yc,2*Lcyl]);
    //hole for closer
    translate([W-Wkey-Lcyl,L-3*Tc,-walls])cube([Wkey+ Lcyl, 3*Tc,4*walls]);
    }
    //cylindre pour le closer
    translate([W-Lcyl/2, Yc+Wc/2 ,2* walls+Wc/2])rotate([0,90,0])cylinder(h=Lcyl, r= Rc, center=true);
    //separation electronique closer
    translate([W-Lcyl-walls,H1+Wc+Yc,0]) cube([walls,L-5*Tc-(H1+Wc+Yc),H2]);
    translate([W-Lcyl-Wkey-Lcb,L-5*Tc,0]) cube([Wkey+Lcb,walls,H2]);
}
module Bar(){
    difference(){
        union(){
            translate([Wbar/2,0,0])cube([Lbar-Wbar,Wbar,Hbar]);
            translate([Lbar-Wbar/2,Wbar/2,0])cylinder(h=Hbar,r=Wbar/2);
            translate([Wbar/2,Wbar/2,0])cylinder(h=Hbar,r=Wbar/2);
        }
        translate([Wbar/2,Wbar/2,-Hbar/2])difference(){
            cylinder(h=2*Hbar,r=rotorHoleR);
            translate([rotorHoleW/2,-50,-50])cube(100);
            translate([-100-rotorHoleW/2,-50,-50])cube(100);
        }
    }
}
    
module attaches(legH){
    translate([walls,0,-legH+atT-walls])union(){
    translate([-atTol,0,0])difference(){
        union(){
            cube([atAddL,atW,atT]);
            difference(){
                translate([atAddL,atW/2,0])cylinder(h=atT, r= atW/2);
                translate([-2*atW+0.1,0,-1])cube(2*atW);
            }
            difference(){
                cube([2*atT,atW,H3+2*atT]);
                translate([2*atT,-atW/2, 3*atT])rotate([-90,0,0])cylinder(h = 2*atW, r = 2*atT);
            }
        }
        translate([atHoleX-walls+atTol,atW/2,-atT/2])cylinder(h= 2*atT, r = atHole);
    }
    translate([-walls+atTol,0,walls-atT])cube([walls-atTol,atW,legH+0.1]);
    }
    
    limit(xmin = -walls, zmin= 0, zmax = 2*walls, xmax = atT){translate([-walls,0,-walls/2])scale([1.1,1,1.25])rotate([-90, 0,0])cylinder(h = atW, r = walls+atT);}
}


module Box3(){
        translate([0,0,-5+H3])difference(){
           minkowski(){
           cube([W,L,5]);
           sphere(walls);    
           }
           translate([0,0,-H3])cube([4*W,4*L,10], center = true);
        }
        translate([-walls/3,-walls/3,-walls/2])cube([W+2*walls/3,L+2*walls/3,walls/2]);
        //add attaches
        translate([W+walls,atY-atW/2,-H1-H2])attaches(H1);
        translate([-walls,atY-atW/2+atW,-H1-H2])rotate([0,0,180])attaches(H1);
        translate([atX-atW/2,-walls,-H1-H2])rotate([0,0,270])attaches(H1);
}
module BoxScrew(){
    legH = H1;
    difference(){
        union(){
            //main part
            translate([0,0,-5+H3])difference(){
               minkowski(){
               cube([W,L,5]);
               sphere(walls);    
               }
               translate([0,0,-H3])cube([4*W,4*L,10], center = true);
            }
            translate([-walls/3,-walls/3,-walls/2])cube([W+2*walls/3,L+2*walls/3,walls/2]);
            //elec part 
            translate([0,-elecL,-5+H3])difference(){
               minkowski(){
               cube([W,elecL,elecH]);
               sphere(walls);    
               }
               translate([0,0,-H3])cube([4*W,4*L,10], center = true);
            }
            translate([-walls/3,-walls/3-elecL,-walls/2])cube([W+2*walls/3,L+2*walls/3,walls/2]);
    }
    //hole for elec
    translate([0,-elecL,-5+H3-2*walls])cube([W,elecL,2*walls+elecH]);
    translate([-3/2*walls, cableY, cableZ])cube([2*walls, cableW, cableH]);
    }
    //add attaches
    translate([W+walls,atY-atW/2,0])attaches(legH);
    translate([-walls,atY-atW/2+atW,0])rotate([0,0,180])attaches(legH);
    translate([W+walls,-elecL/2-atW/2,0])attaches(legH);
    translate([-walls,-elecL/2+atW/2,0])rotate([0,0,180])attaches(legH);
    //translate([atX-atW/2,-elecL-walls,0])rotate([0,0,270])attaches(legH);
}
module Closer(){
difference(){
union(){
    translate([0,Wc/2,0])cube([Wc,Lc-Wc/2,Hc]);
    translate([-Wkey+Wc,Lc-Tc,-Hc+1])cube([Wkey,2,H1-1+Hc]);
    translate([0,0,-H1+Wc/4])cube([Wc,Wc/2,Wc/2+H1-Wc/4]);
    translate([Wc/2,Wc/4,Wc/4-H1])rotate([0,90,0])cylinder(h=Wc, r= Wc/4, center=true);
    translate([Wc/2,Wc/2,Wc/2])rotate([0,90,0])cylinder(h=Wc, r= Wc/2, center=true);
    translate([-Lcb-Wkey+Wc,Lc-Tc,Hc-Tcb])cube([Lcb, Tc, Tcb]);
    difference(){
        translate([-Lcb-Wkey+Wc+Tcb*cos(Anglecb),Lc-Tc,Hc-sin(Anglecb)*Tcb])rotate([0,Anglecb+180,0])cube([Tcb,Tc,2*(Hc+H1)]);
        translate([-W,Lc-3*Tc,-H1-100])cube([100,100,100]);
    }
}
translate([Wc/2,Wc/2,Wc/2])rotate([0,90,0])cylinder(h=2*Wc, r= Rc +tolc, center=true);
}
}
module manetteJeton(){
    Wjeton = 9;
    cube([Wjeton,15,0.5],center=true);
    limit(xmin = -Wjeton/2, xmax = Wjeton/2, ymax=5, ymin=-5){cylinder(r=5.4,h=6);}
    }
    
manetteJeton();
//AugerThread(14, 10, L, 10);

//AugerHole(17,12,L/6,10){
//cylinder(L/6,10,10);}
//translate([(tW-Wkey)/2+tTol/2 ,tTol/2, tH/2 + tTol/2]) rotate([-90,0,0])Screw();
//Box1();
//translate([0.5,40,0.5])trap(tT,tH,tL,tW);
//trap(tT,tH,tL,tW);
//translate([tTol/2,40,tTol/2])screwTrap();
//translate([0,0,50])Box2();
//translate([rotorX-Wbar/2,rotorY-Wbar/2,0.5])rotate([0,0,5])Bar();
//translate([0,0,H1])BoxScrew();
//attachesBox1();
//attaches(H1);
//translate([W-Wc-2,Yc,50+2*walls])rotate([7,0,0])Closer();
