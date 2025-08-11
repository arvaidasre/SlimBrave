<div align="center">

# SlimBrave
<img src="https://github.com/user-attachments/assets/3e90a996-a74a-4ca1-bea6-0869275bab58" width="200" height="300">
</div>

---

## Ultimate Brave Browser Debloater

SlimBrave v2.0 is a comprehensive PowerShell script designed for Windows users to completely strip down their Brave Browser and maximize privacy, security, and performance. With over 60+ configurable options, SlimBrave gives you granular control over every aspect of Brave's functionality.

### Features:

<details>
<summary> Click here to view </summary>

- **Disable Brave Rewards**  
   Brave's reward system.

- **Disable Brave Wallet**  
   Brave's Wallet feature for managing cryptocurrencies.

- **Disable Brave VPN**  
   Brave's VPN feature for "enhanced" privacy.

- **Disable Brave AI Chat**  
   Brave's integrated AI Chat feature.

- **Disable Password Manager**  
   Brave's built-in password manager for website login credentials.

- **Disable Tor**  
   Tor functionality for "anonymous" browsing.

- **Set DNS Over HTTPS Mode**  
   Set the DNS Over HTTPS mode (options include automatic or off) to ensure private browsing with secure DNS queries.

- **Disable Sync**  
   Sync functionality that synchronizes your data across devices.

- **Telemetry & Reporting Controls**  
   Disable metrics reporting, safe browsing reporting, and data collection.

- **Privacy & Security Options**  
   Manage autofill, WebRTC, QUIC protocol, and more.

- **Performance Optimization**  
   Disable background processes and unnecessary features.

- **Enable Do Not Track**  
   Forces Do Not Track header for all browsing.

- **Force Google SafeSearch**  
   Enforces SafeSearch across Google searches.

- **Disable IPFS**  
   Disables InterPlanetary File System support.

- **Disable Spellcheck**  
   Disables browser spellcheck functionality.

- **Disable Browser Sign-in**  
   Prevents browser account sign-in.

- **Disable Printing**  
   Disables web page printing capability.

- **Disable Incognito Mode**  
   Blocks private browsing/incognito mode.

- **Disable Default Browser Prompt**  
   Stops Brave from asking to be default browser.

- **Disable Developer Tools**  
   Blocks access to developer tools.

- **Always Open PDF Externally**  
   Forces PDFs to open in external applications.

- **Disable Brave Shields**  
   Turns off Brave's built-in Shields protection.

- **Advanced Hardware Controls**  
   Disable hardware acceleration, WebGL, WebAssembly for enhanced security.

- **Media & Device Access Control**  
   Block camera, microphone, geolocation, push notifications, and device APIs.

- **Web Technology Blocking**  
   Disable WebUSB, WebBluetooth, WebMIDI, WebXR, WebNFC for maximum security.

- **Cryptocurrency Features Removal**  
   Remove all crypto-related features including Binance widget, NFT discovery, Ethereum/Solana providers.

- **AI & Smart Features Disable**  
   Turn off Leo AI Assistant, Brave AI Chat, sidebar, speedreader, and playlist features.

- **Network Security Enhancements**  
   Disable QUIC protocol, HTTP/2 server push, background sync, and preloading.

- **Strict JavaScript Controls**  
   Block JavaScript JIT compilation and enforce strict referrer policies.

- **Complete Telemetry Blackout**  
   Remove all forms of data collection, metrics, and reporting.

- **Background Process Elimination**  
   Stop all background tasks, component updates, and unnecessary services.
</details>

---

# How to Run

### Run the command below in PowerShell:

```ps1
iwr "https://raw.githubusercontent.com/ltx0101/SlimBrave/main/SlimBrave.ps1" -OutFile "SlimBrave.ps1"; .\SlimBrave.ps1
```

---

## Extras:

<details>
<summary> Presets </summary>

- **Ultimate Privacy Preset** 🔒  
   - Complete privacy lockdown with all 60+ features disabled
   - Blocks ALL telemetry, tracking, and data collection
   - Disables hardware acceleration, WebGL, WebAssembly, and all device APIs
   - Removes all cryptocurrency features and AI assistants
   - Eliminates background processes and network predictions
   - DNS: Completely disabled (maximum privacy)
   - Best for: Security researchers, privacy activists, and maximum anonymity needs

- **Maximum Privacy Preset**  
   - Telemetry: Blocks all reporting (metrics, safe browsing, URL collection, feedback).
   - Privacy: Disables autofill, password manager, sign-in, WebRTC leaks, QUIC, and forces Do Not Track.
   - Brave Features: Kills Rewards, Wallet, VPN, AI Chat, Tor, and Sync.
   - Performance: Disables background processes, recommendations, and bloat.
   - Hardware: Blocks WebGL, camera/mic access, and geolocation.
   - DNS: Uses plain DNS (no HTTPS) to prevent potential logging by DoH providers.
   - Best for: Paranoid users, journalists, activists, or anyone who wants Brave as private as possible.

