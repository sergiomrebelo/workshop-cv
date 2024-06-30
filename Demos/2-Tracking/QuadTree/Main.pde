/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *
 * Basic QuadTree implementation
 * for color segmentation (RGB) of a capture (processing.video)
 *
 * @author Sérgio Rebelo
 * @since Jun 2024
 */

import processing.video.*;

Capture cam;
QuadTree qt;
boolean backgroundImage = false;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  // printArray(cameras);
  if (cameras.length == 0) {
    exit();
  }
  cam = new Capture(this, cameras[0]);
  cam.start();

  qt = new QuadTree (5, 100);
}

void draw () {
  if (cam.available() == true) {

    cam.read();
    background(255);
    qt.calculate(cam);
    if (backgroundImage == true) {
      image(cam, 0, 0);
      qt.draw(20);
    } else {
      qt.draw();
    }

    // for (Quad q : qt.getQuads()) {
    //  println ("area:", q.getArea(), "||||" ,"color: (", red(q.getColor()), green(q.getColor()),  blue(q.getColor()), ")");
    // }
  }
}


void keyPressed() {
  if (Character.toUpperCase(key) == 'B') {
    backgroundImage = !backgroundImage;
  }
}
