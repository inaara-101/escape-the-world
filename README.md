# escape-the-world
**Escape the World** is an interactive multiplayer game environment made on the Roblox platform utilizing Luau (derived from Lua) and NoSQL principles.

### Main Features
- Player progression across obstacle courses (called "obby") within different biomes, NPC interactions, and obby map functionality with game physics and animations.
- NoSQL data persistence via an external library called [ProfileStore](https://github.com/MadStudioRoblox/ProfileStore), which acts as a wrapper for Roblox's default [DataStoreService](https://create.roblox.com/docs/reference/engine/classes/DataStoreService) for efficiency across thousands of concurrent clients. Structured profiles for scalable expansion.
- Monetization systems with backend receipt and data handling.

### Additional Features
- Economy system, settings, viewable stats, promotional codes, and other accessibility features.
- User interface (UI) animations, management, and organization.

### Structure
- **.server.lua** represents server-sided scripts.
- **.client.lua** represents client-sided scripts.
- **.lua** represents module scripts that are shared by the server, client, or both.

### External Libraries
- [ProfileStore](https://github.com/MadStudioRoblox/ProfileStore), a wrapper for Roblox's [DataStoreService].
- NumberFormatter, a utility library for numeric formatting.
