//  SkillUpApp.swift
import SwiftUI

@main
struct SkillUpApp: App {
    @StateObject private var profilesStore = ProfilesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profilesStore) // 👈 inyección global
        }
    }
}