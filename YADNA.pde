import processing.pdf.*;

int rows;
int cols;
int circleRows;
int circleCols;
int radius;
int oCircleRows;
int oCircleCols;
int oradius;
float radians = PI/225; //0.01745329251994; //changeable 
float oradians = PI/18000;
String seq;
cell origin;
ArrayList<cell> bpA;
ArrayList<cell> bpT;
ArrayList<cell> bpC;
ArrayList<cell> bpG;
ArrayList<cell> obpA;
ArrayList<cell> obpT;
ArrayList<cell> obpC;
ArrayList<cell> obpG;
int start;
int visitA;
int visitT;
int visitC;
int visitG;
char[][] bpLabel;

void setup() {
  size(801, 801);            //Dimensions should be odd integers, greater than 101
  rows = height;
  cols = width;
  
  
  //201 pixel border
  circleRows = rows - 201;  //((rows - 1) - 50) - 50;
  circleCols = cols - 201;  //((cols - 1) - 50) - 50;
  
  //Create a border
  //oCircleRows = rows - 151;
  //oCircleCols = cols - 151;
  oradius = oCircleRows / 2;
  
  radius  = circleRows / 2;
  origin  = new cell((rows - 1)/2, (cols - 1)/2);
  bpLabel = new char[rows][cols];
  background(0);
  
  //Input DNA sequence
  //seq1 = loadStrings("sequence.rtf");
  //seq = "atgaccgaatataaactggtggtggtgggcgcgggcggcgtgggcaaaagcgcgctgaccattcagctgattcagaaccattttgtggatgaatatgatccgaccattgaagatagctatcgcaaacaggtggtgattgatggcgaaacctgcctgctggatattctggataccgcgggccaggaagaatatagcgcgatgcgcgatcagtatatgcgcaccggcgaaggctttctgtgcgtgtttgcgattaacaacaccaaaagctttgaagatattcatcagtatcgcgaacagattaaacgcgtgaaagatagcgatgatgtgccgatggtgctggtgggcaacaaatgcgatctggcggcgcgcaccgtggaaagccgccaggcgcaggatctggcgcgcagctatggcattccgtatattgaaaccagcgcgaaaacccgccagggcgtggaagatgcgttttataccctggtgcgcgaaattcgccagcataaactgcgcaaactgaacccgccggatgaaagcggcccgggctgcatgagctgcaaatgcgtgctgagc";
  seq = "ATGGAACTGGCGGCGCTGTGCCGCTGGGGCCTGCTGCTGGCGCTGCTGCCGCCGGGCGCGGCGAGCACCCAGGTGTGCACCGGCACCGATATGAAACTGCGCCTGCCGGCGAGCCCGGAAACCCATCTGGATATGCTGCGCCATCTGTATCAGGGCTGCCAGGTGGTGCAGGGCAACCTGGAACTGACCTATCTGCCGACCAACGCGAGCCTGAGCTTTCTGCAGGATATTCAGGAAGTGCAGGGCTATGTGCTGATTGCGCATAACCAGGTGCGCCAGGTGCCGCTGCAGCGCCTGCGCATTGTGCGCGGCACCCAGCTGTTTGAAGATAACTATGCGCTGGCGGTGCTGGATAACGGCGATCCGCTGAACAACACCACCCCGGTGACCGGCGCGAGCCCGGGCGGCCTGCGCGAACTGCAGCTGCGCAGCCTGACCGAAATTCTGAAAGGCGGCGTGCTGATTCAGCGCAACCCGCAGCTGTGCTATCAGGATACCATTCTGTGGAAAGATATTTTTCATAAAAACAACCAGCTGGCGCTGACCCTGATTGATACCAACCGCAGCCGCGCGTGCCATCCGTGCAGCCCGATGTGCAAAGGCAGCCGCTGCTGGGGCGAAAGCAGCGAAGATTGCCAGAGCCTGACCCGCACCGTGTGCGCGGGCGGCTGCGCGCGCTGCAAAGGCCCGCTGCCGACCGATTGCTGCCATGAACAGTGCGCGGCGGGCTGCACCGGCCCGAAACATAGCGATTGCCTGGCGTGCCTGCATTTTAACCATAGCGGCATTTGCGAACTGCATTGCCCGGCGCTGGTGACCTATAACACCGATACCTTTGAAAGCATGCCGAACCCGGAAGGCCGCTATACCTTTGGCGCGAGCTGCGTGACCGCGTGCCCGTATAACTATCTGAGCACCGATGTGGGCAGCTGCACCCTGGTGTGCCCGCTGCATAACCAGGAAGTGACCGCGGAAGATGGCACCCAGCGCTGCGAAAAATGCAGCAAACCGTGCGCGCGCGTGTGCTATGGCCTGGGCATGGAACATCTGCGCGAAGTGCGCGCGGTGACCAGCGCGAACATTCAGGAATTTGCGGGCTGCAAAAAAATTTTTGGCAGCCTGGCGTTTCTGCCGGAAAGCTTTGATGGCGATCCGGCGAGCAACACCGCGCCGCTGCAGCCGGAACAGCTGCAGGTGTTTGAAACCCTGGAAGAAATTACCGGCTATCTGTATATTAGCGCGTGGCCGGATAGCCTGCCGGATCTGAGCGTGTTTCAGAACCTGCAGGTGATTCGCGGCCGCATTCTGCATAACGGCGCGTATAGCCTGACCCTGCAGGGCCTGGGCATTAGCTGGCTGGGCCTGCGCAGCCTGCGCGAACTGGGCAGCGGCCTGGCGCTGATTCATCATAACACCCATCTGTGCTTTGTGCATACCGTGCCGTGGGATCAGCTGTTTCGCAACCCGCATCAGGCGCTGCTGCATACCGCGAACCGCCCGGAAGATGAATGCGTGGGCGAAGGCCTGGCGTGCCATCAGCTGTGCGCGCGCGGCCATTGCTGGGGCCCGGGCCCGACCCAGTGCGTGAACTGCAGCCAGTTTCTGCGCGGCCAGGAATGCGTGGAAGAATGCCGCGTGCTGCAGGGCCTGCCGCGCGAATATGTGAACGCGCGCCATTGCCTGCCGTGCCATCCGGAATGCCAGCCGCAGAACGGCAGCGTGACCTGCTTTGGCCCGGAAGCGGATCAGTGCGTGGCGTGCGCGCATTATAAAGATCCGCCGTTTTGCGTGGCGCGCTGCCCGAGCGGCGTGAAACCGGATCTGAGCTATATGCCGATTTGGAAATTTCCGGATGAAGAAGGCGCGTGCCAGCCGTGCCCGATTAACTGCACCCATAGCTGCGTGGATCTGGATGATAAAGGCTGCCCGGCGGAACAGCGCGCGAGCCCGCTGACCAGCATTATTAGCGCGGTGGTGGGCATTCTGCTGGTGGTGGTGCTGGGCGTGGTGTTTGGCATTCTGATTAAACGCCGCCAGCAGAAAATTCGCAAATATACCATGCGCCGCCTGCTGCAGGAAACCGAACTGGTGGAACCGCTGACCCCGAGCGGCGCGATGCCGAACCAGGCGCAGATGCGCATTCTGAAAGAAACCGAACTGCGCAAAGTGAAAGTGCTGGGCAGCGGCGCGTTTGGCACCGTGTATAAAGGCATTTGGATTCCGGATGGCGAAAACGTGAAAATTCCGGTGGCGATTAAAGTGCTGCGCGAAAACACCAGCCCGAAAGCGAACAAAGAAATTCTGGATGAAGCGTATGTGATGGCGGGCGTGGGCAGCCCGTATGTGAGCCGCCTGCTGGGCATTTGCCTGACCAGCACCGTGCAGCTGGTGACCCAGCTGATGCCGTATGGCTGCCTGCTGGATCATGTGCGCGAAAACCGCGGCCGCCTGGGCAGCCAGGATCTGCTGAACTGGTGCATGCAGATTGCGAAAGGCATGAGCTATCTGGAAGATGTGCGCCTGGTGCATCGCGATCTGGCGGCGCGCAACGTGCTGGTGAAAAGCCCGAACCATGTGAAAATTACCGATTTTGGCCTGGCGCGCCTGCTGGATATTGATGAAACCGAATATCATGCGGATGGCGGCAAAGTGCCGATTAAATGGATGGCGCTGGAAAGCATTCTGCGCCGCCGCTTTACCCATCAGAGCGATGTGTGGAGCTATGGCGTGACCGTGTGGGAACTGATGACCTTTGGCGCGAAACCGTATGATGGCATTCCGGCGCGCGAAATTCCGGATCTGCTGGAAAAAGGCGAACGCCTGCCGCAGCCGCCGATTTGCACCATTGATGTGTATATGATTATGGTGAAATGCTGGATGATTGATAGCGAATGCCGCCCGCGCTTTCGCGAACTGGTGAGCGAATTTAGCCGCATGGCGCGCGATCCGCAGCGCTTTGTGGTGATTCAGAACGAAGATCTGGGCCCGGCGAGCCCGCTGGATAGCACCTTTTATCGCAGCCTGCTGGAAGATGATGATATGGGCGATCTGGTGGATGCGGAAGAATATCTGGTGCCGCAGCAGGGCTTTTTTTGCCCGGATCCGGCGCCGGGCGCGGGCGGCATGGTGCATCATCGCCATCGCAGCAGCAGCACCCGCAGCGGCGGCGGCGATCTGACCCTGGGCCTGGAACCGAGCGAAGAAGAAGCGCCGCGCAGCCCGCTGGCGCCGAGCGAAGGCGCGGGCAGCGATGTGTTTGATGGCGATCTGGGCATGGGCGCGGCGAAAGGCCTGCAGAGCCTGCCGACCCATGATCCGAGCCCGCTGCAGCGCTATAGCGAAGATCCGACCGTGCCGCTGCCGAGCGAAACCGATGGCTATGTGGCGCCGCTGACCTGCAGCCCGCAGCCGGAATATGTGAACCAGCCGGATGTGCGCCCGCAGCCGCCGAGCCCGCGCGAAGGCCCGCTGCCGGCGGCGCGCCCGGCGGGCGCGACCCTGGAACGCCCGAAAACCCTGAGCCCGGGCAAAAACGGCGTGGTGAAAGATGTGTTTGCGTTTGGCGGCGCGGTGGAAAACCCGGAATATCTGACCCCGCAGGGCGGCGCGGCGCCGCAGCCGCATCCGCCGCCGGCGTTTAGCCCGGCGTTTGATAACCTGTATTATTGGGATCAGGATCCGCCGGAACGCGGCGCGCCGCCGAGCACCTTTAAAGGCACCCCGACCGCGGAAAACCCGGAATATCTGGGCCTGGATGTGCCGGTG";
  seq = seq.toUpperCase();
  //Label circumference
  bpA = labelA();
  bpT = labelT();
  bpC = labelC();
  bpG = labelG();
  
  labelPoints(bpA);
  labelPoints(bpT);
  labelPoints(bpC);
  labelPoints(bpG);
  
  //Outside label
  obpA = labelOA();
  obpT = labelOT();
  obpC = labelOC();
  obpG = labelOG();
  
  labelPoints(obpA);
  labelPoints(obpT);
  labelPoints(obpC);
  labelPoints(obpG);
  
  start  = 0;
  visitA = 0;
  visitT = 0;
  visitC = 0;
  visitG = 0;
  for (int n = 0; n < int((PI/2)/oradians); n++) {
    displayPoints(obpA, n);
    displayPoints(obpT, n);
    displayPoints(obpC, n);
    displayPoints(obpG, n);
  }
  frameRate(100);
  //beginRecord(PDF, "Visualized DNA.pdf");
  
  
}

