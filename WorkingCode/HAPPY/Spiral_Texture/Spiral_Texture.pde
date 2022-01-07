// TODO: implement a more tunable perlin noise fill using the PEmbroiderGraphics.VECFIELD 
import processing.embroider.*;
String fileType = ".pes";
String fileName = "spiral_image"; // CHANGE ME
PEmbroiderGraphics E;

int frame;

 PImage img;



void setup() {
  size(800, 800); //100 px = 1 cm (so 14.2 cm is 1420px)
  PEmbroiderStart();
  noLoop();
  img = loadImage("P_Standard-02.png");
  img.loadPixels();
  
  drawBlackAndWhite();
}



void drawBlackAndWhite(){
  background(255);
  E.pushMatrix();
  E.translate(width/2, height/2);
  float theta = 1;
  float stepLen = 2;
  int steps = 1000*20;
  E.stroke(0);
  E.setStitch(10, 40, 0);
  E.beginShape();
  for (int i=1; i<=steps; i++) {
    float r = theta*1.8;
    float thetaStep = stepLen/r;
    PVector coord = radi2card(r+offset2(r, theta, i), theta);
    E.vertex(coord.x, coord.y);
    theta+= thetaStep;
  }
  E.endShape();
  E.popMatrix();
  E.visualize(true,true,true);
  E.endDraw();
}


float getPixelBrightness(PImage img, int x, int y){
  int loc = x + y*img.width;
  float b = brightness((img.pixels[loc]));
  return b;    
}

float offset(float r, float theta, int i) {
  PVector coord = radi2card(r,theta).add(new PVector(width/2,height/2));
  float bright = getPixelBrightness(img,int(coord.x),int(coord.y));
  float off = (300-bright)/300*5;
  if (i%2 == 0) {
    return -1*off;
  }
  return off;
}


float offset2(float r, float theta, int i) {
  PVector coord = radi2card(r,theta).add(new PVector(width/2,height/2));
  float bright = getPixelBrightness(img,int(coord.x),int(coord.y));
  float off = bright/255*5;
  if (i%2 == 0) {
    return -1*off;
  }
  return off;
}

void PEmbroiderStart() {
  E = new PEmbroiderGraphics(this, width, height);
  String outputFilePath = sketchPath(fileName+fileType);
  E.setPath(outputFilePath);
  E.setStitch(8, 14, 0);
}




PVector radi2card(float r, float th) {
  PVector card = new PVector(0, r);
  return card.rotate(th);
}
