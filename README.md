# empire-sim
Work-in-progress simulation of imperial dynamics.

The simulation involves different empires (differently colored regions) fighting over land, represented by nodes on an irregular lattice. Each node possesses "energy", a value representing its military strength. Energy is divided among friendly neighbors and stolen by enemies. An enemy node may capture another node if the ratio of energies falls below a threshold value. Nodes also amass energy due to local resources, which can be thought of as due to population centers (visualized as black circles). Finally, nodes can rebel from their empires with a small probability.

Partially inspired by the work of [Peter Turchin](https://peterturchin.com/).

### Controls
Toggle between display modes using the number keys. 1=plain cells, 2=cells w/ cities, 3=plain nodes, 4=nodes w/ network edges and glow
Press Space to pause/unpause and 'r' to reset the simulation.

### Example behavior
<img width="1824" height="1880" alt="Screenshot 2025-12-22 at 4 59 09 PM" src="https://github.com/user-attachments/assets/84192470-ef03-4749-b26c-18b408b011cd" />
<img width="1824" height="1880" alt="Screenshot 2025-12-22 at 5 15 36 PM" src="https://github.com/user-attachments/assets/0bef5af0-a91e-46af-a389-b371bacbf930" />
<img width="1824" height="1880" alt="Screenshot 2025-12-22 at 4 58 14 PM" src="https://github.com/user-attachments/assets/d75ea242-27a8-40c6-ba0e-dace6707fa19" />