void draw() { 
  int x = 0;
  int y = 0;
  if (selectArrayList(start).equals(bpA)) {
    x = visitA;
  }
  else if (selectArrayList(start).equals(bpT)) {
    x = visitT;
  }
  else if (selectArrayList(start).equals(bpC)) {
    x = visitC;
  }
  else if (selectArrayList(start).equals(bpG)) {
    x = visitG;
  }
  
  if (selectArrayList(start + 1).equals(bpA)) {
    y = visitA;
  }
  else if (selectArrayList(start + 1).equals(bpT)) {
    y = visitT;
  }
  else if (selectArrayList(start + 1).equals(bpC)) {
    y = visitC;
  }
 else  if (selectArrayList(start + 1).equals(bpG)) {
    y = visitG;
  }
  drawLine(selectCell(selectArrayList(start), x), selectCell(selectArrayList(start + 1), y));
  if (selectArrayList(start).equals(bpA)) {
    visitA++;
  }
  else if (selectArrayList(start).equals(bpT)) {
    visitT++;
  }
  else if (selectArrayList(start).equals(bpC)) {
    visitC++;
  }
  else if (selectArrayList(start).equals(bpG)) {
    visitG++;
  }
  start = start + 1; 
  if (start + 1 == seq.length()) {
    //comment in to save pdf
    //endRecord();
    //exit();
    noLoop();
  }
}

