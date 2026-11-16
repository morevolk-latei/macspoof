# macspoof 🍏⚡

> Fast, reliable MAC address changer and reset utility built exclusively for **Apple Silicon (M1, M2, M3, M4)** Macs.

[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-M1%20%7C%20M2%20%7C%20M3%20%7C%20M4-000000?style=flat&logo=apple)](https://github.com/morevolk-latei/macspoof)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20ARM64-lightgrey.svg)](https://github.com/morevolk-latei/macspoof)

`macspoof` makes changing and resetting your network interface MAC address seamless on modern Apple Silicon Macs. It generates compliant IEEE unicast addresses, handles Apple Silicon Wi-Fi state clearing, and recovers your factory hardware MAC with one command.

---

## ⚡ Quick Start

### 1-Line Installation (Curl)
```bash
curl -fsSL https://raw.githubusercontent.com/morevolk-latei/macspoof/main/install.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/morevolk-latei/macspoof.git
cd macspoof
./install.sh
```

---

## 🚀 Usage

### 1. Check Status
View your current active MAC, permanent factory hardware MAC, and spoofing state:
```bash
macspoof
# or
macspoof status
```
*Output:*
```text
Apple Silicon: Apple M4 (arm64)
Interface:     en0 (Wi-Fi)
Current MAC:   ee:5c:7a:fd:45:4e
Hardware MAC:  ac:07:75:35:bf:90
Status:        SPOOFED (Custom / Randomized MAC in use)
```

### 2. Randomize MAC Address
Generate and apply a random, valid unicast MAC address:
```bash
macspoof random
```

### 3. Reset to Factory Hardware MAC
Instantly revert back to your Mac's factory hardware MAC address:
```bash
macspoof reset
```

### 4. Set a Specific Custom MAC
```bash
macspoof set 02:4a:bc:12:34:56
```

### 5. List All Network Interfaces
```bash
macspoof list
```

### 6. Scripting / Automation
Output only the MAC string (ideal for piping or variable assignment):
```bash
CURRENT_MAC=$(macspoof status --raw)
echo "My active MAC is $CURRENT_MAC"
```

---

## 🛠️ Commands & Options

| Command / Option | Description |
| :--- | :--- |
| `status` | Show active interface, current MAC, hardware MAC, and status (default) |
| `random`, `rand` | Generate and apply a random valid unicast MAC address |
| `reset`, `restore` | **Reset interface back to factory hardware MAC address** |
| `set <mac>` | Set a specific 12-digit hexadecimal MAC address |
| `list` | Display all detected hardware interfaces and active MACs |
| `-i, --interface <iface>` | Target a specific network interface (e.g. `macspoof -i en4 random`) |
| `-r, --raw` | Print only the MAC address string |
| `-v, --version` | Display version and Apple Silicon chip info |
| `-h, --help` | Display help screen |

---

## 💡 How It Works on Apple Silicon

* **M-Series Hardware Check**: Validates that your machine is running on Apple Silicon (`arm64` and `Apple M*`).
* **IEEE 802 Compliance**: Generated random addresses always set bit 0 to `0` (unicast) and bit 1 to `1` (locally administered). Switches and routers will not reject them as multicast.
* **Apple Silicon Association Lock Bypass**: On macOS Sonoma & Sequoia, Apple Silicon unified Wi-Fi/Bluetooth controllers block MAC changes with `ioctl (SIOCAIFADDR): Can't assign requested address` if associated. `macspoof` cycles power and applies the new MAC within a fast sub-second window before auto-association triggers.
* **Zero Sudo Friction for Reads**: Status checks and interface listings run with regular user permissions. Sudo is only requested when modifying network settings.

---

## ⚠️ Notes & Caveats

1. **Reboot Reset**: In macOS, all MAC address modifications made via `ifconfig` are stored in volatile memory. Restarting your Mac automatically reverts all interfaces back to their factory hardware addresses.
2. **Apple Private Wi-Fi Address**: If macOS's built-in *Private Wi-Fi Address* is enabled (*System Settings > Wi-Fi > [Network Details]*), macOS may rotate the MAC address independently upon reconnecting.
3. **Enterprise 802.1X Networks**: Changing your MAC address on corporate, university, or 802.1X networks can invalidate your certificate/RADIUS session and require re-authentication.

---

## 🗑️ Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/morevolk-latei/macspoof/main/uninstall.sh | bash
# or from local repo:
./uninstall.sh
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
