//
//  CameraPicker.swift
//  P14-Eventorias
//
//  Created by Jaouad on 10/06/2026.
//

import SwiftUI
import UIKit

/// SwiftUI n'a pas de caméra native, -> UIImagePickerController

struct CameraPicker: UIViewControllerRepresentable {
    // MARK: - Propriétés
    @Environment(\.dismiss) private var dismiss
    let onImagePicked: (UIImage) -> Void // Callback renvoyant l'image capturée à la vue parente
    
    // MARK: - Méthodes du Protocole UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        //  Simulateur : L'utilisation de `.camera` provoque un crash immédiat sur simulateur.
        // On vérifie la disponibilité matérielle. Si indisponible (simulateur), on bascule sur la bibliothèque.
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        // Assigne le coordinateur comme délégué pour intercepter les retours utilisateurs (annulation / capture)
        picker.delegate = context.coordinator
        return picker
    }
    /// Requis par le protocole pour mettre à jour l'état de la vue si le contexte SwiftUI change
    func updateUIViewController(_ controller : UIImagePickerController, context: Context) {}
    
    /// Instancie le Coordinateur chargé de gérer les protocoles de délégation de UIKit.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator (Délégué UIKit)
    
    /// Classe intermédiaire gérant les retours d'événements asynchrones d'UIKit vers le paradigme déclaratif de SwiftUI.
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) { self.parent = parent
        }
        
        /// Déclenché lorsque l'utilisateur a pris une photo ou sélectionné un média avec succès.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage { parent.onImagePicked(image)
            }
            parent.dismiss()
        }
        
        /// Déclenché lorsque l'utilisateur clique sur le bouton "Annuler" l'interface caméra.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraPicker { image in
        print("Photos reçue avec succès!  taille : \(image.size)")
    }
}
