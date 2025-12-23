class Node {
  float x, y;
  Node[] neighbors = {};
  
  long id;
  float resources;
  float energy;
  
  Node(float x, float y) {
    this.x = x;
    this.y = y;
    
    init();
  }
  
  void init() {
    //id = x < width/2? 0 : 0xffffff;
    id = rng.nextLong();
    resources = resourceCoeff * pow(random(resourceMin, 1), -resourceExp);
    //resources *= 1 / (dist(x, y, width/2, height/2) * 0.01 + 1);
    energy = 0.5;
  }
  
  void update() {
    if (neighbors.length == 0) return;
    
    // Update energy by logistic growth
    energy += energy * (resources - energy) * growthRate;
    
    // Rebel with small probability
    if (random(1) < rebelChance) id = rng.nextLong();
    
    //int[] enemyNeighbors = {};
    //for (int i = 0; i < neighbors.length; i++)
    //  if (neighbors[i].id != id)
    //    enemyNeighbors = append(enemyNeighbors, i);
    
    //int idx = 0;
    //if (enemyNeighbors.length == 0) {
    //  idx = floor(random(neighbors.length));
    //  //for (int i : enemyNeighbors)
    //  //  if (neighbors[i].energy < neighbors[idx].energy)
    //  //    idx = i;
    //} else {
    //  //idx = enemyNeighbors[floor(random(enemyNeighbors.length))];
    //  for (int i = 0; i < neighbors.length; i++)
    //    if (neighbors[i].energy < neighbors[idx].energy)
    //      idx = i;
    //}
    
    // Get index of weakest neighbor
    int idx = 0;
    for (int i = 0; i < neighbors.length; i++)
      if (neighbors[i].energy < neighbors[idx].energy)
        idx = i;
    
    //int idx = floor(random(neighbors.length));
    
    Node other = neighbors[idx];
    
    if (id == other.id) {
      // Reinforce friendly neighbor
      float amount = (energy - other.energy) * diffuseRate;
      energy -= amount;
      other.energy += amount;
    } else {
      // Attack enemy neighbor
      float amount = other.energy * energy * attackRate;
      other.energy -= amount;
      energy += amount * attackProfit;
      
      // Capture enemy neighbor
      if (other.energy * captureThreshold < energy) other.id = id;
    }
  }
  
  void addNeighbor(Node other) {
    neighbors = (Node[]) append(neighbors, other);
  }
}
