# jecs-template
A minimal Luau (Roblox) project template intended to help you start a small ECS-style project using this repository as a base. This repository contains basic configuration files (wally.toml, rokit.toml, default.project.json) and an empty `src/` directory you can use to organize your game code.

This README explains how to set up, install dependencies, and a suggested project structure and usage patterns.

---

## Packages

A selection of useful libraries and tools for Roblox/Luau development:

- **[Jecs](https://ukendio.github.io/jecs/):** A high-performance ECS library for Roblox (Luau) with archetypes, type safety, and first-class entity relationships.
- **[Jabby](https://alicesaidhi.github.io/jabby/):** A minimal visual tool for debugging and inspecting Jecs worlds. (F4 to open menu in game)
- **[Planck](https://github.com/YetAnotherClown/planck):** A lightweight ECS scheduler for managing phases and system execution order, agnostic of the underlying ECS implementation.
- **[React (Roact)](https://roblox.github.io/roact-alignment/):** A declarative UI framework for Roblox inspired by React, supporting components, hooks, and modular UI composition.
- **[Charm](https://github.com/littensy/charm):** A modern state management library for Roblox built on atomic, immutable state
- **[Ripple](https://github.com/littensy/ripple):** A lightweight animation library for Roblox.
- **[UI-Labs](https://ui-labs.luau.page/):** Storybook plugin for Roblox
- **[t](https://github.com/osyrisrblx/t):** Runtime type checking library for Luau – helps catch bugs early.
- **[Lapis](https://github.com/nezuo/lapis):** A lightweight library for managing and validating player data in Roblox.


---

## Overview

This repository is a template. It includes:

- wally.toml — Wally dependency configuration
- rokit.toml — configuration for RoKit
- default.project.json — example/default project settings
- src/ — place your Luau source files here

Use this template as a starting point for small ECS-style games or experiments in Luau on Roblox. It does not impose a particular ECS library — adapt it to the ECS implementation you prefer.

**PRESS F4 ON YOUR KEYBOARD TO OPEN JABBY menu.**

---

## Requirements

- Roblox Studio (to run and test your game)
- Git (to clone the repo)
- Wally (recommended) — Luau package manager used by many Roblox developers
- Rojo — for syncing local files into Roblox Studio

Install Wally and Rojo following their official docs for your platform. If you don't use Wally, you can still place packages into `src/` manually.

---

## Install (quick start)

1. Clone the repository:
   ```bash
   git clone https://github.com/LocalPulse/jecs-template.git
   cd jecs-template
   ```

2. Install dependencies with Wally (if you use Wally):
   ```bash
   rokit add rojo-rbx/rojo (I don't use it's)
   rokit install
   wally install
   rojo sourcemap default.project.json -o sourcemap.json
   wally-package-types --sourcemap sourcemap.json Packages
   ```

3. Start a file sync tool to push code to Roblox Studio:
     ```bash
     rojo serve
     ```

4. Open Roblox Studio and connect to the running Rojo server. Press F4 on your keyboard to open Jabby menu.

---

## Suggested project structure

This is a suggested layout inside `src/`. Adjust as you need.

Example:
```
src/client/
├── systems/
│   └── leaderboard.luau
└── init.client.luau

src/server/
├── systems/
│   └── leaderboard.luau
└── init.server.luau

src/shared/
├── components/
│   ├── init.luau --basic components
│   └── replication.luau --replication components
├── systems/
│   └── leaderboard.luau
└── utils/
    └── leaderboard-helper.luau
```

---

## Example component & system (Luau)

Below are small illustrative examples showing the style of code you might place in `src/`. These are intentionally generic — adapt to whichever ECS pattern or library you use.

File: `src/components/init.lua`
```lua
...

return {
	PlayerRef = world:component() :: Jecs.Entity<Player>,
	Loaded = world:component() :: Jecs.Entity<boolean>,
	PlayerDocument = world:component() :: Jecs.Entity<any>,
  	LeaderBoard = world:component() :: Jecs.Entity<any> -- new component
}
```

File: `src/server/systems/leaderboard.luau`
```lua
--[[ Services ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[ Locations ]]
local Shared = ReplicatedStorage.Shared

--[[ Packages ]]
local Jecs = require(ReplicatedStorage.Packages.Jecs)
local Planck = require(ReplicatedStorage.Packages.Planck)

--[[ Components ]]
local ReplicationComponents = require(Shared.components.replication)

--[[ Handler ]]
local function setup(world: Jecs.World)
	--your system logic
end

return {
	system = setup,
	phase = Planck.Phase.PostStartup, --It's phase load. Check documentation Planck.
}
```

**To check entities, components and systems, press F4 to open Jabby.**

---

## Contributing

- Create a branch from `main` for your changes.
- Keep changes small and focused.
- If you want, open a pull request against this repository and describe your changes.

If you want me to add this README directly to the repository and open a pull request, I can do that for you.

---

## License

Use whatever license you prefer. This template does not include a license file by default. If you want, I can add an MIT or other license file.
