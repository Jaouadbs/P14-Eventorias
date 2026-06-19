//
//  EventRowView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 08/06/2026.
//

import SwiftUI

/// Composant graphique représentant une cellule de résumé pour un événement.
struct EventRowView: View {
    let event: Event
    
    // Dynamic type: avatar   grandie avec la taille de texte
    @ScaledMetric private var avatarSize: CGFloat = 40
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar Organisateur
            AsyncImage(url: event.organizerPhotoURL) { $0.resizable().scaledToFit()}
            placeholder: {
                Circle().fill(Color.appBackground)
                    .overlay {Image(systemName: "person.fill")
                        .foregroundStyle(Color.appTextSecondary)}
            }
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(Circle())
            .padding(.leading,12)
            
            // Informations Textuelles
            VStack(alignment: .leading, spacing:4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(Color.appRowText)
                    .lineLimit(2)
                
                Text(event.date, format: .enUSDate)
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer(minLength: 8)
            
            // Vignette de l'Événement
            AsyncImage(url: event.imageURL) { $0.resizable().scaledToFill()}
            placeholder: {
                Rectangle().fill(Color.appBackground.opacity(0.4))
            }
            .frame(width: 136, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(height: 80)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        // VoiceOver : une seule annonce au lieu de 3 elements décousus.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
    }
    
    // MARK: - Texte d'Accessibilité
    private var accessibilityText: String {
        let dateText = event.date.formatted(.dateTime.day().month(.wide).year())
        if let organizer = event.organizerName {
            return "\(event.title), prévu le \(dateText), organisé par \(organizer)"
        }
        return"\(event.title), prévu le \(dateText)"
    }
}

#Preview {
    EventRowView(event: .preview)
        .padding()
        .background(Color.appBackground)
}
