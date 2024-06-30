/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *
 * QuadTree Class
 *
 * @author Sérgio Rebelo
 * @since Jun 2024
 */

class QuadTree {
  int maxDepth; //quadtree maximum depth
  int divisionTolerance; //quadtree colour tolerance for subdivision
  PImage inputImage;
  color[][] inputImagePixels;
  ArrayList<Quad> quads = new ArrayList<Quad>();

  QuadTree (int maxDepth, int divisionTolerance) {
    this.maxDepth = maxDepth;
    this.divisionTolerance = divisionTolerance;
  }

  // calculate the quadtree
  void calculate (PImage img) {
    this.inputImage = img;
    this.inputImagePixels = new int[this.inputImage.height][this.inputImage.width];

    try {
      // save the input image for performance purposes
      this.inputImage.loadPixels();
      for (int yPixel = 0; yPixel < height; yPixel++) {
        for (int xPixel = 0; xPixel < width; xPixel++) {
          int loc = yPixel * this.inputImage.width + xPixel;
          color currColor =  this.inputImage.pixels[loc];
          inputImagePixels [yPixel][xPixel] = currColor;
        }
      }
      this.inputImage.updatePixels();
      // calculate the quads
      calculateQuads (0, 0, 0, this.inputImage.width, this.inputImage.height);
    }
    catch (Exception err) {
      println ("image not available:", err.getCause());
    }
  }

  void calculateQuads (int divisionDepth, float x, float y, float w, float h) {
    int quadX = round(x);
    int quadY = round(y);
    int quadWidth = round(w);
    int quadHeight = round(h);
    //compute the average colour of pixels in quad
    color avgColor = mean(round(x), round(y), round(w), round(h));
    divisionDepth++;
    // if the current depth is smaller than maximum
    if (divisionDepth <= maxDepth) {
      // calculate the colour distance between average and current
      float variation = getColorVariation(quadX, quadY, quadWidth, quadHeight, avgColor);
      // if the variation is bigger than tolerance threshold
      if (variation > divisionTolerance) {
        // subdive the quad in four
        w *= 0.5;
        h *= 0.5;
        calculateQuads(divisionDepth, x, y, w, h);
        calculateQuads(divisionDepth, x + w, y, w, h);
        calculateQuads(divisionDepth, x + w, y + h, w, h);
        calculateQuads(divisionDepth, x, y + h, w, h);
        return;
      }
    }
    Quad q = new Quad(new PVector (x, y), w, h, avgColor);
    quads.add(q);
  }

  // calculate the colour average
  color mean(int x, int y, int width, int height) {
    int red = 0, green = 0, blue = 0;
    for (int yPixel = y; yPixel < y + height; yPixel++) {
      for (int xPixel = x; xPixel < x + width; xPixel++) {
        color currColor = inputImagePixels [yPixel][xPixel];
        int currRed = (currColor >> 16) & 0xFF;
        int currGreen = (currColor >> 8) & 0xFF;
        int currBlue = currColor & 0xFF;
        red+=currRed;
        green+=currGreen;
        blue+=currBlue;
      }
    }
    red /= (width * height);
    green /= (width * height);
    blue /= (width * height);
    return color (red, green, blue);
  }

  // get colour variation
  float getColorVariation (int x, int y, int width, int height, int mean) {
    float variation = 0;
    for (int yPixel = y; yPixel < y + height; yPixel++) {
      for (int xPixel = x; xPixel < x + width; xPixel++) {
        float distance = colorDistance(inputImagePixels [yPixel][xPixel], mean);
        variation += distance;
      }
    }
    return (variation / (float) (width * height));
  }
  
  // calculate colour distance (RGB)
  // see https://en.wikipedia.org/wiki/Color_difference
  float colorDistance (color c1, color c2) {
    float rmean =(red(c1) + red(c2)) / 2;
    float r = red(c1) - red(c2);
    float g = green(c1) - green(c2);
    float b = blue(c1) - blue(c2);
    return sqrt((int(((512+rmean)*r*r))>>8)+(4*g*g)+(int(((767-rmean)*b*b))>>8));
  }

  // draw the quads
  void draw () {
    for (Quad q : quads) {
      q.draw(255);
    }
  }
  
  void draw (int alfa) {
    for (Quad q : quads) {
      q.draw(alfa);
    }
  }
  
  // get Quads
  ArrayList<Quad> getQuads () {
    return quads;
  }
}
