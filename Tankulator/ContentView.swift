import SwiftUI

struct ContentView: View {
    @State private var mode: FuelMode = .fuel
    @State private var lang: AppLanguage = .swedish
    @State private var distanceText    = ""
    @State private var consumptionText = ""
    @State private var fuelPriceText   = ""
    @State private var result: TripResult? = nil
    @State private var showError = false
    @State private var showTooltip = false
    @FocusState private var focusedField: Field?

    enum Field { case distance, consumption, fuelPrice }

    private var strings: Strings { Strings.get(lang: lang, mode: mode) }
    private var locale: Locale { lang == .swedish ? Locale(identifier: "sv_SE") : Locale(identifier: "en_GB") }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Top bar
                HStack {
                    modeToggle
                    Spacer()
                    langToggle
                }

                // Header
                VStack(spacing: 4) {
                    Text("Tank**ulator** \(mode.icon)")
                        .font(.system(size: 30, weight: .bold))
                    Text(strings.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)

                // Inputs
                VStack(spacing: 16) {
                    inputField(
                        label: strings.labelDistance,
                        placeholder: "0",
                        unit: "km",
                        text: $distanceText,
                        field: .distance
                    )
                    inputField(
                        label: strings.labelConsumption,
                        placeholder: strings.consumptionPlaceholder,
                        unit: strings.unitConsumption,
                        text: $consumptionText,
                        field: .consumption,
                        hint: strings.hint
                    )
                    inputField(
                        label: strings.labelFuelPrice,
                        placeholder: strings.fuelPricePlaceholder,
                        unit: strings.unitFuelPrice,
                        text: $fuelPriceText,
                        field: .fuelPrice
                    )
                }

                // Error
                if showError {
                    Text(strings.errorText)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // Calculate button
                Button(action: calculate) {
                    Text(strings.btnCalculate)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Results
                if let r = result {
                    resultPanel(r)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(24)
            .animation(.easeInOut(duration: 0.2), value: result != nil)
            .animation(.easeInOut(duration: 0.15), value: mode)
            .animation(.easeInOut(duration: 0.15), value: lang)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: mode) { _, _ in recalculate() }
        .onChange(of: lang) { _, _ in recalculate() }
    }

    // MARK: - Mode & Lang toggles

    private var modeToggle: some View {
        HStack(spacing: 0) {
            modeBtn(icon: "⛽", selected: mode == .fuel) { mode = .fuel }
            modeBtn(icon: "⚡", selected: mode == .ev)   { mode = .ev   }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }

    private func modeBtn(icon: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(icon)
                .font(.title3)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? Color(uiColor: .tertiarySystemBackground) : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private var langToggle: some View {
        HStack(spacing: 8) {
            langBtn(flag: "🇸🇪", selected: lang == .swedish) { lang = .swedish }
            langBtn(flag: "🇬🇧", selected: lang == .english) { lang = .english }
        }
    }

    private func langBtn(flag: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(flag)
                .font(.title2)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(selected ? Color.orange : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Input field

    private func inputField(
        label: String,
        placeholder: String,
        unit: String,
        text: Binding<String>,
        field: Field,
        hint: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .kerning(0.8)

            HStack {
                TextField(placeholder, text: text)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: field)
                    .submitLabel(.done)
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(focusedField == field ? Color.orange : Color.gray.opacity(0.2), lineWidth: 1.5)
            )

            if let hint {
                Text(hint)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    // MARK: - Result panel

    private func resultPanel(_ r: TripResult) -> some View {
        VStack(alignment: .leading, spacing: 0) {

            // Title + tooltip
            HStack(spacing: 8) {
                Text(strings.breakdown.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .kerning(0.8)

                Button {
                    showTooltip.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .popover(isPresented: $showTooltip) {
                    ScrollView {
                        Text(strings.tooltipText)
                            .font(.footnote)
                            .padding()
                    }
                    .frame(minWidth: 280)
                    .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.bottom, 12)

            // Breakdown rows
            resultRow(label: strings.rDistance,  value: fmt(r.mils * 10, decimals: 0) + " km")
            resultRow(label: strings.rMil,       value: fmt(r.mils, decimals: 1) + " mil")
            resultRow(label: strings.rEnergy,    value: fmt(r.energyUsed, decimals: 1) + " \(r.energyUnit)")
            resultRow(label: strings.rPrice,     value: fmt(r.energyCost / r.energyUsed * (mode == .ev ? 1 : 1), decimals: 2) + " \(r.priceUnit)",
                      rawValue: "\(fuelPriceText) \(r.priceUnit)")
            resultRow(label: strings.rWear,      value: fmt(r.wearCost, decimals: 2) + " kr")

            Divider().padding(.vertical, 12)

            // Excl. total
            HStack {
                Text(strings.rTotalExcl)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(fmt(r.totalExcl, decimals: 2) + " kr")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 6)

            // Incl. total (main)
            HStack {
                Text(strings.rTotalIncl)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(fmt(r.totalIncl, decimals: 2) + " kr")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func resultRow(label: String, value: String, rawValue: String? = nil) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(rawValue ?? value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 6)
        .overlay(Divider().padding(.leading), alignment: .bottom)
    }

    // MARK: - Formatting

    private func fmt(_ value: Double, decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    // MARK: - Logic

    private func calculate() {
        focusedField = nil
        guard
            let d = parseNumber(distanceText), d > 0,
            let c = parseNumber(consumptionText), c > 0,
            let p = parseNumber(fuelPriceText), p > 0
        else {
            showError = true
            result = nil
            return
        }
        showError = false
        result = Calculator.calculate(distance: d, consumption: c, price: p, mode: mode)
    }

    private func recalculate() {
        if result != nil { calculate() }
    }
}

#Preview {
    ContentView()
}
