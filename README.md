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


## Activity 5
During this activity, we have done the following tasks according to the instruction document provided by our course instructor:
- Built an in-game **HUD** on a `CanvasLayer` (Layer 10) so it stays on screen regardless of the camera:
  - Top-left: `HP: 5/5` text plus a row of 16x16 pixel-art hearts (`heart_full.png` / `heart_empty.png`) that update through the player's `health_changed` signal
  - Top-right: the current level name and an elapsed mission timer (`MM:SS`) with a stopwatch icon
  - Added to both `Level-1` and `Level-2`
- Created a **Main Menu** (`main_menu.tscn`) with Start Game, Settings and Quit. It is now the project's Main Scene and uses the space background with a darkened Modulate so the text stays readable
- Added a **Pause Menu** (CanvasLayer, `process_mode = Always`) toggled with Escape through a new `pause` input action, with Resume, Settings and Main Menu
- Added a **Game Over screen** with Restart and Main Menu. The only change to `player.gd`'s death logic was replacing `reload_current_scene()` with showing this screen
- Added a **Win screen** shown by an exit door at the end of Level 2, with Play Again and Main Menu
- Set up **audio buses** in `default_bus_layout.tres`: `Master`, `Music` (-12 dB) and `SFX` (-4 dB), with Music and SFX routed to Master
- Created an `AudioManager` autoload that loops background music on the Music bus and plays one-shot sound effects on the SFX bus. The `BumpSound` and the crate thud sound were re-routed to the SFX bus
- Added guarded SFX hooks (null-checked so nothing crashes if a slot is empty) for shooting, player hurt, enemy hit, enemy death, button clicks and door transitions
- Built a reusable **Settings panel** with Master, Music and SFX volume sliders (using `linear_to_db`), mute toggles for each bus, a Large Text toggle and a Back button. It is used from both the main menu and the pause menu

### Accessibility feature
- **Feature:** Large Text toggle
- A `Settings` autoload stores `large_text` and saves it to `user://settings.cfg`, so the choice persists between sessions
- Turning it on switches UI text from 16px to 24px, and it updates instantly in the HUD and all menus through a `large_text_changed` signal
- All UI text uses white text with a 4px dark outline (`ui_theme.tres`) for contrast against the purple background

### Audio
- **Music:** `bgm_space_theme.wav`, an 8-second looping space chiptune (arpeggios, sub-bass pulse and an ambient pad), played on the `Music` bus
- **Sound effects** (all on the `SFX` bus):
  - `sfx_shoot.wav`: laser blaster pitch drop
  - `sfx_player_hurt.wav`: low thud with a noise crunch
  - `sfx_enemy_hit.wav`: squishy impact when a bullet hits a slime
  - `sfx_enemy_death.wav`: slime pop when an enemy is defeated
  - `sfx_button_click.wav`: UI click chirp
  - `sfx_door.wav`: ascending chime on level transitions
- **How they were made:** the audio was synthesized by Antigravity with a Python script (sine and triangle waves, pitch sweeps, noise and envelopes, saved as 16-bit 44.1kHz `.wav` files), so no outside audio files or samples were used
- All seven files are assigned in the `AudioManager` autoload and play through separate buses, so music (-12 dB) and effects (-4 dB) can be balanced independently from the Settings panel

### Peer playtest
- **Tester:** [who played, e.g. a classmate or friend]
- **What I observed (without helping):** [what they struggled with, got stuck on, or didn't understand]
- **One change I made because of it:** [the specific change and where it is in the game]

### AI-assisted development
- **Tool used:** Antigravity with Gemini Flash, connected to Godot through MCP
- **What I asked for:** a HUD, main menu, pause menu, game over and win screens, audio buses with an audio manager, a settings panel and one accessibility feature, while keeping my existing gameplay scripts unchanged except for minimal hooks
- **AI-generated assets:**
  - Custom 16x16 pixel-art UI sprites (hearts, timer icon) and 24x24 9-slice button and panel frames, in `Sprites/UI/`
  - Seven synthesized audio files (one music loop and six sound effects), in `Audio/`
- **What I reviewed and checked:** I ran the full flow (Main Menu, Level 1, door, Level 2, win screen), the game over and restart loop, the pause menu, and the settings changes, listened to the audio to check the balance, and confirmed there were no errors in the Output panel
- Claude (AI assistant) was also used for guidance and debugging throughout the project. I can explain how each script and scene works.

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