//object cell to represent pixels
class cell {
  int x; 
  int y;
  cell(int row, int col) {
    x = row; 
    y = col;
  }
  int getR() {
    return x;
  }
  int getC() {
    return y;
  }
}

class colorNew {
  int r;
  int g;
  int b;
  colorNew(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
  }
  int getRed() {
    return r;
  }
  int getGreen() {
    return g;
  }
  int getBlue() {
    return b;
  }
}

//Assigns inner circle point circumference
ArrayList<cell> labelA() {
  ArrayList<cell> A = new ArrayList<cell>();
  for (int n = int((PI/2)/radians) - 0; n >= 0 ; n--) {
    int xDiff = int (radius * cos(n *radians));
    int yDiff = int (radius * sin(n * radians));
    cell newCell = new cell(origin.getR() + yDiff, origin.getC() - xDiff);
    A.add(newCell);
  }
  return A;
}
ArrayList<cell> labelT() {
  ArrayList<cell> T = new ArrayList<cell>();
  for (int n = int((PI/2)/radians) - 0; n >= 0 ; n--) {
    int xDiff = int (radius * cos(n * radians));
    int yDiff = int (radius * sin(n * radians));
    cell newCell = new cell(origin.getR() - yDiff, origin.getC() + xDiff);
    T.add(newCell);
  }
  return T;
}
ArrayList<cell> labelC() {
  ArrayList<cell> C = new ArrayList<cell>();
  for (int n = 0; n <= (PI/2)/radians; n++) {
    int xDiff = int (radius * cos(n * radians));
    int yDiff = int (radius * sin(n * radians));
    cell newCell = new cell(origin.getR() - yDiff, origin.getC() - xDiff);
    C.add(newCell);
  }
  return C;
}
ArrayList<cell> labelG() {
  ArrayList<cell> G = new ArrayList<cell>();
  for (int n = 0; n <= (PI/2)/radians; n++) {
    int xDiff = int (radius * cos(n * radians));
    int yDiff = int (radius * sin(n * radians));
    cell newCell = new cell(origin.getR() + yDiff, origin.getC() + xDiff);
    G.add(newCell);
  }
  return G;
}

