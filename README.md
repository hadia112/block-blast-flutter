# Block Blast – Flutter Frontend

Modern Flutter app for the Block Blast puzzle game. Connects to the [block-blast](https://github.com/YOUR_USERNAME/block-blast) backend API.

## Features

- **Modern blocks**: Rounded cells with gradients and subtle shadows
- Create game, place blocks (I, O, T, S, Z, L, J), clear lines, view leaderboard
- Dark theme by default; supports light theme

## Setup

1. Install [Flutter](https://flutter.dev/docs/get-started/install).
2. Start the backend (from the `block-blast` repo):
   ```bash
   cd block-blast && npm install && npm start
   ```
3. Run the app:
   ```bash
   cd block-blast-flutter
   flutter pub get
   flutter run
   ```

### API URL

By default the app uses `http://localhost:3000`. For a device/emulator:

- **Android emulator**: `http://10.0.2.2:3000`
- **iOS simulator**: `http://localhost:3000`
- **Physical device**: Use your machine’s LAN IP, e.g. `http://192.168.1.x:3000`

Change the base URL in `lib/screens/home_screen.dart` and `lib/screens/game_screen.dart` (or add a config/env file) if needed.

## How to play

1. Enter your name and tap **Play**.
2. Pick a block shape (I, O, T, S, Z, L, J).
3. Tap a cell on the grid to place the block there.
4. Full rows are cleared automatically; score and level increase.
5. Tap **End game** to submit your score to the leaderboard.
