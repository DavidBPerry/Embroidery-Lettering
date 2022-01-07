// TODO: implement a more tunable perlin noise fill using the PEmbroiderGraphics.VECFIELD 
import processing.embroider.*;
String fileType = ".pes";
String fileName = "spiral_image"; // CHANGE ME
PEmbroiderGraphics E;
PEmbroiderGraphics E2;

int frame;

PImage img;
PImage img2;


void setup() {
  size(800, 800); //100 px = 1 cm (so 14.2 cm is 1420px)
  E = new PEmbroiderGraphics(this, width, height);
  E2 = new PEmbroiderGraphics(this, width, height);
  frameRate(30);
  img = loadImage("ModifiedR-03.png");
  img2 = loadImage("ModifiedR-02.png");
  img.loadPixels();
  E.setStitch(2,3000,0);
  E.hatchSpacing(30);
  
  E2.stroke(150,0,50);
  E2.noFill();
  E2.image(img2,0,0);
  
  
  E.fill(0);
  E.noStroke();
  E.image(img,0,0);
  E.optimize();
  
  
  E2.fill(0);
  E2.noStroke();
  E2.hatchSpacing(25);
  E2.hatchMode(E2.PARALLEL);
  E2.hatchAngle(PI/4*3);
  E2.image(img,0,0);
  E2.optimize();
  
  
  
  E2.noFill();
  E2.stroke(0,255,0);
  zigAlongFill(E2,E,0,10);
  zigAlongFill(E2,E,5,10);
  zigAlongFill(E2,E,10,5);
  zigAlongFill(E2,E,16,1);
  
  PEmbroiderWrite(E2,"SolventLace_Texture");
  
  E2.visualize();
}

void draw() {
  background(180);
  int visualInput = int(map(mouseX, 0, width, 0, ndLength(E2)));
  E2.visualize(true, true, true, visualInput);
}









/////////////////////
////// zigline helperS (FROM "dowelInset_ChairBack2")

void zigAlongFill(PEmbroiderGraphics E, PEmbroiderGraphics E_Ref,float stWidth, float stLen){
  for(ArrayList<PVector> poly: E_Ref.polylines){
    PVector P0 = poly.get(0);
    PVector P1 = poly.get(poly.size()-1);
    zigLine(E,P0,P1,stWidth, stLen);
  }
}


void zigLine(PEmbroiderGraphics E, PVector P0, PVector P1, float stWidth, float stLen) {
  zigLine(E, P0, P1, stWidth, 1, stLen);
}


void zigLine(PEmbroiderGraphics E, PVector P0, PVector P1, float stWidth, int stDir, float stLen) {
  E.setStitch(1, 1000, 0);
  float stepAmount = int(P1.copy().sub(P0).mag()/stLen);
  PVector step = P1.copy().sub(P0).div(stepAmount);
  PVector P = P0.copy();
  PVector tan = step.copy().rotate(PI/2).normalize().mult(stWidth/2.0);
  E.beginShape();
  int dir=stDir;
  for (int i = 0; i <= stepAmount; i++) {
    E.vertex(P.x+tan.x*dir, P.y+tan.y*dir);
    P.add(step);
    dir *= -1;
  }

  E.endShape();
}

void zigLineCustom(PEmbroiderGraphics E, PVector P0, PVector P1, float stWidth, int stDir, float stLen, float stitchLen) {
  E.setStitch(1, stitchLen, 0);
  float stepAmount = int(P1.copy().sub(P0).mag()/stLen);
  PVector step = P1.copy().sub(P0).div(stepAmount);
  PVector P = P0.copy();
  PVector tan = step.copy().rotate(PI/2).normalize().mult(stWidth/2);
  println(tan);
  E.beginShape();
  int dir=stDir;
  for (int i = 0; i <= stepAmount; i++) {
    E.vertex(P.x+tan.x*dir, P.y+tan.y*dir);
    P.add(step);
    dir *= -1;
  }

  E.endShape();
}

/////////////
/////////////



int ndLength(PEmbroiderGraphics E) {
  //return the total number of needle downs in the job
  int n = 0;
  for (int i=0; i<E.polylines.size(); i++) {
    n += E.polylines.get(i).size();
  }
  return n;
}


void PEmbroiderWrite(PEmbroiderGraphics E, String fileName) {
  String outputFilePath = sketchPath(fileName+timeStamp()+fileType);
  E.setPath(outputFilePath);
  E.endDraw(); // write out the file
}

String timeStamp() {
  return "D" + str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second());
}
