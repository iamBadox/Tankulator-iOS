# Tankulator iOS

Native SwiftUI iPhone app — the iOS version of [Tankulator](https://github.com/iamBadox/Tankulator).

Calculate the cost of a road trip based on fuel consumption, fuel price, and wear & tear.

## Features

- ⛽ Fuel mode (L/mil) and ⚡ Electric mode (kWh/mil)
- 🇸🇪 Swedish and 🇬🇧 English
- Dual totals — cost without wear & tear, and full cost including it
- Wear & tear calculated at 1.85 kr/km (Transportstyrelsen / Skatteverket standard rate)
- Accepts both comma and dot as decimal separator

## Setup in Xcode

1. Open Xcode → **File → New → Project**
2. Choose **iOS → App**, click Next
3. Set:
   - **Product Name:** `Tankulator`
   - **Interface:** SwiftUI
   - **Language:** Swift
4. Save the project to a folder of your choice
5. In the project navigator, **delete** the auto-generated `ContentView.swift`
6. **Drag in** the three files from this repo into the Xcode project:
   - `TankulatorApp.swift`
   - `TankulatorModel.swift`
   - `ContentView.swift`
7. Press **▶ Run** — done!

## Files

| File | Purpose |
|---|---|
| `TankulatorApp.swift` | App entry point |
| `TankulatorModel.swift` | All strings, calculation logic, number parsing |
| `ContentView.swift` | Full SwiftUI interface |
