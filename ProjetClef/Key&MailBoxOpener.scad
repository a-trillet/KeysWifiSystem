$fn = 150;

include <./lib/threads.scad>
//https://github.com/rcolyer/threads-scad/blob/master/README.md
//Box1 info
H1 = 15; // height1
W = 100;
L = 100;
walls = 2;
hole = 1;
Wkey = 40;


//trap info
tT = 1;
tTolX = 1;
tTolH = 2;
tH =H1-tTolH;
tW =W-tTolX;
tL =L/3;

//box2 info
H2 = 50;

//bar info
Wbar = 15;
Hbar = tH;
Lbar = W*0.7;
rotorHoleR = 1;
rotorHoleW = 1;

//Box3 info
H3 = walls;

//attaches info
atT = walls;
atHole = 3;
atW = 25;
atTol = 0.2;

//Opener info
Ropen = 10;
Lopen = 100;
TolOpen = 0.5;
Xopen = 10+Ropen;
module trap(T,H,L,W){
    
    difference(){
        cube([W,L,H]);
        translate([W-Wkey-T,T,T])cube([Wkey,L,H-2*T]);
    }
}
module screw(){
    
}
module Box1(){
    difference(){
       minkowski(){
           cube([W,L,H1+walls/2]);
           sphere(walls);
        }
        cube([W,L,H1+walls/2]);
        translate([W-Wkey-tT,L-H1,0])cube([Wkey,H1*3,2*H1]);
        translate([0,0,1.5*H1+walls/2-0.1])cube([4*W,4*L,H1], center = true);
        translate([-walls/2,-walls/2,H1])cube([W+walls,L+walls,H1]);
        translate([Xopen,L-walls/2,H1/2])rotate([-90,0,0])difference(){
            cylinder(h= 2*walls,r = Ropen+TolOpen);
            translate([0,50+H1/2,0])cube(100,center = true);
            translate([0,-50-H1/2,0])cube(100,center = true);
        }
    }
}

module Box2(){
    difference(){
       minkowski(){
           cube([W,L,H2+walls/2]);
           sphere(walls);
        }
        cube([W,L,H2+walls/2]);
        translate([0,0,-0.5*H2+0.1])cube([4*W,4*L,H2], center = true);
        translate([0,0,1.5*H2+walls/2-0.1])cube([4*W,4*L,H2], center = true);
        translate([-walls/2,-walls/2,H2])cube([W+walls,L+walls,H2]);
    }
    translate([-walls/3,-walls/3,-walls/2])cube([W+2*walls/3,L+2*walls/3,3*walls/2]);
}

module Bar(){
    difference(){
        cube([Lbar,Wbar,Hbar]);
        translate([3,Wbar/2,-Hbar/2])difference(){
            cylinder(h=2*Hbar,r=rotorHoleR);
            translate([rotorHoleW/2,-50,-50])cube(100);
        }
    }
    translate([Lbar,Wbar/2,0])cylinder(h=Hbar,r=Wbar/2);
    }
module attaches(){
    translate([atTol,0,0])difference(){
        union(){
            cube([atW,atW,atT]);
            cube([atT,atW,H1+H2+H3+walls]);
        }
        translate([atW/2,atW/2,-atT/2])cylinder(h= 2*atT, r = atHole);
    }
    translate([-walls,0,H1+H2+H3-atT])cube([atTol+walls,atW,H3+walls]);
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
        translate([W+walls,L/2,-H1-H2])attaches();
        translate([-walls,L/2+atW,-H1-H2])rotate([0,0,180])attaches();
        translate([W/2-atW/2,-walls,-H1-H2])rotate([0,0,270])attaches();
    }

AugerThread(14, 10, L, 10);

//AugerHole(16,12,L/4,10){
//cylinder(L/4,10,10);}
//Box1();
//translate([tTolX/2,40,tTolH/2])trap(tT,tH,tL,tW);
//translate([0,0,50])Box2();
//translate([0,0,1])Bar();
//translate([0,0,120])Box3();
//translate([-50,0,0])attaches();