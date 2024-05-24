// by Antoine Trillet


module limit(xmin = -2000, xmax = 2000, ymin = -2000, ymax = 2000, zmin = -2000, zmax= 2000){
    intersection(){
        children(); 
        translate([xmin, ymin , zmin])cube([xmax-xmin, ymax-ymin, zmax-zmin]);
    }
}

//example: 
//limit(xmin = 10, ymax =10){cube(20);};