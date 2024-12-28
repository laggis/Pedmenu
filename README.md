# PedMenu for FiveM

A comprehensive FiveM resource that adds an intuitive menu system for spawning and managing peds (NPCs) in your FiveM server. Perfect for roleplay servers, custom scenarios, or any server that needs advanced ped management.

## Features

- **Ped Spawning:**
  - Spawn any GTA V ped model
  - Custom positioning and rotation
  - Bulk spawn capability
  - Save favorite ped models

- **Ped Management:**
  - Control ped behavior
  - Set ped animations
  - Adjust ped attributes
  - Delete individual or all spawned peds

- **Menu System:**
  - Clean and intuitive interface
  - Easy-to-navigate categories
  - Search functionality
  - Customizable keybinds

- **Advanced Options:**
  - Ped relationship settings
  - Animation control
  - Weapon management
  - Task assignment

## Prerequisites

- FiveM Server
- ESX/QBCore Framework (optional, but recommended)
- Basic understanding of FiveM resource management

## Installation

1. Download the latest release from the [releases page](https://github.com/laggis/Pedmenu/releases)

2. Extract the `pedmenu` folder to your server's resources directory

3. Add to your `server.cfg`:
```cfg
ensure pedmenu
```

4. Configure the settings in `config.lua` to match your server's needs

## Configuration

Example configuration in `config.lua`:
```lua
Config = {}

Config.OpenKey = 'F5'  -- Key to open the menu
Config.AdminOnly = true  -- Restrict to admins only
Config.MaxPeds = 10  -- Maximum peds per player
Config.DefaultScenario = 'WORLD_HUMAN_STAND_IMPATIENT'

-- Add your custom ped categories
Config.Categories = {
    ['Police'] = {
        's_m_y_cop_01',
        's_f_y_cop_01'
    },
    ['Civilians'] = {
        'a_m_y_skater_01',
        'a_f_y_tourist_01'
    }
}
```

## Usage

### Basic Commands
- `/pedmenu` - Open the ped menu
- `/delpeds` - Delete all spawned peds
- `/pedanim [animation]` - Make selected ped play animation
- `/pedtask [task]` - Assign task to selected ped

### Menu Navigation
1. Press the configured key (default: F5) to open the menu
2. Navigate through categories using arrow keys
3. Select ped models to spawn
4. Use the management options to control spawned peds

### Ped Management
- Right-click on spawned peds for quick actions
- Use the management tab for advanced options
- Save frequently used peds as favorites
- Adjust ped behavior and attributes

## Permissions

Configure permissions in your server's ACL:
```
add_ace group.admin pedmenu.admin allow
add_ace group.moderator pedmenu.spawn allow
```

## Features in Detail

### Ped Spawning
- Precise positioning with coordinates
- Rotation control
- Health and armor settings
- Weapon loadout configuration

### Ped Behavior
- Set walking style
- Configure combat behavior
- Adjust relationship groups
- Control scenario playback

### Menu Customization
- Change menu colors
- Adjust menu position
- Customize category names
- Add custom ped models

## Troubleshooting

Common issues and solutions:

1. **Menu Won't Open:**
   - Check keybind configuration
   - Verify permissions
   - Ensure resource is started

2. **Peds Not Spawning:**
   - Check entity limits
   - Verify ped model names
   - Confirm spawn coordinates

3. **Performance Issues:**
   - Reduce max ped limit
   - Clear unnecessary peds
   - Check server performance

## Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Planned Features

- Advanced AI behavior systems
- More animation options
- Custom scenario creator
- Enhanced ped customization
- Network synchronization improvements

## Support

Need help?
1. Check the [Issues](https://github.com/laggis/Pedmenu/issues) page
2. Create a new issue with detailed information
3. Join our Discord community (if available)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Created by Laggis

## Acknowledgments

- FiveM community
- Contributors and testers
- Inspiration from various ped management systems

## Version History

- 1.0.0: Initial release
- 1.1.0: Added advanced ped controls
- 1.2.0: Menu system overhaul
- Current: See releases page

## Notes

- Always test new features in a development environment
- Keep track of spawned peds to maintain server performance
- Regular cleanup of unused peds is recommended
