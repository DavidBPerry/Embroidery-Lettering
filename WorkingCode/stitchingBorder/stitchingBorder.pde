import processing.embroider.*;
PEmbroiderGraphics E;

void setup(){
  size(900,900);
  E = new PEmbroiderGraphics(this, width, height);
  E.setPath(sketchPath("Hello_PEmbroider.pes"));
  E.beginDraw();
  E.setStitch(5,40,0);
  E.rectMode(CENTER);
  E.stroke(0,255,0);
  E.rect(width/2,height/2,800,800);
  E.stroke(255,0,0);
  E.strokeMode(E.PERPENDICULAR);
  E.strokeLocation(E.OUTSIDE);
  E.strokeSpacing(3);
  E.strokeWeight(10);
  E.rect(width/2,height/2,800,800);
  
  E.visualize();
  E.endDraw();
}

void draw(){
  background(180);
  E.visualize(true,true,true,frameCount);
}
