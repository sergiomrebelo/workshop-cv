/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *
 * Capture Processing Boilerplate
 * Reading and displaying an image from 
 * an attached Capture device.
 *
 * @authors: Sérgio M. Rebelo
 * @since:   Jun 2024
 * @based:   Processing Video example
 */

import processing.video.*;

Capture cam;

void setup() {
  size(1280, 720);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    cam = new Capture(this, 1280, 720, cameras[1], 30);
    cam.start();
  }
  frameRate(60);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    image(cam, 0, 0);
  }
}
