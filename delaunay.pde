import java.util.Arrays;

ArrayList<int[]> bowyerWatson(PVector[] points) {
  // Create a super triangle that contains all points
  float minX = Float.MAX_VALUE, maxX = -Float.MAX_VALUE;
  float minY = Float.MAX_VALUE, maxY = -Float.MAX_VALUE;
  for (PVector p : points) {
      minX = Math.min(minX, p.x);
      maxX = Math.max(maxX, p.x);
      minY = Math.min(minY, p.y);
      maxY = Math.max(maxY, p.y);
  }
  
  float dx = maxX - minX;
  float dy = maxY - minY;
  float dmax = max(dx, dy);
  float midx = (minX + maxX) / 2;
  float midy = (minY + maxY) / 2;
  
  PVector[] superTriangle = {
      new PVector(midx - 20 * dmax, midy - dmax),
      new PVector(midx, midy + 20 * dmax),
      new PVector(midx + 20 * dmax, midy - dmax)
  };
  
  ArrayList<PVector> allPoints = new ArrayList<>();
  allPoints.addAll(Arrays.asList(superTriangle));
  allPoints.addAll(Arrays.asList(points));
  
  ArrayList<int[]> triangles = new ArrayList<>();
  triangles.add(new int[]{0, 1, 2});
  
  for (int i = 3; i < allPoints.size(); i++) {
      PVector p = allPoints.get(i);
      ArrayList<int[]> badTriangles = new ArrayList<>();
      
      for (int[] tri : triangles) {
        PVector a = allPoints.get(tri[0]);
        PVector b = allPoints.get(tri[1]);
        PVector c = allPoints.get(tri[2]);
        if (inCircumcircle(p, a, b, c)) badTriangles.add(tri);
      }
      
      HashMap<String, int[]> edgeMap = new HashMap<>();
      for (int[] tri : badTriangles) {
        for (int j = 0; j < 3; j++) {
          int u = tri[j], v = tri[(j + 1) % 3];
          int min = Math.min(u, v), max = Math.max(u, v);
          String edgeKey = str(min) + "," + str(max);
          
          if (edgeMap.containsKey(edgeKey)) edgeMap.remove(edgeKey);
          else edgeMap.put(edgeKey, new int[] {u, v});
        }
      }
      
      triangles.removeAll(badTriangles);
      
      for (int[] edge : edgeMap.values())
        triangles.add(new int[] {edge[0], edge[1], i});
  }
  
  // Remove triangles with supertriangle vertices
  ArrayList<int[]> result = new ArrayList<>();
  for (int[] tri : triangles)
    if (tri[0] >= 3 && tri[1] >= 3 && tri[2] >= 3)
      result.add(new int[] {tri[0] - 3, tri[1] - 3, tri[2] - 3});
  
  return result;
}

boolean inCircumcircle(PVector p, PVector a, PVector b, PVector c) {
  float ax = a.x - p.x;
  float ay = a.y - p.y;
  float bx = b.x - p.x;
  float by = b.y - p.y;
  float cx = c.x - p.x;
  float cy = c.y - p.y;

  float det = (bx * bx + by * by) * (ax * cy - cx * ay) -
              (ax * ax + ay * ay) * (bx * cy - cx * by) -
              (cx * cx + cy * cy) * (ax * by - bx * ay);
  
  return det > 0;
}
