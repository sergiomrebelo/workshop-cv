/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *
 * Brightness Tracking
 * Tracks the brightest pixel in a live video signal.
 *
 * @authors: Sérgio M. Rebelo
 * @since:   Jun 2024
 * @based:   Golan Levin's Brightness Tracking
 */

import processing.video.*;
Capture cam;

PImage frame, m;
boolean show = false;
int mode = 0;


void setup() {
  size(640, 480);

  String[] devices = Capture.list();
  // printArray(devices);

  if (devices.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }

  cam = new Capture(this, 640, 480, devices[1]);
  cam.start();

  noStroke();
  smooth();

  // frame = loadImage("sample-image.jpg");
  // frame.resize(width, 0);
  // surface.setSize(frame.width, frame.height);
}

void draw() {
  if (cam.available()) {
    cam.read();
    frame = cam.copy();

    // brightness map
    m = new PImage(frame.width, frame.height, ARGB);
    frame.loadPixels();
    m.loadPixels();
    for (int i = 0; i <  m.pixels.length; i++) {
      m.pixels[i] = color(brightness(frame.pixels[i]));
    }
    m.updatePixels();

    PVector brightest = new PVector (-1, -1);
    if (mode == 1) {
      brightest = brightestPointAbsolute(m);
    } else if (mode == 2) {
      brightest = brightestPointArea(m, 10);
    }

    if (show) {
      image (m, 0, 0);
    } else {
      image(frame, 0, 0, width, height);
    }

    // brightest pixel
    fill(255, 0, 255);
    circle(brightest.x, brightest.y, 10);
  }
}


// Compute the brightest point (area)
PVector brightestPointArea(PImage brightnessMap, int w) {
  PVector brightest = new PVector (-1, -1);
  float max = -1;

  brightnessMap.loadPixels();
  for (int y = w/2; y < brightnessMap.height-w/2; y+=w/2) {
    for (int x = w/2; x < brightnessMap.width-w/2; x+=w/2) {
      float b = brightnessAvgArea(brightnessMap, x, y, w);
      if (b > max) {
        max = b;
        brightest.y = y;
        brightest.x = x;
      }
    }
  }
  brightnessMap.updatePixels();
  return brightest;
}


// Average brightness of a area
float brightnessAvgArea (PImage img, int x, int y, int w) {
  int x0 = max(0, x-w/2), x1 = min(img.width, x+w/2);
  int y0 = max(0, y-w/2), y1 = min(img.height, y+w/2);
  int numPixels = (x1-x0)*(y1-y0);
  float bm=0;
  for (int xi = x0; xi < x1; xi++) {
    for (int yi = y0; yi < y1; yi++) {
      float b = brightness(img.get(xi, yi));
      bm += b;
    }
  }
  return bm/numPixels;
}



// Compute the brightest point (absolute)
PVector brightestPointAbsolute (PImage brightnessMap) {
  PVector brightest = new PVector (-1, -1);
  float max = -1;

  brightnessMap.loadPixels();
  for (int y = 0; y < brightnessMap.height; y++) {
    for (int x = 0; x < brightnessMap.width; x++) {
      int loc = x + y * brightnessMap.width;
      // Determine the brightness of the pixel
      float current = brightness(brightnessMap.pixels[loc]);
      if (current > max) {
        max = current;
        brightest.y = y;
        brightest.x = x;
      }
    }
  }

  brightnessMap.updatePixels();
  return brightest;
}

void keyPressed() {
  if (key == '1') {
    mode = 1;
  } else if (key == '2') {
    mode = 2;
  } else {
    mode = 0;
  }
}

void mousePressed () {
  show = !show;
}