//Assigns coordinates for outer circle
ArrayList<cell> labelOA() {
  ArrayList<cell> A = new ArrayList<cell>();
  for (int n = int((PI/2)/oradians) - 0; n >= 0 ; n--) {
    int xDiff = int (oradius * cos(n * oradians));
    int yDiff = int (oradius * sin(n * oradians));
    cell newCell = new cell(origin.getR() + yDiff, origin.getC() - xDiff);
    A.add(newCell);
  }
  return A;
}
ArrayList<cell> labelOT() {
  ArrayList<cell> T = new ArrayList<cell>();
  for (int n = int((PI/2)/oradians) - 1; n >= 0 ; n--) {
    int xDiff = int (oradius * cos(n * oradians));
    int yDiff = int (oradius * sin(n * oradians));
    cell newCell = new cell(origin.getR() - yDiff, origin.getC() + xDiff);
    T.add(newCell);
  }
  return T;
}
ArrayList<cell> labelOC() {
  ArrayList<cell> C = new ArrayList<cell>();
  for (int n = 0; n < (PI/2)/oradians; n++) {
    int xDiff = int (oradius * cos(n * oradians));
    int yDiff = int (oradius * sin(n * oradians));
    cell newCell = new cell(origin.getR() - yDiff, origin.getC() - xDiff);
    C.add(newCell);
  }
  return C;
}
ArrayList<cell> labelOG() {
  ArrayList<cell> G = new ArrayList<cell>();
  for (int n = 0; n < (PI/2)/oradians; n++) {
    int xDiff = int (oradius * cos(n * oradians));
    int yDiff = int (oradius * sin(n * oradians));
    cell newCell = new cell(origin.getR() + yDiff, origin.getC() + xDiff);
    G.add(newCell);
  }
  return G;
}

