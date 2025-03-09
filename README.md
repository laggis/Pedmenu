# FiveM Standalone Ped Menu

A standalone ped menu for FiveM with Discord role or Ace permission whitelisting.

## Features
- Standalone implementation (no framework dependencies)
- Native FiveM menu system
- Clean, minimalist dark theme design
- Optimized performance with stable UI
- Whitelist using Discord roles or Ace permissions
- Easy to configure and customize
- Add unlimited ped models
- Simple command-based activation
- Smooth navigation with keyboard controls

## Visual Design
- Modern dark theme with carefully chosen colors
- Very dark gray background (15, 15, 15)
- Light surface highlights (30, 30, 30)
- Clear white text for selected items
- Subtle gray text for unselected items
- Left-aligned menu for better visibility
- Clean, distraction-free interface

## Installation
1. Download or clone this resource
2. Place it in your server's `resources` folder
3. Add `ensure Pedmenu` to your `server.cfg`
4. Configure the `config.lua` file:
   - Set your Discord bot token (if using Discord whitelist)
   - Set your Discord server ID and role ID
   - Add or modify the available ped models
5. Restart your server

## Configuration
Edit `config.lua` to customize:
- Command name (default: /pedmenu)
- Whitelist type (Discord or Ace)
- Discord settings (if using Discord whitelist)
- Available ped models

## Usage
- Type `/pedmenu` in chat to open the menu
- Use arrow keys (↑/↓) to navigate
- Press ENTER to select a ped
- Press BACKSPACE to close the menu
- Only whitelisted players can use the menu

## Requirements
- FiveM server
- Discord bot (if using Discord whitelist)

## Performance
- Optimized rendering with minimal overhead
- Clean, stable interface without unnecessary animations
- Efficient resource usage
- Smooth menu transitions
