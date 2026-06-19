//
//  DateFormatStyle.swift
//  P14-Eventorias
//
//  Created by Jaouad on 12/06/2026.
//  Format de date

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    /// Exemple strict : "July 20, 2024"
    static var enUSDate: CustomDateStringFormatStyle {
        CustomDateStringFormatStyle(dateFormat: "MMMM d, yyyy")
    }

    /// Exemple strict : "10:00 AM"
    static var enUSTime: CustomDateStringFormatStyle {
        CustomDateStringFormatStyle(dateFormat: "h:mm a")
    }
}

// MARK: - FormatStyle Personnalisé 
struct CustomDateStringFormatStyle: FormatStyle {
    typealias FormatInput = Date
    typealias FormatOutput = String

    let dateFormat: String

    func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US")
        // Force la capitalisation AM/PM en majuscules au cas où
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: value)
    }
}
