# Weaponed Cosmos! - A Project for CS 5101N
Weaponed Cosmos is a 2D Action Adventure Dungeon Crawler. Set in the year 3026, humanity has gone intergalactic with multiple systems and planets with great treasure to LOOT. You play as a cosmo pirate who intercepts corporate ships, raid abandoned space structures and loot anything you find. This demo contains a set of levels in an abandoned Spaceship where Alien bats and slimes roam. 


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
- Built playable levels using a **TileMapLayer** (Godot 4's replacement for the older TileMap node) painted from a tileset, instead of placing walls one by one
- Set up collision layers: Layer 1 = walls and crates, Layer 2 = player, Layer 3 = enemies
- Added **hazards**:
  - Spike trap: an `Area2D` that damages the player while they stand on it
  - Slime enemy: a `CharacterBody2D` that chases the player, has health, flashes when hit, and damages the player on contact
- Added a player health system with `take_damage()`, a short blink, and 1 second of invincibility after each hit so hazards can't drain health instantly
- Updated shooting so the player can only fire while standing still, with an adjustable `fire_delay`
- Added **bullets** that stop at walls and call `take_damage()` on anything they hit
- Added a **Door** scene with an exported `next_level` variable that loads the next level with `change_scene_to_file`, so one door scene works for every level
- Reorganized the scene tree by grouping nodes and replacing loose wall nodes with the TileMapLayer

### Difficulty curve
- **Level 1** introduces the controls, movement and shooting in a gentle space
- **Level 2** tests those skills with a spike trap and a Slime enemy before the exit door

### Readability
Hazards are made visually distinct from safe floor tiles through shape and contrast, and the exit door is clearly marked so players can tell what is safe and what is dangerous.

### Inclusive content reflection
I kept the level design and visuals free of harmful stereotypes by using a fictional sci-fi setting with original characters and enemies, and by making hazards readable through shape and contrast as well as color.

<img width="2940" height="1912" alt="image" src="https://github.com/user-attachments/assets/900cb326-8eba-4934-af54-5812aa3d7a5f" />
<img width="1170" height="670" alt="image" src="https://github.com/user-attachments/assets/00c292cd-417a-4396-aeec-d5bcb1ffc649" />
<img width="1204" height="686" alt="image" src="https://github.com/user-attachments/assets/73de7c2d-50b6-4d1a-ba51-fa03f8fe72c1" />



## Activity 4
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Sliced the character sprite sheet (`character_full.png`) on a **Sprite2D** using Hframes/Vframes and animated it with an **AnimationPlayer** by keyframing the `frame` property
- Created player animations for three facing directions (down, up, side), each with three states: `idle_*` (looping), `move_*` (looping) and `shoot_*` (plays once)
- Left-facing movement reuses the side animations by mirroring the sprite with `flip_h`
- Wrote an `update_animation()` function in `player.gd` that picks the animation by name from the player's state and facing direction, with a `shooting` flag so the shoot pose isn't overwritten
- Animated the **Slime enemy** with a 3-frame looping idle wobble
- Set the project's default texture filter to **Nearest** so pixel art stays crisp
- Added **particle effects** that give visible feedback in play, including a damage burst when an enemy is hit
- Added an **AI-generated space background** to the game

### AI-generated asset
- **Asset:** `Background.jpeg`, a space background with a purple nebula and stars
- **Tool used:** Gemini
- **Prompt:** "Wait I have an idea. Make me the Space Background of the game. The theme of the game is purple. Make it for a 64x64 game."
- **Ownership:** I reviewed the result to make sure it matched the game's purple palette and pixel-art style, and I can explain how it was integrated into the game.

### Particle effect (AI-assisted)
- **Tools used:** Antigravity with Gemini Flash, connected to Godot through MCP
- I reviewed the generated particle scene and how it is triggered, and I can explain how it works.

### Tools used
Claude (AI assistant) was used for guidance and debugging on the animation setup and player script. Gemini generated the background, and Antigravity with Gemini Flash generated the particle effect. All assets were reviewed, integrated and tested by me.

<img width="1802" height="1162" alt="image" src="https://github.com/user-attachments/assets/28792cae-bc90-4551-8b34-bd74e86378dd" />


https://github.com/user-attachments/assets/02b946ee-5046-4c7c-a46b-be5955e389d5


## Activity 5
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Built an in-game **HUD** on a `CanvasLayer` (Layer 10) with a health display (`HP: 5/5` plus pixel-art hearts that update through the player's `health_changed` signal), the current level name and an elapsed-time timer
- Created a **Main Menu** with Start Game, Settings and Quit, set as the project's Main Scene
- Added a **Pause Menu** (Escape key, `process_mode = Always`), a **Game Over screen** with Restart and Main Menu, and a **Win screen** at the end of the game
- Set up **audio buses** (`Master`, `Music` at -12 dB, `SFX` at -4 dB) and an `AudioManager` autoload that plays looping music on the Music bus and one-shot effects on the SFX bus
- Added audio for shooting, player hurt, enemy hit, enemy death, button clicks and doors, plus a looping background music track
- Built a reusable **Settings panel** with Master, Music and SFX volume sliders, mute toggles and a Large Text toggle, used from both the main menu and the pause menu

### Accessibility feature
- **Feature:** Large Text toggle
- A `Settings` autoload stores `large_text` and saves it to `user://settings.cfg`, so the choice persists between sessions
- Turning it on switches UI text from 16px to 24px instantly across the HUD and all menus
- All UI text uses white text with a 4px dark outline for contrast against the purple background

### Audio
- **Music:** `bgm_space_theme.wav`, an 8-second looping space chiptune
- **Sound effects:** `sfx_shoot.wav`, `sfx_player_hurt.wav`, `sfx_enemy_hit.wav`, `sfx_enemy_death.wav`, `sfx_button_click.wav` and `sfx_door.wav`
- The audio was synthesized by Antigravity with a Python script (waveforms, pitch sweeps, noise and envelopes saved as 16-bit 44.1kHz `.wav` files), so no outside samples were used
- Music and effects play through separate buses so they can be balanced independently

### AI-assisted development
- **Tool used:** Antigravity with Gemini Flash, connected to Godot through MCP
- **AI-generated assets:** pixel-art UI sprites (hearts, timer icon, 9-slice button and panel frames) and the audio files above
- I ran the full game flow, the game over and restart loop, the pause menu and the settings, and confirmed there were no errors in the Output panel
- Claude (AI assistant) was also used for guidance and debugging throughout the project.

### Playtest
- The menu was heavily play-tested and completed with no errors arising. 

<img width="1470" height="956" alt="Screenshot 2026-10-16 at 5 06 28 AM" src="https://github.com/user-attachments/assets/4c8abeca-d2aa-46a8-af8f-d7bb15042ea5" />
<img width="602" height="344" alt="Screenshot 2026-10-16 at 5 08 08 AM" src="https://github.com/user-attachments/assets/a3df14c2-8805-4f12-b70a-22e8164438ee" />
<img width="591" height="337" alt="Screenshot 2026-10-16 at 5 08 15 AM" src="https://github.com/user-attachments/assets/691aa0e0-64e9-4f53-9a5e-c100c8c0ddf4" />


## Activity 6
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Rewrote the **Slime** enemy (`slime.gd`) as a **finite state machine** using an `enum State` and a `match` statement in `_physics_process`:
  - `IDLE`: stands still until the player enters `detect_range`
  - `CHASE`: moves toward the player and flips its sprite to face them
  - `ATTACK`: stops and damages the player every `attack_cooldown` seconds while in range
  - `HURT`: a short stun with a white flash after being hit
  - `DEAD`: removes the enemy once its health reaches 0
- Created a second enemy type, the **Bat** (`bat.gd`, `Bat.tscn`), with different behavior from the Slime: it is faster and does a swooping dive attack. Its states are:
  - `PATROL`: drifts back and forth, reversing direction on a timer
  - `CHASE`: flies toward the player at higher speed
  - `DIVE`: locks onto the player's position and rushes it, damaging the player once per dive
  - `HURT` and `DEAD`: same idea as the Slime
- Added a 3-frame flapping animation for the Bat with an AnimationPlayer, and a generated Bat sprite sheet
- Added damage particles and SFX hooks (`AudioManager.play_enemy_hit()` and `play_enemy_death()`) to both enemies
- Added **Level 3** with 2 Slimes and 3 Bats, and updated the doors so the flow is Level 1, Level 2, Level 3, then the Win screen
- Exposed tuning values with `@export` (for example `chase_speed`, `detect_range`, `attack_cooldown`, `dive_speed`, `dive_range`) so the challenge can be balanced from the Inspector

### AI-assisted code (what was AI-drafted vs. my own work)
- **Tool used:** Antigravity with Gemini Flash, connected to Godot through MCP
- **AI-drafted:**
  - The first version of the Slime state machine in `slime.gd`
  - The Bat's state machine in `bat.gd` and the `Bat.tscn` scene
  - The Bat sprite sheet
  - `Level-3.tscn`, assembled from existing scenes
- **What I changed and fixed myself:**
  - Fixed the bat sprite, animations and implementations.
    
### Detection and collision
- Enemies detect the player by comparing the distance to the player against `detect_range`, and the Slime's `ATTACK` state and the Bat's `DIVE` state damage the player through the player's `take_damage()` function, which gives 1 second of invincibility after each hit
- Both enemies are on collision layer 3, so the player's bullets damage them and flash them white

### Testing
- I played through Level 1, Level 2, Level 3 and the Win screen and checked each enemy's states.

<img width="1144" height="640" alt="image" src="https://github.com/user-attachments/assets/a1b5db36-067e-4064-a288-dbb6a68c6ba4" />

## Activity 7
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Added a **polish pass** using a `Juice` autoload:
  - **Screen shake:** tweens the active Camera2D's `offset` to decaying random values, stronger for player damage and enemy deaths and very light when shooting
  - **Hit-stop:** briefly drops `Engine.time_scale` to 0.05 on impacts using an unscaled timer, and resets it on pause and player death so the game can't get stuck in slow motion
  - **Tweened UI:** the HUD heart pops to 1.4x scale and bounces back when health changes, menu buttons scale up on hover, menu titles slide and fade in, and the win screen title bounces in
- Implemented **save/load** with a `SaveManager` autoload that writes JSON to `user://savegame.json`:
  - Saves the current level path, player health, elapsed time and a version number
  - Saves automatically when going through a door and when returning to the main menu from the pause menu
  - Added a **Continue** button to the main menu that restores the saved level, health and timer, and is hidden when no save exists
  - Starting a new game replaces the save, and finishing the game deletes it
  - A missing or corrupted save file returns an empty result instead of crashing
- Reviewed the game for **performance** costs with the Godot profiler and a ranked list of likely candidates (per-frame physics polling and debug printing on the spike trap, HUD label updates every frame, and repeated timer creation when shooting)

### AI-assisted development
- **Tool used:** Antigravity with Gemini Flash, connected to Godot through MCP
- **AI-drafted:** the `Juice` and `SaveManager` autoloads, the hooks into the player, enemies, HUD, menus and doors, the Continue button, and the ranked list of optimization candidates
- **My own work:** testing save and Continue by closing and reopening the game, and checking that the Continue button disappears after finishing the game
- Claude (AI assistant) was also used for guidance and debugging throughout the project. I can explain how the screen shake, hit-stop and save/load code works.

### Playtest
- Save states were lightly tested with most surface level features working. 
