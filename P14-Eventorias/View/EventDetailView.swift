//
//  EventDetailView.swift
//  P14-Eventorias
//
//  Created by Jaouad on 09/06/2026.
//

import SwiftUI

/// Vue  des détails complets d'un événement sélectionné.
struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric private var avatarSize: CGFloat = 56
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Photo de couverture
                Color.clear
                    .frame(maxWidth: .infinity)
                    .frame(height: 340)
                    .overlay {
                        AsyncImage(url: event.imageURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.appCard)
                                .overlay { ProgressView().tint(.white) }
                        }
                    }
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Photo de l'événement \(event.title)")
                
                //Infos Temporelles & Organisateur
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label { Text(event.date, format: .enUSDate) }    // "July 20, 2024"
                        icon: { Image(systemName: "calendar") }
                        
                        Label { Text(event.date, format: .enUSTime) }    // "10:00 AM"
                        icon: { Image(systemName: "clock") }
                    }
                    .foregroundStyle(.white)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(accessibilityCombinedDateString)
                    
                    Spacer(minLength: 8)
                    
                    // Avatar de l'organisateur
                    AsyncImage(url: event.organizerPhotoURL) { $0.resizable().scaledToFill() }
                    placeholder: {
                        Circle().fill(Color.appCard)
                            .overlay { Image(systemName: "person.fill").foregroundStyle(Color.appTextSecondary) }
                    }
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
                    .accessibilityLabel(event.organizerName.map { "Organisé par \($0)" } ?? "Organisateur anonyme")
                }
                
                //Description
                Text(event.description)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                //Adresse & Carte Locale
                HStack(alignment: .top, spacing: 12) {
                    Text(event.address)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let lat = event.latitude, let lon = event.longitude,
                       let mapURL = StaticMapURL.url(latitude: lat, longitude: lon, width: 300, height: 200) {
                        AsyncImage(url: mapURL) { $0.resizable().scaledToFill() }
                        placeholder: { Rectangle().fill(Color.appCard) }
                            .frame(width: 130, height: 84)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .accessibilityHidden(true)
                    }
                }
                .accessibilityElement(children: .combine)
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Bouton Retour
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left").fontWeight(.semibold)
                    }
                    .accessibilityLabel("Retour")
                }
            }
            // Titre de l'événement centré / aligné à gauche
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(event.title)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .accessibilityAddTraits(.isHeader)
                    
                    Spacer()
                }
                // Ajusttement de la marge pour approcher le texte de chevron
                .padding(.leading, -120)
            }
            // Bouton partage
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareMessage,
                          subject: Text(event.title),
                          message: Text("Découvre cet événement sur Eventorias.")) {
                    Image(systemName: "square.and.arrow.up")
                }
                          .accessibilityLabel("Partager l'événement")
            }
        }
    }
    
    // MARK: - Outils Privés
    
    /// Génère un texte fluide et dicté spécifiquement conçu pour l'accessibilité de la date et de l'heure.
    private var accessibilityCombinedDateString: String {
        let dateStyle = event.date.formatted(.dateTime.day().month(.wide).year())
        let timeStyle = event.date.formatted(.dateTime.hour().minute())
        return "Prévu le \(dateStyle) à \(timeStyle)"
    }
    
    /// Prépare le texte brut envoyé lors de l'activation du ShareLink.
    private var shareMessage: String {
        let dateText = event.date.formatted(.dateTime.day().month(.wide).year().hour().minute())
        return "\(event.title)\n \(dateText)\n \(event.address)\n\n\(event.description)"
    }
}

#Preview {
    NavigationStack { EventDetailView(event: .preview) }
        .preferredColorScheme(.dark)
}
