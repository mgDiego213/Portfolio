//
//  HygieneGameView.swift
//  SkillUp
//
//  Created by Alumno on 09/10/25.
//
import SwiftUI

struct HygieneGameView: View {
    @EnvironmentObject var store: ProfilesStore

    @State private var questions = SampleData.hygiene.shuffled()
    @State private var index = 0
    @State private var selected: String? = nil
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        VStack(spacing: 20) {
            Text("🪥 Higiene Divertida")
                .font(.largeTitle.bold())

            if finished {
                Text("Tu puntaje: \(score)")
                    .font(.title2)
                Button("Jugar otra vez") { restart() }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accent)
            } else {
                Text(questions[index].text)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                ForEach(questions[index].options, id: \.self) { opt in
                    Button {
                        select(opt)
                    } label: {
                        Text(opt)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(color(for: opt))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(selected != nil)
                    .padding(.horizontal)
                }

                Text("Puntaje: \(score)")
                    .font(.headline)
            }

            Spacer()
        }
        
        .padding()
        .navigationTitle("Higiene")
    }

    func select(_ opt: String) {
        selected = opt
        if opt == questions[index].correct {
            score += 10
            store.addPoints(10) // ✅ suma al perfil activo
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { next() }
    }

    func color(for opt: String) -> Color {
        guard let s = selected else { return Theme.primary }
        if opt == s { return opt == questions[index].correct ? Theme.accent : Theme.danger }
        return .gray
    }

    func next() {
        selected = nil
        if index + 1 < questions.count {
            index += 1
        } else {
            finished = true
        }
    }

    func restart() {
        questions.shuffle()
        index = 0
        score = 0
        finished = false
        selected = nil
    }
}
#Preview {
    HygieneGameView()
}