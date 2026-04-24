# Changelog

All notable changes to Tankulator iOS will be documented here.

---
## [Security] – 2026-04-16

### Security
- Performed a full security scan using `gitleaks` (secrets detection) and `semgrep` (SAST, 1059 rules). No secrets, hardcoded credentials, insecure URLs, or high-severity issues were found. All clear.

---

## [1.0.1] – 2026-04-24

### Added
- App icon: orange fuel drop and yellow lightning bolt on a deep navy background, representing petrol vs electric

---

## [1.0.0] – 2026-03-27

### Added
- Initial release — full feature parity with Tankulator web app (v3.1.0)
- ⛽ Fuel mode (L/mil + kr/L) and ⚡ Electric mode (kWh/mil + kr/kWh)
- 🇸🇪 Swedish and 🇬🇧 English with flag toggle
- Three inputs: distance (km), consumption, and price
- Full result breakdown: mils, energy/fuel used, price, wear & tear
- Dual totals: cost without wear & tear + total including wear & tear
- Wear & tear at 1.85 kr/km (Transportstyrelsen / Skatteverket rate)
- ℹ info popover with full calculation explanation per mode and language
- Accepts comma or dot as decimal separator
