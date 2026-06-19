//
//  DateTimePickerField.swift
//  P14-Eventorias
//
//  Created by Jaouad on 12/06/2026.
//

import SwiftUI

/// Composant de formulaire  encapsulant un sélecteur de date ou d'heure pour la saisie d'event
struct DateTimePickerField: View {
    enum Mode { case date, time }
    
    // MARK: - Propriétés
    let label: String
    let placeholder: String
    @Binding var date: Date?
    let mode: Mode
    
    @State private var showSheet = false
    @State private var temp = Date()
    
    /// Formate la date sélectionnée selon le mode choisi pour correspondre au format américain
    private var displayText: String? {
        guard let date else { return nil }
        switch mode {
        case .date: return date.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year()
            .locale(Locale(identifier: "en_US")))               // 07/20/2024
        case .time: return date.formatted(.enUSTime)            // 10:00 AM
        }
    }
    
    // MARK: - Body Principal
    var body: some View {
        Button {
            temp = date ?? Date()
            showSheet = true
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.appFieldLabel)
                Text(displayText ?? placeholder)
                    .foregroundStyle(displayText == nil ? Color.appFieldLabel : Color.appRowText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.appCard, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(displayText ?? "non défini")
        .accessibilityHint(mode == .date ? "Ouvre un calendrier pour choisir une date" : "Ouvre un sélecteur pour choisir une heure")
        // Extraction de la feuille pour alléger le compilateur
        .sheet(isPresented: $showSheet) {
            pickerSheetContent
        }
    }
    
    // MARK: - Sous-vue : Contenu du Sélecteur
    private var pickerSheetContent: some View {
        NavigationStack {
            VStack {
                if mode == .date {
                    DatePicker(label, selection: $temp, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                } else {
                    DatePicker(label, selection: $temp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                }
            }
            .labelsHidden()
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { showSheet = false }
                        .accessibilityLabel("Annuler la saisie")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        date = temp
                        showSheet = false
                    }
                    .accessibilityLabel("Confirmer la sélection") 
                }
            }
        }
        .presentationDetents([.medium, .large])
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        DateTimePickerField(
            label: "Date de l'événement",
            placeholder: "Sélectionner une date",
            date: .constant(Date()),
            mode: .date
        )
        
        DateTimePickerField(
            label: "Heure de l'événement",
            placeholder: "Sélectionner une heure",
            date: .constant(Date()),
            mode: .time
        )
    }
    .padding()
    .background(Color.appBackground)
    .preferredColorScheme(.dark)
}
