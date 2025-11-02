# Download APK on Your Phone

## Method 1: Local Network Server (Recommended)

A local web server is running on your Mac. To download:

1. **Make sure your phone is on the same Wi-Fi network as your Mac**
2. **Open a web browser on your phone** (Chrome, Safari, etc.)
3. **Enter one of these URLs** (replace IP with your Mac's IP):

### Universal APK (49 MB - works on all Android devices):
```
http://YOUR_MAC_IP:8080/app-release.apk
```

### ARM64 APK (18.5 MB - recommended for modern phones):
```
http://YOUR_MAC_IP:8080/app-arm64-v8a-release.apk
```

### Other architecture options:
- **32-bit ARM**: `http://YOUR_MAC_IP:8080/app-armeabi-v7a-release.apk` (16 MB)
- **x86_64**: `http://YOUR_MAC_IP:8080/app-x86_64-release.apk` (19.7 MB)

4. **Tap the download link** - your phone will download the APK
5. **Allow installation from unknown sources** when prompted
6. **Install the APK** and open the app!

## Method 2: Transfer via USB

1. Connect your phone to your Mac via USB
2. Enable USB file transfer on your phone
3. Copy the APK file from:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```
4. Paste it to your phone's Download folder
5. Open the file manager on your phone and install

## Method 3: Cloud Storage

1. Upload `app-release.apk` to Google Drive, Dropbox, or similar
2. Share the link to your phone
3. Download and install on your phone

## Method 4: QR Code (Advanced)

Use a QR code generator to create a QR code with the download URL, then scan it with your phone!

## Stopping the Server

To stop the local server, run:
```bash
kill $(cat /tmp/apk_server.pid)
```

## Troubleshooting

- **Can't access the URL?** Make sure both devices are on the same Wi-Fi network
- **Installation blocked?** Go to Settings → Security → Enable "Install from Unknown Sources"
- **File not found?** Check that the server is still running on port 8080

