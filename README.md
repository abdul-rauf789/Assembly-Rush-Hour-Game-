# Rush Hour Game - Assembly Language

**AI in Assembly | AI Enthusiast | Passionate about Cybersecurity**

---

## Project Overview

Rush Hour is a **2D car simulation game** written entirely in **x86 Assembly (MASM)** using the **Irvine32 library**. The game challenges players to navigate a car through a city block while avoiding obstacles, picking up passengers, and managing time and score. It includes multiple game modes and difficulty levels, demonstrating advanced **low-level programming**, memory management, and real-time user interaction.

---

## Features

- **Interactive gameplay**: Move the car using `W`, `A`, `S`, `D` or arrow keys.
- **Multiple game modes**:
  - Career Mode: Pick up all passengers to complete the mission.
  - Time Mode: Complete tasks against the clock.
  - Endless Mode: Continuous gameplay with dynamic obstacles.
- **Dynamic obstacles**: Buildings (`B`), Trees (`T`), and Random Cars (`A`) placed randomly on the grid.
- **Passenger management**: Pick up (`SPACEBAR`) and drop off passengers at designated points.
- **Collision detection**: Avoid hazards like buildings, walls, and other cars.
- **Scoring system**: Points awarded for successful pickups, deducted for collisions.
- **Timer display**: Shows elapsed time during gameplay.
- **Pause & Instructions**: Pause game, view instructions, or change game mode mid-play.
- **Difficulty Levels**: Easy, Normal, Hard, Extreme—affects the number of buildings and challenges.

---

## How It Works

1. The **game board** is represented as a 2D grid stored in memory.
2. **Buildings, trees, passengers, and cars** are randomly placed while avoiding collisions.
3. Player inputs are **read in real-time** and control car movement.
4. Functions validate interactions:
   - `CheckCarCollision()` – detects hazards
   - `checkPerson()` – verifies pickups
   - `dropedPerson()` – updates score and removes passenger
5. The display updates dynamically using `GotoXY` and **Irvine32 text functions**.

---

## Project Structure

| File         | Description |
|--------------|-------------|
| `RushHour.asm` | Main game code with all procedures for car movement, collision detection, and game logic |
| `Irvine32.inc` | Required library for assembly I/O functions |
| `kernel32.lib` | Required for system calls |

---

## How to Run

1. Open the project in **MASM / Visual Studio** with Irvine32 library.
2. Compile the code:
   ```asm
   ml /c /coff RushHour.asm
   link /subsystem:console RushHour.obj kernel32.lib Irvine32.lib
