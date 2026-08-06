//
//  PlanetGameView.swift
//  SkillUp
//
//  Created by Alumno on 09/10/25.
//

import SwiftUI
import CoreHaptics

// Relación entre emoji y tipo de bote
private let recycleMap: [String: String] = [
    "🍎": "Orgánico",      // manzana
    "🥕": "Orgánico",      // zanahoria
    "📄": "Papel/Cartón", // hoja
    "📦": "Papel/Cartón", // caja
    "🥤": "Plástico",     // vaso
    "🧴": "Plástico",     // botella de shampoo
    "🥫": "Metal",        // lata
    "🔩": "Metal"         // tornillo
]

struct PlanetGameView: View {
    @EnvironmentObject var store: ProfilesStore

    @State private var items = Array(recycleMap.keys).shuffled()
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        VStack(spacing: 20) {
            Text("🌍 Cuida el Planeta")
                .font(.largeTitle.bold())

            if finished {
                Text("Puntaje: \(score)")
                    .font(.title2)

                Button("Reiniciar") { restart() }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accent)

            } else {
                Text("Arrastra cada objeto al bote correcto 🗑️")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                HStack(alignment: .top, spacing: 16) {

                    // Objetos para arrastrar
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(items, id: \.self) { it in
                            DraggableChip(text: it)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Botes reales con imágenes
                    VStack(spacing: 12) {
                        DropBin(title: "Orgánico",     onReceive: handleDrop)
                        DropBin(title: "Plástico",     onReceive: handleDrop)
                        DropBin(title: "Metal",        onReceive: handleDrop)
                        DropBin(title: "Papel/Cartón", onReceive: handleDrop)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)

                Text("Puntaje: \(score)")
                    .font(.headline)
            }

            Spacer()
        }
        
        .padding()
        .navigationTitle("Planeta")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Lógica cuando cae un objeto dentro de un bote
    private func handleDrop(_ droppedItem: String, into binTitle: String) {
        let correct = recycleMap[droppedItem] == binTitle

        if correct {
            score += 10
            store.addPoints(10)
            safeHapticTap()
        }

        items.removeAll { $0 == droppedItem }

        if items.isEmpty {
            finished = true
        }
    }

    private func restart() {
        items = Array(recycleMap.keys).shuffled()
        score = 0
        finished = false
    }

    private func safeHapticTap() {
        // Evita errores en simulador
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

// MARK: - CHIP ARRASTRABLE (emoji)
struct DraggableChip: View {
    let text: String

    var body: some View {
        let chip = Text(text)
            .font(.system(size: 48))
            .frame(width: 80, height: 80)
            .background(Theme.primary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16))

        chip
            .draggable(text, preview: { chip })
    }
}

// MARK: - BOTE DE RECICLAJE (CON IMÁGENES bote1–bote4)
struct DropBin: View {
    let title: String
    let onReceive: (String, String) -> Void

    // Cambia automáticamente la imagen según el tipo
    private var binImage: String {
        switch title {
        case "Orgánico":     return "boteVerde"
        case "Plástico":     return "boteAzul"
        case "Metal":        return "boteAmarillo"
        case "Papel/Cartón": return "boteRojo"
        default:             return "bote1"
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            Image(binImage)
                .resizable()
                .scaledToFit()
                .frame(height: 80)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding()
        .background(Theme.accent.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .dropDestination(for: String.self) { items, _ in
            if let first = items.first {
                onReceive(first, title)
                return true
            }
            return false
        }
    }
}

#Preview {
    PlanetGameView()
}