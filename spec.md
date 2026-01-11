# True Fulgora Conqueror — Specification (spec)

This document records the **design intent, specifications, and agreed decisions** of True Fulgora Conqueror.  
Its purpose is to preserve explicit decisions that cannot be fully described in the Mod Portal or README.

---

## 0. Purpose and Non-goals

### 0.1 Purpose

- To provide a **high-density, high-pressure defensive experience** on Fulgora, centered around **ruins** as enemy emergence points.
- To emphasize ingenuity under **limited land and limited options**, rather than wide defensive lines.
- To redefine Fulgora not as a planet to expand safely, but as a planet to be **conquered**.

### 0.2 Non-goals

- This is not a mod that simply strengthens or increases enemies.
- It is not designed around infinite expansion or large-scale perimeter defense.
- It does not aim to alter enemy behavior globally or on other planets.

---

## 1. Mod Positioning

- Category: Content addition / Enemy behavior
- Target environment: Factorio 2.0+ / Space Age
- Applicable planet: Fulgora only
- Core fantasy:
  - A clear objective of **conquering Fulgora**.

---

## 2. Core Player Experience Loop

1. Discover ruins on Fulgora.
2. Enemies emerge using the ruins as their origin.
3. Build defensive structures in confined spaces.
4. Adjust and refine defensive layouts to progress toward domination.

*The design prioritizes a short loop of exploration → defense → improvement.*

---

## 3. System Specification Overview

### 3.1 Ruins Handling

- In this mod, “ruins” refer to:
  - Medium-sized or larger **Fulgora ruins**.
  - In implementation, the following ruin entities are targeted:
    - Medium Fulgora Ruins
    - Large Fulgora Ruins
    - Huge Fulgora Ruins
    - Ultra Huge Fulgora Ruins
    - Fulgora Storage Ruins
- Ruin detection timing:
  - Periodic scanning via scheduled events.

---

### 3.2 Enemy Spawning Rules

- Spawn trigger:
  - Every 30 minutes, enemies spawn randomly around ruins.
  - In regions with sufficiently high biter density, a demolisher spawn flag is set.
- Spawn location:
  - Ruins serve as the origin point.
- Spawn suppression conditions:
  - No additional demolishers will spawn if 200 or more demolishers already exist.
  - Demolishers will not spawn if the location is too close to player-built structures.
- Spawn frequency and strength:
  - As the evolution factor increases, enemies gradually become higher quality and more powerful.
- Design intent:
  - This behavior is based on the concept that **demolishers emerge by feeding on biters**, and is intended to create potentially fatal situations if the player’s response is delayed.

---

### 3.3 Enemy Composition

- Enemy types used:
  - All biters, all spitters, all worms, all demolishers, across all quality levels.
- Wave behavior:
  - Spawn flags are evaluated every 30 minutes.
  - If a rocket has been launched within the last 30 minutes, demolishers will move a short distance toward the rocket silo.

---

### 3.4 Difficulty Control

- Settings:
  - None.
- Player-controlled adjustment:
  - If rockets are not launched, demolisher attacks are rare.
- Intended baseline:
  - “Harsh enough that initial defensive lines may collapse several times, but manageable through proper design once the player is experienced.”

---

## 4. Compatibility Policy

- Global enemy definitions and AI are altered as little as possible.
- All behavior is contained as a **local modification limited to Fulgora**.
- If interaction with other mods is unavoidable:
  - It must be explicitly documented as part of the specification.

---

## 5. Save Data and Determinism

- Global storage used:
  - `storage.suumani_tfc`
- Multiplayer determinism:
  - Randomness is implemented using deterministic methods and assumes reproducibility in multiplayer.
  - Any deviation from this behavior is treated as a bug.

---

## 6. Known Constraints and Issues

- Intended behaviors:
  - Spawning of biters, worms, biter nests, demolishers, and biter-driven nest expansion.
- Known issues:
  - None.
- The boundary between bugs and intended behavior is judged based on this specification.

---

## 7. Roadmap (Developer-oriented)

- Short-term:
  - None.
- Mid-term:
  - None.
- Long-term:
  - Bug fixes only.

---

## 8. Status of This Specification

- This document takes precedence over the README and Mod Portal descriptions.
- If discrepancies arise between implementation and this specification:
  - A conscious decision must be made to either treat the implementation as authoritative,
  - or update this specification accordingly.