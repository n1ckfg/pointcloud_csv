String fileName = "stadium.csv";
String[] readLines;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> displayPoints = new ArrayList<PVector>();
Cam cam;
int densityHigh = 1;
int densityLow = 20;
int density = densityLow;
PFont font;
int fontSize = 12;

void setup() {
  size(640, 480, P3D);
  font = createFont("Arial", fontSize);
  textFont(font, fontSize);
  
  readPointCloud();
  writePointCloud();
  
  cam = new Cam();
  
  strokeWeight(2);
  stroke(255, 127);
}

void draw() {
  background(0);
  for (int i=0; i<points.size(); i+=density) {
    PVector p = displayPoints.get(i);
    point(p.x, p.y, p.z);
  }
  
  cam.run();
    
  pushMatrix();  
  translate((cam.pos.x - (width/2)) + (fontSize/2), (cam.pos.y - (height/2)) + fontSize, cam.poi.z);
  text("Press space for detail", 0, 0);
  popMatrix();
  
  surface.setTitle(""+frameRate);
}

void readPointCloud() {
  readLines = loadStrings(fileName);
  
  for (int i=0; i<readLines.length; i++) {
    String[] pointRaw = readLines[i].split(",");
    float x = float(pointRaw[1]);
    float y = float(pointRaw[2]);
    float z = float(pointRaw[3]);
    if (!Float.isNaN(x) && !Float.isNaN(x) && !Float.isNaN(x)) {
      points.add(new PVector(x, y, z));
      displayPoints.add(new PVector(x, -z, y));
    }
  }
  println("Read " + fileName + ".");
}

void writePointCloud() {
  String[] writeLines = new String[points.size()];
  for (int i=0; i<points.size(); i++) {
    writeLines[i] = formatPointCloudLine(points.get(i));
  }
  String url = fileName + ".asc";
  saveStrings("data/" + url, writeLines);
  println("Wrote " + url + ".");
}

String formatPointCloudLine(PVector p) {
  String returns = p.x + " " + p.y + " " + p.z;
  return returns;
}