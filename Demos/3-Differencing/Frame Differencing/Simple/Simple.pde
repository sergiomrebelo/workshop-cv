/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *aaaaaaaaaa
 * Frame Differencing
 * Quantify the amount of movement in the video frame using frame-differencing.
 *
 * @authors: Sérgio M. Rebelo
 * @since:   Jun 2024
 * @based:   Golan Levin's Background Subtraction
 */
import processing.video.*;

Capture cam;
PImage previous;
int threshold = 10;
boolean brightnessMode = false;

void setup() {
  size(640, 480);

  String[] devices = Capture.list();

  if (devices.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }

  cam = new Capture(this, 640, 480, devices[0]);
  cam.start();

  previous = new PImage (cam.width, cam.height, ARGB);
}

void draw() {
  if (cam.available()) {
    background(0);
    PImage dif = new PImage (cam.width, cam.height, ARGB);

    cam.read();
    cam.loadPixels();
    dif.loadPixels();

    for (int i = 0; i < cam.pixels.length; i++) {
      color current = cam.pixels[i];
      color prev = previous.pixels[i];
      int movement = 0;
      color res = color(0);
      
      if (brightnessMode == true) {
        movement = (int) abs(brightness(current)-brightness(prev));
        res = color(movement);
      } else {
        int diffR = (int) abs(red (current) - red (prev));
        int diffG = (int) abs(green (current) - green (prev));
        int diffB = (int) abs(blue (current) - blue (prev));
        movement = diffR + diffG + diffB;
        res = color(diffR, diffG, diffB);
      }
      
      if (movement > threshold) {
        dif.pixels[i] = res;
      }
    }
    previous = cam.copy();
    dif.updatePixels();
    image (dif, 0, 0);
  }
}

void keyPressed() {
  if (str(key).equalsIgnoreCase("B")) {
    brightnessMode = !brightnessMode;
  }
}
