String fileName = "stadium.asc";
String fileNameNoExt = "";
boolean csvMode = true; 
float globalScale = 1;

String[] readLines;
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> displayPoints = new ArrayList<PVector>();
Cam cam;
int densityHigh = 1;
int densityLow = 20;
int density = densityLow;
int strokeWeightHigh = 2;
int strokeWeightLow = 6;

void setup() {
  size(960, 540, P3D);
  
  String[] splits = split(fileName, ".");
  csvMode = splits[splits.length-1].toLowerCase().equals("csv");
  for (int i=0; i<splits.length-1; i++) {
    fileNameNoExt += splits[i];
  }
  
  readPointCloud();
  if (csvMode) writePointCloud();
  
  cam = new Cam();
  cam.displayText = "Press space for detail";
  
  strokeWeight(strokeWeightLow);
  stroke(255, 127);
}

void draw() {
  background(0);
  for (int i=0; i<points.size(); i+=density) {
    PVector p = displayPoints.get(i);
    point(p.x, p.y, p.z);
  }
  
  cam.run();

  surface.setTitle(""+frameRate);
}

void readPointCloud() {
  readLines = loadStrings(fileName);
  
  for (int i=0; i<readLines.length; i++) {
    String[] pointRaw;
    float x, y, z;
    if (csvMode) { // csv
      pointRaw = readLines[i].split(",");
      x = float(pointRaw[1]);
      y = float(pointRaw[2]);
      z = float(pointRaw[3]);
    } else { // asc
      pointRaw = readLines[i].split(" ");
      x = float(pointRaw[0]);
      y = float(pointRaw[1]);
      z = float(pointRaw[2]);
    }
    if (!Float.isNaN(x) && !Float.isNaN(x) && !Float.isNaN(x)) {
      points.add(new PVector(x, y, z));
      displayPoints.add(new PVector(x, -z, y).mult(globalScale));
    }
  }
  println("Read " + fileName + ".");
}

void writePointCloud() {
  String[] writeLines = new String[points.size()];
  for (int i=0; i<points.size(); i++) {
    writeLines[i] = formatPointCloudLine(points.get(i));
  }
  String url = fileNameNoExt + ".asc";
  saveStrings("data/" + url, writeLines);
  println("Wrote " + url + ".");
}

String formatPointCloudLine(PVector p) {
  String returns = p.x + " " + p.y + " " + p.z;
  return returns;
}