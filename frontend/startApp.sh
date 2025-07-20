#!/bin/bash

set -e

# List available simulators (optional, for debug)
xcrun simctl list devices

# Boot specific simulator (replace with your actual device ID)
SIMULATOR_ID="FC47F0E0-766C-4DE2-BCCE-B8221E62E952"
echo "Booting iOS simulator ($SIMULATOR_ID)..."
xcrun simctl boot "$SIMULATOR_ID" || echo "Simulator already booted."

# Open the simulator
open -a Simulator
# Wait a bit to ensure simulator is ready
sleep 5

# Launch the Flutter app on iOS simulator
echo "🚀 Running Flutter app on iOS simulator..."
flutter run
