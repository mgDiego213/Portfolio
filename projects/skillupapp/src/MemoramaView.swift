//
//  MemoramaView.swift
//  SkillUp
//
//  Created by Alumno on 28/11/25.
//

import SwiftUI

// MARK: - MODELO DE CARTA
struct Card: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    var isFlipped = false
    var isMatched = false
}

// MARK: - VISTA DEL MEMORAMA + CONFETI
struct MemoramaView: View {

    // Cartas de ejemplo
    @State private var cards: [Card] = [
        Card(emoji: "🐶"), Card(emoji: "🐶"),
        Card(emoji: "🐱"), Card(emoji: "🐱"),
        Card(emoji: "🐼"), Card(emoji: "🐼"),
        Card(emoji: "🦊"), Card(emoji: "🦊")
    ].shuffled()

    @State private var flippedCards: [Int] = []
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            VStack {
                Text("Memorama 🎯")
                    .font(.largeTitle.bold())
                    .padding()

                // GRID DE CARTAS
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                    ForEach(cards.indices, id: \.self) { index in
                        cardView(for: index)
                    }
                }
                .padding()

                Button("Reiniciar") {
                    restartGame()
                }
                .padding(.top)
            }

            // CONFETI AL COMPLETAR
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
        .onChange(of: cards) { _ in
            checkWin()
        }
    }

    // MARK: - VISTA DE UNA CARTA
    func cardView(for index: Int) -> some View {
        let card = cards[index]

        return ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 70)
                    .shadow(radius: 3)

                Text(card.emoji)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .frame(height: 70)
            }
        }
        .onTapGesture {
            flipCard(index)
        }
        .animation(.easeInOut(duration: 0.25), value: cards)
    }

    // MARK: - LÓGICA DEL JUEGO

    func flipCard(_ index: Int) {
        guard !cards[index].isFlipped,
              !cards[index].isMatched,
              flippedCards.count < 2
        else { return }

        cards[index].isFlipped = true
        flippedCards.append(index)

        if flippedCards.count == 2 {
            checkMatch()
        }
    }

    func checkMatch() {
        let first = flippedCards[0]
        let second = flippedCards[1]

        if cards[first].emoji == cards[second].emoji {
            cards[first].isMatched = true
            cards[second].isMatched = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cards[first].isFlipped = false
                cards[second].isFlipped = false
            }
        }

        flippedCards.removeAll()
    }

    func checkWin() {
        if cards.allSatisfy({ $0.isMatched }) {
            showConfettiEffect()
        }
    }

    func restartGame() {
        cards.indices.forEach { i in
            cards[i].isFlipped = false
            cards[i].isMatched = false
        }
        cards.shuffle()
        showConfetti = false
    }

    func showConfettiEffect() {
        withAnimation { showConfetti = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { showConfetti = false }
        }
    }
}

// MARK: - CONFETI VIEW COMPLETO 🎉
struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 2)

        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPink, .systemPurple]

        var cells: [CAEmitterCell] = []

        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 8
            cell.lifetime = 8
            cell.velocity = 200
            cell.velocityRange = 80
            cell.emissionLongitude = .pi
            cell.spinRange = 3
            cell.scale = 0.6

            let size = CGSize(width: 12, height: 12)
            UIGraphicsBeginImageContext(size)
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(origin: .zero, size: size))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            cell.contents = img?.cgImage
            cells.append(cell)
        }

        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            emitter.birthRate = 0
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - PREVIEW
struct MemoramaView_Previews: PreviewProvider {
    static var previews: some View {
        MemoramaView()
    }
}