# Game MVP 001 - Turret Commander

The first MVP in series of games that will be developed in the Godot engine in short timeframes.

- 7 Days of development
- Development start date: 2024-05-14
- MVP planned release date: 2024-05-23 (2024-05-22 + 1 extra day)
- Name: Turret Commander
- Learning goal: try to construct standalone components that can be reused in future projects.
- Release link: https://marleeeeeey.itch.io/turret-commander

## Gameplay overview

- Main goal of the game is to survive the waves of enemies that are trying to reach the base of the player in the center of the map.
- Player can place turrets to help him defend the base.
- Player can also move around the map to help turrets and attack enemies.
- Player can damage enemies by being close to them.

## Controls

- Gamepad (preferred)
  - Left stick - move the player.
  - A - place a turret.
  - X - shoot.
  - Start - pause the game.
- Keyboard:
  - W, A, S, D - move the player.
  - Space - place a turret.
  - Enter - shoot.
  - Esc - pause the game.

## Gameplay details

- The player controls the hero.
- The hero can place turrets.
- The hero's house is in the center of the map.
- Enemies randomly approach the center of the map from the edges.
- Enemies drain health from turrets, the hero, and the fort when they collide.
- The hero's proximity to the turrets recharges them.
- The hero can shoot like the turrets, but faster.
- Defeat condition: the enemies destroy the house or the hero.
- Victory condition: survive for a certain amount of time.

## Guidelines

### Godot editor guidelines

- Use push_error and push_warning for errors and warnings.
- Edotor Settings -> General -> Debug -> Auto Switch to Remote Scene Tree - ENABLE.
- Project Settings -> Display -> Window -> Always on Top - ENABLE.
- Use `Scene -> Save Branch As Scene` to simplify the scene and reuse it.

### File structure

The project is structured in a way that allows to easily reuse common scenes and tilesets across multiple projects. This approach will teach you to create convenient components for future games.

The structure is as follows:

```
- GodotProjectFoler
  - 010_globals (keep link to the Camera2D, ...)
    - globals.gd
  - 015_scripts (reusable scripts without scenes)
    - *.gd
  - 017_standalone_tilesets (tilesets without dependencies)
    - <name>
      - *.tres
      - *.png
  - 020_standalone_scenes (scenes without dependencies)
    - <name>
      - *.tres
      - *.gd
      - *.tscn
      - art/
        - *.png
        - *.mp3
        - *.wav
  - 030_deps_scenes (scenes with dependencies from standalone scenes)
    - <name>
      - *.tres
      - *.gd
      - *.tscn
      - art/
        - *.png
        - *.mp3
        - *.wav
  - 090_this (game specific scenes, scripts and art)
    - main.tscn
    - main.gd
    - <name>.tscn
    - <name>.gd
    - art
      - *.png
      - *.mp3
      - *.wav
      - icon.svg
```

## Development Log

- Reused the hexagonal tileset and player scene (spaceship) - the player is controlled with the mouse: #2024-05-15
- Added an enemy scene. By default, it moves to the center of the map: #2024-05-15
- The player is controlled with the keyboard and gamepad: #2024-05-15
- The player can shoot: #2024-05-15
- The player can create turrets: #2024-05-16
- Turrets attack enemies: #2024-05-16
- Created the player's fort area: #2024-05-19
- Disabled collisions for turrets: #2024-05-19
- Enemies collide with turrets and the fort, as well as the map. The player collides only with the map and enemies: #2024-05-19
- Enemies try to crash into nearby turrets: #2024-05-19
- Turrets have a limited number of charges: #2024-05-20
- The hero recharges turrets when near them: #2024-05-20
- Implemented the pause menu: #2024-05-21
- Reused the pause menu for the game over message: #2024-05-21
- Added HUD with player and fort health: #2024-05-21
- Added sound effects for shooting and explosions: #2024-05-21
- Improved UI. Added start game, pause, and game over menus. Added health and score counters: #2024-05-22
- Added increasing enemy spawn rate over time: #2024-05-23
- Added lifecycle for bullets. Added limits on the number of turrets and bullets: #2024-05-23
- First release of the MVP for itch.io: #2024-05-23

## TODO list

- The player cannot place turrets too often during the game.
- The player cannot place turrets too close to each other.
- Change the control to smooth turns on the arrow keys instead of moving up-down-left-right.

## Game design problems

- The main problem to solve is to make it so that you don't have to circle around one point.
- Come up with a more interesting level and change levels in order.
- Make several bases and move between them to defend them.
  - But the game is still pretty dumb because you can only place turrets and don't participate in the game yourself.
- A version with a more thought-out level with mazes and different types of guns.
- I would start playing if the plane had complex inertial control, and fewer enemies (Vasilyev).

## Assets

- https://kenney.nl/assets/space-shooter-extension
- https://www.kenney.nl/assets/top-down-tanks-redux
- https://kenney.nl/assets/isometric-buildings-1
