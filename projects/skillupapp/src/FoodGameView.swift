import SwiftUI
import AVFoundation

struct FoodGameView: View {
    @EnvironmentObject var store: ProfilesStore
    
    @State private var cards: [MemoryCard] = []
    @State private var selectedIndices: [Int] = []
    @State private var matched: Set<Int> = []
    @State private var score = 0
    
    let foods = [
        "🍎", "🥦", "🥕", "🍌",
        "🍇", "🍓", "🥑", "🍅"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Puntaje: \(score)")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            GridView(cards: cards, selected: selectedIndices, matched: matched) { index in
                selectCard(index)
            }
            
            Button("Reiniciar") {
                resetGame()
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
            .padding(.top)
            
            Spacer()
            
        }
        
        .padding()
        .onAppear { resetGame() }
        .navigationTitle("Memorama")
    }
    
    // MARK: - Reiniciar juego
    func resetGame() {
        score = 0
        matched.removeAll()
        selectedIndices.removeAll()
        
        var tempCards: [MemoryCard] = []
        let chosen = foods.shuffled().prefix(6) // 6 parejas
        
        for food in chosen {
            let id = UUID().uuidString
            tempCards.append(MemoryCard(id: id + "A", content: food))
            tempCards.append(MemoryCard(id: id + "B", content: food))
        }
        
        cards = tempCards.shuffled()
    }
    
    // MARK: - Selección de carta
    func selectCard(_ index: Int) {
        guard !matched.contains(index) else { return }
        guard !selectedIndices.contains(index) else { return }
        
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            let first = selectedIndices[0]
            let second = selectedIndices[1]
            
            if cards[first].content == cards[second].content {
                // ¡Match!
                matched.insert(first)
                matched.insert(second)
                
                score += 20
                store.addPoints(20)
                
                AudioManager.shared.playSound("correct") // 🔊 Sonido correcto
                
                selectedIndices.removeAll()
            } else {
                AudioManager.shared.playSound("wrong") // 🔊 Sonido incorrecto
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    selectedIndices.removeAll()
                }
            }
        }
    }
}

struct MemoryCard: Identifiable {
    let id: String
    let content: String
}

struct GridView: View {
    let cards: [MemoryCard]
    let selected: [Int]
    let matched: Set<Int>
    let action: (Int) -> Void
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(cards.indices, id: \.self) { index in
                CardView(
                    text: cards[index].content,
                    isFlipped: selected.contains(index) || matched.contains(index)
                )
                .onTapGesture {
                    action(index)
                }
            }
        }
        .animation(.easeInOut, value: selected)
    }
}

struct CardView: View {
    let text: String
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            if isFlipped {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.accent)
                Text(text)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                Image(systemName: "questionmark")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 90)
        .animation(.easeInOut, value: isFlipped)
    }
}

#Preview {
    FoodGameView()
}