void displayPoints(ArrayList<cell> test, int n) {
  if (test.equals(obpA)) {
    stroke(255,0,0);
  }
  if (test.equals(obpT)) {
    stroke(255,255,0);
  }
  if (test.equals(obpC)) {
    stroke(0,255,0);
  }
  if (test.equals(obpG)) {
    stroke(0,0,255);
  }
  strokeWeight(1);
  point(test.get(n).getR(), test.get(n).getC());
}

void labelPoints(ArrayList<cell> test) {
  for (int n = 0; n < test.size(); n++) {
    if (test == bpA) {
      bpLabel[test.get(n).getR()][test.get(n).getC()] = 'A';
    }
    if (test == bpT) {
      bpLabel[test.get(n).getR()][test.get(n).getC()] = 'T';
    }
    if (test == bpC) {
      bpLabel[test.get(n).getR()][test.get(n).getC()] = 'C';
    }
    if (test == bpG) {
      bpLabel[test.get(n).getR()][test.get(n).getC()] = 'G';
    }
  }
}

ArrayList<cell> selectArrayList(int n) {
  ArrayList<cell> selection = new ArrayList<cell>();
  if (seq.charAt(n) == 'A') {
    selection = bpA;
  }
  if (seq.charAt(n) == 'T') {
    selection = bpT;
  }
  if (seq.charAt(n) == 'C') {
    selection = bpC;
  }
  if (seq.charAt(n) == 'G') {
    selection = bpG;
  }
  return selection;
}

//Want to change point visited
//ex.) Visited once already, cell selected = 2nd element
cell selectCell(ArrayList<cell> a, int visits) {
  return a.get(visits%int((PI/2)/radians));
}

//Making pretty colors...
colorNew getCellColor(cell a) {
  colorNew c = new colorNew(0,0,0);
  if (bpLabel[a.getR()][a.getC()] == 'A') {
    c = new colorNew((int)(random(255,500)),0,0);
  }
  if (bpLabel[a.getR()][a.getC()] == 'T') {
    c = new colorNew(0,(int)(random(255,500)),0);
  }
  if (bpLabel[a.getR()][a.getC()] == 'C') {
    c = new colorNew((int)(random(255,500)),(int)(random(255,500)),0);
  }
  if (bpLabel[a.getR()][a.getC()] == 'G') {
    c = new colorNew(0,0,(int)(random(255,500)));
  }
  return c;
}
void selectLineColor(cell x, cell y) {
  colorNew cX = getCellColor(x);
  colorNew cY = getCellColor(y);
  int r = cX.getRed();
  int g = cX.getGreen();
  int b = cX.getBlue();
  int r1 = cY.getRed();
  int g1 = cY.getGreen();
  int b1 = cY.getBlue();
  //comment in for blended colors
  stroke((r + r1)/2, (g + g1)/2, (b + b1)/2);
  //stroke(r, g, b);
  //stroke(120);
}
  
void drawLine(cell a, cell b) {
  int r = a.getR();
  int c = a.getC();
  int r1 = b.getR();
  int c1 = b.getC();
  strokeWeight(0.5);
  selectLineColor(a, b);
  line(r, c, r1, c1);
}