- **Minimal Footprint Preset** ⚡  
   - Removes bloatware while maintaining basic functionality
   - Disables crypto features, AI assistants, and promotional content
   - Blocks telemetry and unnecessary background processes
   - Keeps essential security features enabled
   - DNS: Automatic DoH for security
   - Best for: Users who want a clean, fast browser without going full privacy mode

- **Balanced Privacy Preset**  
   - Telemetry: Blocks all tracking but keeps basic safe browsing.
   - Privacy: Blocks third-party cookies, enables Do Not Track, but allows password manager and autofill for addresses.
   - Brave Features: Disables Rewards, Wallet, VPN, and AI features.
   - Performance: Turns off background services and ads.
   - DNS: Uses automatic DoH (lets Brave choose the fastest secure DNS).
   - Best for: Most users who want privacy but still need convenience features.

- **Performance Focused Preset**  
   - Telemetry: Only blocks metrics and feedback surveys (keeps some safe browsing).
   - Brave Features: Disables Rewards, Wallet, VPN, and AI to declutter the browser.
   - Performance: Kills background processes, shopping features, and promotions.
   - DNS: Automatic DoH for a balance of speed and security.
   - Best for: Users who want a faster, cleaner Brave without extreme privacy tweaks.

- **Developer Preset**  
   - Telemetry: Blocks all reporting.
   - Brave Features: Disables Rewards, Wallet, and VPN but keeps developer tools.
   - Performance: Turns off background services and ads.
   - DNS: Automatic DoH (default secure DNS).
   - Best for: Developers who need dev tools but still want telemetry and ads disabled.

- **Strict Parental Controls Preset**  
   - Privacy: Blocks incognito mode, forces Google SafeSearch, and disables sign-in.
   - Brave Features: Disables Rewards, Wallet, VPN, Tor, and dev tools.
   - DNS: Uses custom DoH (can be set to a family-friendly DNS like Cloudflare for Families).
   - Best for: Parents, schools, or workplaces that need restricted browsing.


</details>



<details>
<summary> Requirements </summary>

- Windows 10/11
- PowerShell
- Administrator privileges
</details>

<details>
<summary>Error "Running Scripts is Disabled on this System"</summary>

### Run this command in PowerShell:

```ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```
</details>
<div align="center">
  
---

🌟 **Like this project? Give it a star!** 🌟  
💻  **Want to contribute? PRs are welcome!** 💻 

</div>

### Why SlimBrave v2.0 Matters

SlimBrave v2.0 represents the most comprehensive Brave debloating solution available:
- 🔥 **60+ Privacy & Security Options** - Complete control over every aspect
- 🚀 **Maximum Performance** - Remove all bloatware and background processes  
- 🛡️ **Ultimate Privacy** - Block all telemetry, tracking, and data collection
- 🎯 **Granular Control** - Choose exactly what you want disabled
- 📱 **Modern UI** - Scrollable interface with advanced preset management
- ⚙️ **Smart Presets** - From minimal footprint to ultimate privacy lockdown

---

### What's New in v2.0
- ✅ **60+ Configuration Options** (doubled from v1.0)
- ✅ **Advanced Hardware Controls** (WebGL, WebAssembly, Hardware Acceleration)
- ✅ **Complete Crypto Removal** (All Web3/NFT/DeFi features)
- ✅ **AI Features Blocking** (Leo Assistant, Brave AI Chat)
- ✅ **Network Security Hardening** (HTTP/2, QUIC, WebRTC improvements)
- ✅ **Modern Device API Blocking** (WebUSB, WebBluetooth, WebXR, WebNFC)
- ✅ **Enhanced UI** with scrollable panels and bulk operations
- ✅ **New Ultimate Privacy Preset** - Maximum anonymity configuration
- ✅ **Minimal Footprint Preset** - Clean browser without privacy extremes

### Future Roadmap
- [x] Add preset configurations (Privacy, Performance, etc.)
- [x] Create backup/restore functionality
- [x] Advanced privacy controls (v2.0)
- [x] Cryptocurrency features removal (v2.0)
- [x] AI and smart features blocking (v2.0)
- [ ] Add support for Linux/Mac (WIP)
- [ ] Browser fingerprinting protection (v3.0)

---
<div align="center">
   
[![PayPal Donate](https://img.shields.io/badge/PayPal_Donate-s?style=for-the-badge&logo=paypal&logoColor=black)](https://paypal.me/AggelosMeta)

</div>

<div align="center">
  
Made with ❤️ and PowerShell  

</div>
