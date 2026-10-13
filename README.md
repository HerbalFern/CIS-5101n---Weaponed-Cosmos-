# Weaponed Cosmos! - A Project for CS 5101N
Weaponed Cosmos is a 2D Action Adventure Dungeon Crawler. Set in the year 3026, humanity has gone intergalactic with multiple systems and planets with great treasure to LOOT. You play as a cosmo pirate who intercepts corporate ships, raid abandoned space structures and loot anything you find. 


## Activity 1
During this activity, we have done the following tasks according to the instruction document provided by our course instructor: 
- Downloaded Godot with the latest build then created a new project named "Weaponed Cosmos"
- Added a Node2D as the root (default when switching to a 2D scene) and added a Sprite2D with the Godot logo as a placeholder.
- Setup the Github repo with a .gitignore file, a README.md file and also initializing the local repository with Git LFS (wav and png files)
- Pushed the files while settling git merge conflicts
- Wrote this README.md file


## Activity 2
During this activity, we have done the following tasks according to the instruction document provided by our course instructor: 
- Created Basic Sprites for my game
- Added basic Movements (Up, Down, Left, Right)
- Adding A Collision Model (crate)
- Added a collision sound detection (extra juice) 

## Activity 3
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Built two playable levels (`Level-1` and `Level-2`) using a **TileMapLayer** (Godot 4's replacement for the older TileMap node) painted from a tileset, instead of placing walls one by one
- Set up collision layers so everything interacts correctly: Layer 1 = walls/crates, Layer 2 = player, Layer 3 = enemies
- Added **hazards**:
  - Spike trap: an `Area2D` that damages the player while they stand on it
  - Slime enemy: a `CharacterBody2D` that chases the player when within detection range, has health, flashes when hit, and damages the player on contact through a `Hitbox` Area2D
- Added a player health system with a `take_damage()` function, a short blink, and 1 second of invincibility after each hit so hazards can't drain health instantly. A `health_changed` signal is included for the HUD in a later week
- Updated shooting so the player can only fire while standing still, with an adjustable `fire_delay` (set to 0.25s)
- Added **bullets** that stop at walls and call `take_damage()` on anything they hit
- Added a **Door** scene with an exported `next_level` variable. Touching it with the player loads the next level using `change_scene_to_file`, so one door scene works for every level
- Set the player's collision layer/mask so the player is blocked by walls but can walk over the spike hazard
- Reorganized the scene tree (grouped nodes, replaced loose wall nodes with the TileMapLayer)
- Debugged using `print()` statements and the Output panel (layer/mask mismatches, missing `take_damage`, null node references)

### Difficulty curve
- **Level 1:** [teaches the mechanic gently, e.g. movement, shooting, and one spike trap with a clear way around it]
- **Level 2:** [tests it, e.g. adds the slime enemy and more hazards before the door]

### Readability
- [Describe how you made hazards look different from safe ground, e.g. spikes are a distinct color/shape from the floor tiles and the door is clearly marked]

### Inclusive content reflection
I kept the level design and visuals free of harmful stereotypes by using a fictional sci-fi setting with original characters and enemies, and by making hazards readable through shape and contrast as well as color so more players can understand them.

<img width="2940" height="1912" alt="image" src="https://github.com/user-attachments/assets/900cb326-8eba-4934-af54-5812aa3d7a5f" />
<img width="1170" height="670" alt="image" src="https://github.com/user-attachments/assets/00c292cd-417a-4396-aeec-d5bcb1ffc649" />
<img width="1204" height="686" alt="image" src="https://github.com/user-attachments/assets/73de7c2d-50b6-4d1a-ba51-fa03f8fe72c1" />

