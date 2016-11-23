use <Spiff.scad>;

resolution = 200;

// Units are in mm
baseHeight = 6;
baseRadius = 60;
usbLength = 21;
usbWidth = 13;
usbHeight = 5;
mHeight = 56;
mWidth = 9;

module securityHole(height = baseHeight) {
    translate([40, 0, 0])
        cylinder(height, 4, 4, false, $fn=resolution);
}

module lowerBase(baseRadius, baseHeigth) {
    difference() {
        cylinder(baseHeight,baseRadius, baseRadius, false, $fn=resolution);
        securityHole(baseHeight);
    }
}

module oneM(height = mHeight, width = mWidth) {
    // Vertical Pieces
    translate([26, -4.5,5])
        cube([width, width, height]);
    translate([-36,-4.5, 5])
        cube([width, width, height]);
    // Diagonal Pieces
    translate([33,-4.5, height-1.4])
        rotate([0,-135,0])
            cube([width, width, height*5/7]);
    translate([-27,-4.5, height+5])
        rotate([0,135,0])
            cube([width, width, height*5/7]);
}

// Creates the two M's
module twoM(mHeight, mWidth) {
  oneM(mHeight, mWidth);
  rotate([0, 0, 90])
    translate([0, 0, 0])
        oneM(mHeight, mWidth);
}

// Cube used to merge the diagonal pieces in the 'M'
module cubeForM(mHeight) {
  translate([-4.6,-4.5, mHeight*3/4-12.5])
      cube([9.2, 9, 5]);
}

module usbHole(height = usbHeight, length = usbLength, width = usbWidth) {
    cube([length-2, width-2, height-2]);
}

module usbSocket(height = usbHeight, length = usbLength, width = usbWidth) {
    difference() {
        cube([length, width, height]);
        translate([0, 1, 1])
            usbHole(usbHeight, usbLength, usbWidth);
    }
}

module result() {
  lowerBase(baseRadius, baseHeight);
  upperBase(baseRadius, baseHeight);
  difference() {
      twoM(mHeight, mWidth);
      cubeForM(mHeight);
  }    
  translate([-2.5, -6.5, 2*baseHeight + mHeight - 7])
      rotate([0,90,0])
          usbSocket(usbHeight, usbLength, usbWidth);
}

result();
