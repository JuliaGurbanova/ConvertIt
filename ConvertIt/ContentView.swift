//
//  ContentView.swift
//  ConvertIt
//
//  Created by Julia Gurbanova on 21.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var chosenConverter = 0
    @State private var inputNumber = 0.0
    @State private var inputUnit: Dimension = UnitTemperature.fahrenheit
    @State private var outputUnit: Dimension = UnitTemperature.celsius
    @FocusState private var inputIsFocused: Bool
    
    let converterOptions = ["Temperature", "Length", "Time", "Volume", "Mass"]
    
    let unitOptions = [
        [UnitTemperature.kelvin, UnitTemperature.celsius, UnitTemperature.fahrenheit],
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours, UnitDuration.days],
        [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds]
    ]
    
    let formatter: MeasurementFormatter
    
    var inputConverted: String {
        let inputValue = Measurement(value: inputNumber, unit: inputUnit)
        let outputValue = inputValue.converted(to: outputUnit)
 
        return formatter.string(from: outputValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("What to convert?", selection: $chosenConverter) {
                        ForEach(0..<converterOptions.count) {
                            Text(converterOptions[$0])
                        }
                    }
                }
                
                Section {
                    TextField("Value", value: $inputNumber, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(unitOptions[chosenConverter], id: \.self) {
                            Text($0.symbol)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Amount to convert")
                }
                    
                    Section {
                        Picker("Output unit", selection: $outputUnit) {
                            ForEach(unitOptions[chosenConverter], id: \.self) {
                                Text($0.symbol)
                            }
                        } .pickerStyle(.segmented)
                    } header: {
                        Text("Convert to")
                        
                    }
                    
                    Section {
                        Text(inputConverted)
                    } header: {
                        Text("Result")
                    }
                
                .navigationTitle("Convert Them All!")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            inputIsFocused = false
                        }
                    }
                }
                .onChange(of: chosenConverter) { newSelection in
                    let units = unitOptions[newSelection]
                    inputUnit = units[0]
                    outputUnit = units[1]
                }
            }
            
        }
    }
    
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
    }
}

extension UnitDuration {
    static let days = UnitDuration(symbol: "days", converter: UnitConverterLinear(coefficient: 86400.0))
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
