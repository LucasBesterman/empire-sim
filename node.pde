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
    id = rng.nextLong();
    resources = resourceCoeff * pow(random(resourceMin, 1), -resourceExp);
    energy = 0.5;
  }
  
  void update() {
    if (neighbors.length == 0) return;
    
    // Update energy by logistic growth
    energy += energy * (resources - energy) * growthRate;
    
    // Rebel with small probability
    if (random(1) < rebelChance) id = rng.nextLong();
    
    // Get index of weakest neighbor
    int idx = 0;
    for (int i = 0; i < neighbors.length; i++)
      if (neighbors[i].energy < neighbors[idx].energy)
        idx = i;
    
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
