# 📱 iOS Proxy-Aware IP Fetcher — Flutter App

A lightweight Flutter application that fetches the device’s **public IP address** by leveraging native iOS networking (via `NSURLSession`) that respects **system-level proxies and tunnels** like Safari does.

---

## 🔧 Purpose

This app helps detect the **actual public IP** used by the device — whether it's using a direct internet connection or a tunnel (e.g., VPN, PAC proxy, or local proxy server). It’s especially useful when you're working in **cloud environments or dynamic networks**.

---

## 🧩 How It Works

- Flutter UI uses a platform channel to invoke a native Swift method.
- Native iOS code performs an HTTP request to `https://api.ipify.org`.
- The request is routed via `URLSession.shared`, which is **proxy-aware**.
- The public IP returned matches what Safari sees (not just raw device IP).

---

## 🚀 Features

- ✅ Accurate public IP retrieval via proxy/tunnel
- ✅ Respects system-wide proxy config
- ✅ Native implementation for high accuracy
- ✅ Clean, minimal UI

---

## 📂 Project Structure

| File               | Description                              |
|--------------------|------------------------------------------|
| `main.dart`        | Flutter UI and platform channel logic    |
| `AppDelegate.swift`| iOS proxy-aware networking using `NSURLSession` |
| `exportOptions.plist` | Used for code signing/exporting `.ipa` |

---

## 🏗️ Build & Export `.ipa`

```bash
# 1. Clean old build
flutter clean

# 2. Get packages
flutter pub get

# 3. Build iOS app for release
flutter build ios --release

# 4. Export a signed .ipa (automatic signing via Xcode settings)
flutter build ipa --release
