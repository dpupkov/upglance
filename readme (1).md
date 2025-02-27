# Up Bank Glance for Garmin

A Garmin Connect IQ Glance application that displays your Up Bank account balances directly on your watch.

## Features

- Shows your Up Bank account balances on your Garmin watch
- Updates whenever you view the glance
- Simple configuration via Garmin Connect Mobile app

## Requirements

- Garmin Connect IQ compatible watch
- Connect IQ SDK (minimum version 3.2.0)
- Up Bank account with API token

## Development Setup

1. Install the Connect IQ SDK:
   - Download from [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
   - Follow Garmin's installation instructions for your OS
   
   **For Debian/Ubuntu-based systems (including Chromebook):**
   - Install required dependencies:
     ```
     sudo apt-get install libwebkit2gtk-4.0 libjpeg62-turbo
     ```
   
   **Specific for Debian/Chromebook:**
   - Create a symbolic link for the JPEG library:
     ```
     sudo ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.62 /usr/lib/x86_64-linux-gnu/libjpeg.so.8
     ```

2. Set up your development environment:
   - Install Visual Studio Code
   - Install the Monkey C extension for VS Code
   - Configure the SDK path in the extension settings

3. Clone this repository:
   ```
   git clone https://github.com/dpupkov/upglance.git
   cd upglance
   ```

## Building the Application

1. Open the project in VS Code with the Monkey C extension

2. Build the application:
   ```
   monkeyc -f monkey.jungle -o bin/upglance.prg -d your_device_name
   ```
   
   Replace `your_device_name` with your Garmin device (e.g., `fenix6`, `venu`, etc.)

3. Alternatively, use the Monkey C extension's build task in VS Code

## Installing on Your Watch

### Method 1: Via Garmin Express

1. Connect your watch to your computer
2. Open Garmin Express
3. Navigate to your device
4. Select "Install IQ Apps"
5. Click "Install" and browse to the generated `.prg` file

### Method 2: Via Garmin Connect IQ App Store

1. Create a developer account at [Connect IQ](https://developer.garmin.com/connect-iq/)
2. Package and submit your app
3. Once approved, install via the Connect IQ app store

### Method 3: Sideloading for Testing

1. Enable Developer Mode on your watch
2. Use the Monkey C command:
   ```
   monkeydo bin/upglance.prg your_device_name
   ```

## Configuration

After installing the app on your watch:

1. Open the Garmin Connect Mobile app
2. Go to "More" > "Connect IQ Store" > "My Apps"
3. Find "Up Bank Glance" and tap on it
4. Tap "Settings"
5. Enter your Up Bank API token and preferred account name

## Getting an Up Bank API Token

1. Log in to your Up Bank account
2. Go to the "Developer Tools" section
3. Create a new API token
4. Copy the token to use in the app settings

## Usage

1. On your watch, swipe to the Glance screens
2. The Up Bank Glance will automatically fetch and display your account balance
3. The display will show your selected account name and current balance

## Privacy & Security

Your API token is stored only on your device and is used solely to authenticate with the Up Bank API. No data is shared with any third parties.

## License

MIT License - See LICENSE file for details
