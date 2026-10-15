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


## Activity 4
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Sliced the character sprite sheet (`character_full.png`) on a **Sprite2D** using Hframes/Vframes, and animated it with an **AnimationPlayer** by keyframing the Sprite2D's `frame` property
- Created player animations for three facing directions (down, up, side), each with three states:
  - `idle_down`, `idle_up`, `idle_side` (looping)
  - `move_down`, `move_up`, `move_side` (looping)
  - `shoot_down`, `shoot_up`, `shoot_side` (plays once)
- Left-facing movement reuses the side animations by mirroring the sprite with `flip_h`, so no separate left/right animations were needed
- Wrote an `update_animation()` function in `player.gd` that picks the animation by name from the player's state (idle or move) and facing direction. A `shooting` flag stops idle/move from overwriting the shoot pose while it plays
- Animated the **Slime enemy** with a 3-frame idle wobble using AnimationPlayer (`Idle`, looping, autoplay on load)
- Set the project's default texture filter to **Nearest** so pixel art stays crisp
- Added a **particle effect** tied to an action: [describe it, e.g. "a muzzle flash that plays each time the player shoots" or "dust puffs while walking"]
- Added an **AI-generated background** to the levels: [describe where it's used, e.g. "placed behind the TileMapLayer using a CanvasLayer set to Layer -1"]

### AI-generated asset
- **Asset:** `Background.jpeg` (space background with a purple nebula and stars)
- **Tool used:** Gemini
- **Prompt:** "Wait I have an idea. Make me the Space Background of the game. The theme of the game is purple. Make it for a 64x64 game."
- **Edits made:** [e.g. "none, used as generated" or "resized to X, cropped to Y, darkened with Modulate so enemies and hazards stay readable"]
- **Ownership:** I reviewed the result to make sure it matched the game's purple palette and pixel-art style, and I can explain how it was integrated into the levels.

### Particle effect (AI-assisted)
- **Tools used:** Antigravity with Gemini Flash, connected to Godot through MCP
- **What I asked for:** [paste or summarize your prompt]
- **Node type:** [GPUParticles2D or CPUParticles2D]
- **Trigger:** [what action starts it]
- **What I changed or checked:** [e.g. "adjusted the size and lifetime so it's visible in play, and fixed node references that didn't match my scene"]

### Tools used
Claude (AI assistant) was used for guidance and debugging while building the animation setup and player script. Gemini was used to generate the background asset, and Antigravity with Gemini Flash was used for the particle effect. All assets were reviewed, integrated and tested by me, and I can explain how each one works.
<img width="1802" height="1162" alt="image" src="https://github.com/user-attachments/assets/28792cae-bc90-4551-8b34-bd74e86378dd" />


https://github.com/user-attachments/assets/02b946ee-5046-4c7c-a46b-be5955e389d5



