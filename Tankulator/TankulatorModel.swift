import Foundation

// MARK: - Mode & Language

enum FuelMode {
    case fuel, ev

    var icon: String { self == .fuel ? "⛽" : "⚡" }
}

enum AppLanguage {
    case swedish, english
}

// MARK: - Strings

struct Strings {
    let subtitle: String
    let labelDistance: String
    let labelConsumption: String
    let labelFuelPrice: String
    let unitConsumption: String
    let unitFuelPrice: String
    let hint: String
    let consumptionPlaceholder: String
    let fuelPricePlaceholder: String
    let rEnergy: String
    let rPrice: String
    let tooltipText: String

    // Shared (same across fuel/ev within a language)
    let btnCalculate: String
    let errorText: String
    let breakdown: String
    let rDistance: String
    let rMil: String
    let rWear: String
    let rTotalExcl: String
    let rTotalIncl: String
}

extension Strings {
    static func get(lang: AppLanguage, mode: FuelMode) -> Strings {
        switch (lang, mode) {

        case (.swedish, .fuel):
            return Strings(
                subtitle: "Beräkna kostnaden för din resa",
                labelDistance: "Körsträcka",
                labelConsumption: "Bränsleförbrukning",
                labelFuelPrice: "Pris för drivmedel",
                unitConsumption: "L/mil",
                unitFuelPrice: "kr/L",
                hint: "1 mil = 10 km  ·  t.ex. 0,7 L/mil är mycket bra",
                consumptionPlaceholder: "0,0",
                fuelPricePlaceholder: "0,00",
                rEnergy: "Bränsle",
                rPrice: "Drivmedelspris",
                tooltipText: "Antal mil = körsträcka ÷ 10\nBränsle = mil × förbrukning (L/mil)\nBränslekostnad = bränsle × pris per liter\n\nSlitage = körsträcka × 1,85 kr/km\nBaserat på Skatteverkets och Transportstyrelsens schablonbelopp.\n\nTotalt = bränslekostnad + slitage",
                btnCalculate: "Beräkna",
                errorText: "Fyll i alla fält med giltiga värden.",
                breakdown: "Reseöversikt",
                rDistance: "Körsträcka",
                rMil: "Antal mil",
                rWear: "Slitage (1,85 kr/km)",
                rTotalExcl: "Kostnad utan slitage",
                rTotalIncl: "Total kostnad (inkl. slitage)"
            )

        case (.swedish, .ev):
            return Strings(
                subtitle: "Beräkna kostnaden för din elresa",
                labelDistance: "Körsträcka",
                labelConsumption: "Elförbrukning",
                labelFuelPrice: "Elpris",
                unitConsumption: "kWh/mil",
                unitFuelPrice: "kr/kWh",
                hint: "1 mil = 10 km  ·  t.ex. 1,5 kWh/mil är mycket bra",
                consumptionPlaceholder: "0,0",
                fuelPricePlaceholder: "0,00",
                rEnergy: "Förbrukad el",
                rPrice: "Elpris",
                tooltipText: "Antal mil = körsträcka ÷ 10\nFörbrukad el = mil × förbrukning (kWh/mil)\nElkostnad = förbrukad el × elpris (kr/kWh)\n\nSlitage = körsträcka × 1,85 kr/km\nSlitage gäller även elbilar. Baserat på Transportstyrelsens schablonbelopp.\n\nTotalt = elkostnad + slitage",
                btnCalculate: "Beräkna",
                errorText: "Fyll i alla fält med giltiga värden.",
                breakdown: "Reseöversikt",
                rDistance: "Körsträcka",
                rMil: "Antal mil",
                rWear: "Slitage (1,85 kr/km)",
                rTotalExcl: "Kostnad utan slitage",
                rTotalIncl: "Total kostnad (inkl. slitage)"
            )

        case (.english, .fuel):
            return Strings(
                subtitle: "Calculate the cost of your road trip",
                labelDistance: "Distance driven",
                labelConsumption: "Fuel consumption",
                labelFuelPrice: "Fuel price",
                unitConsumption: "L/mil",
                unitFuelPrice: "kr/L",
                hint: "1 mil = 10 km  ·  e.g. 0.7 L/mil is very efficient",
                consumptionPlaceholder: "0.0",
                fuelPricePlaceholder: "0.00",
                rEnergy: "Fuel consumed",
                rPrice: "Fuel price",
                tooltipText: "Mils driven = distance ÷ 10\nFuel used = mils × consumption (L/mil)\nFuel cost = fuel used × price per litre\n\nWear & tear = distance × 1.85 kr/km\nBased on the rate set by the Swedish Transport Agency (Transportstyrelsen), used for tax deductions.\n\nTotal = fuel cost + wear & tear",
                btnCalculate: "Calculate",
                errorText: "Please fill in all fields with valid values.",
                breakdown: "Trip breakdown",
                rDistance: "Distance",
                rMil: "Mils driven",
                rWear: "Wear & tear (1.85 kr/km)",
                rTotalExcl: "Cost excl. wear & tear",
                rTotalIncl: "Total cost (incl. wear & tear)"
            )

        case (.english, .ev):
            return Strings(
                subtitle: "Calculate the cost of your electric road trip",
                labelDistance: "Distance driven",
                labelConsumption: "Energy consumption",
                labelFuelPrice: "Electricity price",
                unitConsumption: "kWh/mil",
                unitFuelPrice: "kr/kWh",
                hint: "1 mil = 10 km  ·  e.g. 1.5 kWh/mil is very efficient",
                consumptionPlaceholder: "0.0",
                fuelPricePlaceholder: "0.00",
                rEnergy: "Energy used",
                rPrice: "Electricity price",
                tooltipText: "Mils driven = distance ÷ 10\nEnergy used = mils × consumption (kWh/mil)\nEnergy cost = energy used × electricity price (kr/kWh)\n\nWear & tear = distance × 1.85 kr/km\nWear & tear applies to electric cars too. Based on the rate set by Transportstyrelsen.\n\nTotal = energy cost + wear & tear",
                btnCalculate: "Calculate",
                errorText: "Please fill in all fields with valid values.",
                breakdown: "Trip breakdown",
                rDistance: "Distance",
                rMil: "Mils driven",
                rWear: "Wear & tear (1.85 kr/km)",
                rTotalExcl: "Cost excl. wear & tear",
                rTotalIncl: "Total cost (incl. wear & tear)"
            )
        }
    }
}

// MARK: - Calculation

struct TripResult {
    let mils: Double
    let energyUsed: Double
    let energyCost: Double
    let wearCost: Double
    let totalExcl: Double
    let totalIncl: Double
    let energyUnit: String
    let priceUnit: String
}

struct Calculator {
    static let wearRate = 1.85

    static func calculate(distance: Double, consumption: Double, price: Double, mode: FuelMode) -> TripResult {
        let mils       = distance / 10
        let energy     = mils * consumption
        let energyCost = energy * price
        let wearCost   = distance * wearRate
        return TripResult(
            mils: mils,
            energyUsed: energy,
            energyCost: energyCost,
            wearCost: wearCost,
            totalExcl: energyCost,
            totalIncl: energyCost + wearCost,
            energyUnit: mode == .ev ? "kWh" : "L",
            priceUnit: mode == .ev ? "kr/kWh" : "kr/L"
        )
    }
}

// MARK: - Number parsing

func parseNumber(_ text: String) -> Double? {
    let cleaned = text.trimmingCharacters(in: .whitespaces)
                      .replacingOccurrences(of: " ", with: "")
                      .replacingOccurrences(of: ",", with: ".")
    return Double(cleaned)
}
