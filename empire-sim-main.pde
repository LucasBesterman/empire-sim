import java.util.Random;
Random rng = new Random();

final int numNodes = 2_000;
final int stepsPerFrame = 50_000;

final float resourceCoeff = 0.2;
final float resourceMin = 0.0005;
final float resourceExp = 0.7;

final float attackRate = 0.01;
final float growthRate = 0.01;
final float diffuseRate = 0.15;
final float attackProfit = 0.5;
final float captureThreshold = 3;
final float rebelChance = 0.000001;

Node[] nodes;
int[][] voronoiMap;

PGraphics bg;
int displayMode = 0;
boolean active = true;

void setup() {
  size(800, 800);
  colorMode(HSB);
  
  initNodes();
}

void draw() {
  if (!active) return;
  updateDisplay();
  
  for (int s = 0; s < stepsPerFrame; s++) {
    Node randNode = nodes[floor(random(numNodes))];
    randNode.update();
  }
}

void keyPressed() {
  if (key == ' ') active = !active;
  else if (key == '1' || key == '2' || key == '3' || key == '4') {
    displayMode = int(str(key)) - 1;
    updateDisplay();
  }
  else if (key == 'r') {
    for (Node node : nodes) node.init();
    updateDisplay();
  }
}

void updateDisplay() {
  if (displayMode < 2) {
    loadPixels();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        Node n = nodes[voronoiMap[x][y]];
        float bri = 255 * (1 - exp(-n.energy * 2));
        pixels[x + y*width] = color(n.id & 0xFF, (n.id >> 8) & 0xFF, bri);
      }
    }
    updatePixels();
    
    if (displayMode == 1) {
      stroke(0);
      noFill();
      
      for (Node node : nodes)
        if (node.resources > 1)
          circle(node.x, node.y, node.resources * 5);
    }
  } else {
    background(0);
    if (displayMode == 3) background(bg);
    
    for (Node node : nodes) {
      color displayColor = color(node.id & 0xFF, (node.id >> 8) & 0xFF, 255);
      
      noStroke();
      if (displayMode == 3 && node.resources > 0.25) {
        fill(displayColor, 32);
        circle(node.x, node.y, node.resources * 20);
      }
      fill(displayColor, 128);
      circle(node.x, node.y, node.energy * 20);
    }
  }
  
  float totalEnergy = 0;
  for (Node node : nodes) totalEnergy += node.energy;
  
  fill(255);
  text("e=" + int(totalEnergy), 0, 10);
}

void initNodes() {
  PVector[] pos = new PVector[numNodes];
  for (int i = 0; i < numNodes; i++)
    pos[i] = new PVector(random(10, width-10), random(10, height-10));
  
  nodes = new Node[numNodes];
  for (int i = 0; i < numNodes; i++)
    nodes[i] = new Node(pos[i].x, pos[i].y);
  
  voronoiMap = new int[width][height];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int closest = -1;
      float dist = Float.POSITIVE_INFINITY;
      
      for (int i = 0; i < numNodes; i++) {
        float d = dist(x, y, nodes[i].x, nodes[i].y);
        if (d < dist) {
          closest = i;
          dist = d;
        }
      }
      
      voronoiMap[x][y] = closest;
    }
  }
  
  bg = createGraphics(width, height);
  bg.beginDraw();
  bg.stroke(255, 16);
  bg.strokeWeight(2);
  bg.background(0);
  
  ArrayList<int[]> triangles = bowyerWatson(pos);
  for (int[] tri : triangles) {
    for (int i = 0; i < 3; i++) {
      int a = tri[i];
      int b = tri[(i + 1) % 3];
      nodes[a].addNeighbor(nodes[b]);
      nodes[b].addNeighbor(nodes[a]);
      
      bg.line(nodes[a].x, nodes[a].y, nodes[b].x, nodes[b].y);
    }
  }
  
  bg.endDraw();
}
