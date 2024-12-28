# Welcome Discord Bot

A feature-rich Discord bot designed to welcome new members to your server with customizable messages, images, and role management capabilities.

## Features

- **Welcome Messages:**
  - Customizable welcome messages
  - Support for dynamic content (username, server name, etc.)
  - Optional embedded messages
  - Image attachment support

- **Role Management:**
  - Automatic role assignment
  - Role selection menus
  - Temporary role assignment
  - Role hierarchy respect

- **Customization:**
  - Custom welcome channels
  - Message formatting options
  - Welcome image templates
  - Multiple language support

- **Additional Features:**
  - Member counting
  - Join/Leave logging
  - Custom commands
  - Server statistics

## Prerequisites

- Node.js v16.9.0 or higher
- Discord.js
- A Discord Bot Token
- Basic understanding of Discord bot hosting

## Installation

1. Clone the repository:
```bash
git clone https://github.com/laggis/Welcome-Discord-bot.git
cd Welcome-Discord-bot
```

2. Install dependencies:
```bash
npm install
```

3. Configure the bot:
   - Rename `config.example.js` to `config.js`
   - Add your bot token and customize settings

4. Start the bot:
```bash
node index.js
```

## Configuration

Example `config.js`:
```javascript
module.exports = {
    token: 'YOUR_BOT_TOKEN',
    prefix: '!',
    welcomeChannel: 'welcome',
    
    // Welcome message settings
    welcomeMessage: 'Welcome {user} to {server}!',
    enableEmbed: true,
    
    // Role settings
    autoRole: 'Member',
    enableRoleMenu: true,
    
    // Customization
    embedColor: '#FF5733',
    showJoinDate: true,
    
    // Logging
    enableLogging: true,
    logChannel: 'member-logs'
};
```

## Usage

### Basic Commands
- `!welcome` - Send a test welcome message
- `!setwelcome <message>` - Set custom welcome message
- `!toggleembed` - Toggle embedded messages
- `!welcomechannel <channel>` - Set welcome channel

### Welcome Message Variables
- `{user}` - Member's username
- `{server}` - Server name
- `{memberCount}` - Current member count
- `{mention}` - Member mention
- `{joinDate}` - Member join date

### Role Management
- `!autorole <role>` - Set automatic role
- `!temprole <user> <role> <duration>` - Assign temporary role
- `!rolemenu` - Create role selection menu

## Customizing Welcome Messages

### Text-Only Message:
```javascript
{
    content: 'Welcome {user} to {server}! You are member #{memberCount}!'
}
```

### Embedded Message:
```javascript
{
    embed: {
        title: 'Welcome to {server}!',
        description: 'Hey {mention}, welcome to our community!',
        color: '#FF5733',
        thumbnail: '{userAvatar}'
    }
}
```

## Event Logging

The bot can log various events:
- Member joins
- Member leaves
- Role assignments
- Welcome message sends
- Configuration changes

## Troubleshooting

Common issues and solutions:

1. **Bot Not Responding:**
   - Verify bot token
   - Check bot permissions
   - Ensure proper Node.js version

2. **Welcome Messages Not Sending:**
   - Check channel permissions
   - Verify welcome channel setting
   - Confirm bot has required permissions

3. **Role Assignment Issues:**
   - Check role hierarchy
   - Verify bot role permissions
   - Ensure roles exist

## Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Planned Features

- Welcome image generator
- Interactive welcome messages
- Advanced role management
- Custom welcome workflows
- Multi-language support

## Support

Need help?
1. Check the [Issues](https://github.com/laggis/Welcome-Discord-bot/issues) page
2. Create a new issue with detailed information
3. Include error messages and steps to reproduce

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Created by Laggis

## Best Practices

1. **Security:**
   - Keep your bot token private
   - Regularly update dependencies
   - Monitor bot permissions

2. **Performance:**
   - Limit welcome message size
   - Use caching when possible
   - Clean up temporary roles

3. **Customization:**
   - Test messages before deployment
   - Keep backup of configurations
   - Document custom changes

## Notes

- Regular updates recommended
- Backup your config files
- Monitor Discord API changes
- Test in development server first
