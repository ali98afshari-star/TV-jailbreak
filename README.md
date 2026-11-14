# TV-jailbreak 📺

**Universal Android TV Customizer** — یک ابزار تمام‌دریک برای کاستومایز کردن تلویزیون‌های اندرویدی (Snowa، برندهای مشابه، و هر Android TV با روت) با رابط کاربری RTL فارسی/انگلیسی، اپ دسکتاپ (Electron + Vue 3)، اپ اندروید (Capacitor + Vue 3)، و اسکریپت‌های شل سبک.

[![Release](https://img.shields.io/github/v/release/ali98afshari-star/TV-jailbreak?style=flat-square)](https://github.com/ali98afshari-star/TV-jailbreak/releases)
[![License](https://img.shields.io/github/license/ali98afshari-star/TV-jailbreak?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20%7C%20Android%20%7C%20macOS-blue?style=flat-square)](https://github.com/ali98afshari-star/TV-jailbreak/releases)
[![Build](https://img.shields.io/github/actions/workflow/status/ali98afshari-star/TV-jailbreak/build-release.yml?style=flat-square)](https://github.com/ali98afshari-star/TV-jailbreak/actions)

---

## ✨ ویژگی‌ها

| ماژول | توضیح |
|--------|-------|
| 🏠 **لانچر** | غیرفعال کردن لانچر استوک (Snowa/Generic) و تنظیم Projectivy/FLauncher به عنوان پیش‌فرض |
| 📡 **بلوتوث** | اتصال خودکار کنترل بلوتوث (RSS-18KB و مشابه) پس از ریبوت بدون نیاز به انپیربندی دستی |
| 🎮 **کی‌مپر** | مپ دکمه‌های ریموت: HDMI → Recent Apps، Voice → Google Assistant، Live TV → Lancher |
| ♿ **اکسسبلیتی** | فعال‌سازی خودکار سرویس دسترسی برای لانچر کاستوم |
| 🔌 **ADB** | حفظ پورت ۵۵۵۵ باز، ریستارت خودکار adbd، اتصال 지속ی |
| 🖱️ **پوینتر** | تنظیم سرعت موس/کنترل روی -5 (پیش‌فرض) |

### 🎯 پشتیبانیجهزة
- ✅ **Snowa TV** (KGZN MTK و مدل‌های مشابه)
- ✅ **تمام Android TV با روت** (Magisk / KernelSU)
- ✅ برندهای ایرانی و بین‌المللی با Android TV OS

---

## 📥 دانلود و نصب

### 🖥️ اپ دسکتاپ (Electron)

| پلتفرم | فایل | نصب |
|---------|------|-----|
| **Linux** | `TV-jailbreak-<version>.AppImage` | `chmod +x *.AppImage && ./*.AppImage` |
| **Linux** | `TV-jailbreak-<version>.deb` | `sudo dpkg -i *.deb` |
| **Windows** | `TV-jailbreak-Setup-<version>.exe` | اجرای نصب‌کننده |
| **Windows** | `TV-jailbreak-<version>-portable.exe` | مستقیم اجرا |

### 📱 اپ اندروید (Capacitor)

| نوع | فایل | نصب |
|-----|------|-----|
| **Debug** | `tv-jailbreak-debug.apk` | `adb install tv-jailbreak-debug.apk` |
| **Release** | `tv-jailbreak-release.aab` | برای Play Store (نیاز به امضاء) |

### 🐚 اسکریپت‌های شل (Standalone)

```bash
# دانلود و استخراج
wget https://github.com/ali98afshari-star/TV-jailbreak/releases/latest/download/tv-jailbreak-scripts.tar.gz
tar -xzf tv-jailbreak-scripts.tar.gz
cd scripts

# اجرا
./tv-customizer.sh -i 192.168.1.100 -p 5555
```

---

## 🚀 پیش‌نیازها

1. **روت دسترسی** — Magisk (v26+) یا KernelSU
2. **ADB over Network** — در Developer Options فعال باشد
3. **پورت ۵۵۵۵** — باز و در دسترس
4. **لانچر Projectivy** — از قبل نصب شده (`com.spocky.projengmenu`)
5. **کنترل بلوتوث** — یک بار دستی پیربندی شده (RSS-18KB یا مشابه)

> ⚠️ **توجه**: این ابزار نیاز به روت دارد. استفاده از خودتان مسئولیت‌تان است.

---

## 📖 راهنمای استفاده

### رابط گرافیکی (Desktop / Android)

1. برنامه را باز کنید
2. تب **دستگاه‌ها** → IP و پورت TV را وارد کنید → **اتصال**
3. تب **ماژول‌ها** → ماژول‌های مورد نظر را فعال کنید
4. تب **داشبورد** → **🚀 اجرای کامل** یا عملیات سریع جداگانه

### خط فرمان (Scripts)

```bash
# اتصال و اجرای کامل
./tv-customizer.sh -i 192.168.1.100 -p 5555

# فقط ماژول خاص
./tv-customizer.sh -i 192.168.1.100 -m launcher,bluetooth

# تست ADB
./tv-customizer.sh --test-adb 192.168.1.100:5555

# نمایش راهنما
./tv-customizer.sh --help
```

**پارامترها:**
| پارامتر | پیش‌فرض | توضیح |
|----------|---------|-------|
| `-i, --ip` | — | آدرس IP TV (اجباری) |
| `-p, --port` | `5555` | پورت ADB |
| `-l, --launcher` | `com.spocky.projengmenu` | پکیج لانچر دلخواه |
| `-s, --stock` | `ir.huma.android.launcher` | پکیج لانچر استوک |
| `-m, --modules` | `all` | ماژول‌های اجرا (کاما جدا) |
| `--pointer` | `-5` | سرعت پوینتر |
| `--no-root-check` | false | 건너뛰ی بررسی روت |

---

## 🏗️ ساخت از منبع (Development)

### پیش‌نیازهای بیلد
- **Node.js 20+**
- **Java 17** (برای Android)
- **Android SDK** (API 34)
- **pnpm** یا npm

### کلون و نصب

```bash
git clone https://github.com/ali98afshari-star/TV-jailbreak.git
cd TV-jailbreak
```

#### اپ دسکتاپ
```bash
cd dashboard
npm install
npm run dev          # desarrollo
npm run build:linux  # بیلد Linux
npm run build:win    # بیلد Windows
```

#### اپ اندروید
```bash
cd android
npm install
npm run build        # بیلد وب
npx cap add android  # یک بار
npx cap sync android
npx cap run android  # اجرا روی دستگاه/امولاتور
```

#### اسکریپت‌ها
```bash
cd scripts
./tv-customizer.sh --help
```

---

## 📁 ساختار پروژه

```
TV-jailbreak/
├── .github/
│   └── workflows/
│       └── build-release.yml      # CI/CD برای بیلد و ریلیز
├── dashboard/                     # Electron + Vue 3 (Desktop)
│   ├── src/
│   │   ├── main.js                # Electron main process
│   │   ├── preload.js             # Secure IPC bridge
│   │   └── renderer/              # Vue 3 App
│   │       ├── App.vue
│   │       ├── main.js
│   │       ├── router/
│   │       ├── components/
│   │       └── styles/rtl.css     # RTL Persian styles
│   ├── package.json
│   └── vite.config.js
├── android/                       # Capacitor + Vue 3 (Android)
│   ├── src/
│   │   ├── App.vue
│   │   ├── main.js
│   │   ├── router/
│   │   └── styles/main.css
│   ├── capacitor.config.json
│   ├── package.json
│   └── vite.config.js
├── scripts/                       # Shell Scripts (Standalone)
│   ├── tv-customizer.sh           # Main entry point
│   ├── lib/
│   │   └── common.sh              # Shared functions, ADB wrapper
│   └── modules/
│       ├── launcher.sh            # Launcher switcher
│       ├── bluetooth.sh           # Bluetooth stabilizer
│       ├── keymapper.sh           # Key mapper daemon
│       ├── accessibility.sh       # Accessibility auto-grant
│       ├── adb-persistence.sh     # ADB port 5555 persistence
│       └── pointer.sh             # Pointer speed setter
├── docs/                          # Documentation
├── LICENSE
└── README.md
```

---

## 🔧 تنظیمات محیطی

### متغیرهای محیطی (Scripts)

```bash
export TV_IP="192.168.1.100"
export TV_PORT="5555"
export LAUNCHER_PKG="com.spocky.projengmenu"
export STOCK_LAUNCHER="ir.huma.android.launcher"
export POINTER_SPEED="-5"
export KEYMAPPER_ENABLED="true"
export BLUETOOTH_FIX_ENABLED="true"
export ACCESSIBILITY_ENABLED="true"
export ADB_PERSISTENCE_ENABLED="true"
```

### تنظیمات دسکتاپ/اندروید
تنظیمات در `localStorage` (مرورگر) یا `SharedPreferences` (اندروید) ذخیره می‌شوند و شامل:
- IP/پورت TV
- پکیج لانچر
- ماژول‌های فعال
- سرعت پوینتر

---

## 🤝 مشارکت

1. Fork کنید
2. Branch بسازید: `git checkout -b feature/amazing-feature`
3. Commit کنید: `git commit -m 'Add amazing feature'`
4. Push کنید: `git push origin feature/amazing-feature`
5. Pull Request باز کنید

### استانداردهای کد
- **Shell**: ShellCheck clean، POSIX compliant
- **Vue/JS**: ESLint + Prettier، Composition API
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)

---

## 📄 لایسنس

MIT License — آزاد برای استفاده، تغییر، و توزیع.

---

## 🙏 تشکر

- [Projectivy Launcher](https://github.com/projectivy-launcher) — لانچر عالی برای Android TV
- [Vazirmatn Font](https://github.com/rastikerdar/vazirmatn) — فونت فارسی زیبا
- [Capacitor](https://capacitorjs.com/) — کراس‌پلتفرم وب به نیتیو
- [Electron](https://www.electronjs.org/) — اپلیکیشن دسکتاپ از وب

---

## 📞 پشتیبانی

- **Issues**: [GitHub Issues](https://github.com/ali98afshari-star/TV-jailbreak/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ali98afshari-star/TV-jailbreak/discussions)
- **Releases**: [Latest Release](https://github.com/ali98afshari-star/TV-jailbreak/releases/latest)

---

<div align="center">
  <strong>ساخته شده با ❤️ برای جامعه Android TV فارسی</strong><br>
  <sub>TV-jailbreak v1.0.0 — Universal Android TV Customizer</sub>
</div>