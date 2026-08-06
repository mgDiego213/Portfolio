//
//  HomeView.swift
//  SkillUp
//
//  Created by Alumno on 31/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 6)
                    .padding(.top)

                Text("MENU")
                    .font(.largeTitle.bold())
                    .padding(.top,40)
                    .foregroundStyle(.white)

                // Cuadrícula con tarjetas
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 20
                ) {
                    GameCard(
                        title: "Higiene",
                        color: Theme.accent,
                        imageName: "higiene1",
                        destination: HygieneGameView()
                    )

                    GameCard(
                        title: "Comida",
                        color: Theme.primary,
                        imageName: "comida1",
                        destination: FoodGameView()
                    )

                    GameCard(
                        title: "Seguridad",
                        color: Theme.danger,
                        imageName: "seguridad1",
                        destination: SafetyGameView()
                    )

                    GameCard(
                        title: "Planeta",
                        color: Theme.danger,
                        imageName: "planeta1",
                        destination: PlanetGameView()
                    )
                }
                .padding(.horizontal, 20)

                // 🔹 Botón Dibujar con sonido
                NavigationLink(destination: DrawingView()) {
                    Label("🎨 Dibujar", systemImage: "pencil.and.outline")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AudioManager.shared.playSound("tap")    // 🔊 SONIDO DEL BOTÓN
                })

                Spacer()
            }
            .background(
                Image("FondoMenu")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}

//  -----------------------------------------------------------
// MARK: - GameCard con sonido al presionar
// -----------------------------------------------------------

struct GameCard<Dest: View>: View {
    let title: String
    let color: Color
    let icon: String?
    let imageName: String?
    let destination: Dest

    init(title: String, color: Color, icon: String, destination: Dest) {
        self.title = title
        self.color = color
        self.icon = icon
        self.imageName = nil
        self.destination = destination
    }

    init(title: String, color: Color, imageName: String, destination: Dest) {
        self.title = title
        self.color = color
        self.icon = nil
        self.imageName = imageName
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 10) {

                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(radius: 4)
                }
                else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(color)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 130)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
        }
        .simultaneousGesture(TapGesture().onEnded {
            AudioManager.shared.playSound("tap")
        })
    }
}

// -----------------------------------------------------------
// MARK: - PREVIEW
// -----------------------------------------------------------

#Preview {
    HomeView()
}
