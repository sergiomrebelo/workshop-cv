/**
 * Amazing Robots 2024
 * Introduction to Computer Vision for Creative Coding
 *
 * Quad implementation
 
 * @author Sérgio Rebelo
 * @since Jun 2024
 */

class Quad {
  PVector pos;
  float width;
  float height;
  color c;
  
  Quad (PVector pos, float width, float height, color c) {
    this.pos = pos;
    this.width = width;
    this.height = height;
    this.c = c;
  }
  
  float getArea() {
    return this.width * this.height;
  }
  
  color getColor() {
    return this.c;
  }
  
  void draw (int alfa) {
    pushMatrix();
    noStroke();
    fill(c, alfa);
    rect(pos.x, pos.y, width, height);
    popMatrix();
  }
}
