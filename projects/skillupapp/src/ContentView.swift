//
//  ContentView.swift
//  SkillUp
//
//  Created by Alumno on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            ProfileView()
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
        .tint(Theme.primary)
    }
}