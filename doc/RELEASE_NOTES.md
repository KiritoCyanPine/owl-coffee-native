## Owl Coffee is a simple, fast, and easy-to-use app to keep your mac awake. 🥱

## ☕️ Caffeinate your PC now !!

### Features

- **Prevents sleep:** Stops your Mac from entering sleep mode
- **Prevents display sleep:** Keeps the screen from turning off
- **Prevents disk sleep:** Keeps hard drives spinning
- **Prevents system idle sleep:** Maintains system activity

### Installation

Download the latest release.
The application is not yet signed by me, so you'll need to run the following command from the terminal to run the application:

```bash
xattr -d com.apple.quarantine $(find ~/Downloads -name "OwlCoffee.dmg" 2>/dev/null)
```

You can also build the app from source by following the instructions in the [Building and Running](https://github.com/KiritoCyanPine/owl-coffee-native/blob/main/README.MD#building-and-running) section.
