//
//  ProfileStore.swift
//  SkillUp
//
//  Created by Alumno on 13/10/25.
//  Administra perfiles (nombre, emoji, puntos) con persistencia en UserDefaults.

import Foundation
import SwiftUI
import Combine

struct KidProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var emoji: String
    var points: Int

    init(id: UUID = UUID(), name: String, emoji: String = "🦊", points: Int = 0) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.points = points
    }
}

final class ProfilesStore: ObservableObject {

    // Claves de persistencia
    private let kProfilesKey = "profiles_store_profiles"
    private let kCurrentIdKey = "profiles_store_current_id"

    @Published var profiles: [KidProfile] = []
    @Published var currentId: UUID? = nil

    var currentProfile: KidProfile? {
        get { profiles.first(where: { $0.id == currentId }) }
    }

    init() {
        load()
        // Si no hay perfiles, crea uno por defecto
        if profiles.isEmpty {
            let p = KidProfile(name: "Jugador 1", emoji: "🦊", points: 0)
            profiles = [p]
            currentId = p.id
            save()
        } else if currentId == nil {
            currentId = profiles.first?.id
            save()
        }
    }

    // MARK: - Mutadores

    func selectProfile(_ id: UUID) {
        currentId = id
        save()
    }

    func addProfile(name: String, emoji: String) {
        let p = KidProfile(name: name.isEmpty ? "Nuevo" : name, emoji: emoji, points: 0)
        profiles.append(p)
        currentId = p.id
        save()
    }

    func renameCurrent(to newName: String) {
        guard let id = currentId, let idx = profiles.firstIndex(where: { $0.id == id }) else { return }
        profiles[idx].name = newName
        save()
    }

    func setEmojiForCurrent(_ emoji: String) {
        guard let id = currentId, let idx = profiles.firstIndex(where: { $0.id == id }) else { return }
        profiles[idx].emoji = emoji
        save()
    }

    func addPoints(_ amount: Int) {
        guard amount != 0,
              let id = currentId,
              let idx = profiles.firstIndex(where: { $0.id == id }) else { return }
        profiles[idx].points += amount
        save()
    }

    // Opcional: reset al actual (no lo uso al crear nuevo; el nuevo empieza en 0 por diseño)
    func resetCurrentPoints() {
        guard let id = currentId, let idx = profiles.firstIndex(where: { $0.id == id }) else { return }
        profiles[idx].points = 0
        save()
    }

    // MARK: - Persistencia

    private func save() {
        do {
            let data = try JSONEncoder().encode(profiles)
            UserDefaults.standard.set(data, forKey: kProfilesKey)
            UserDefaults.standard.set(currentId?.uuidString, forKey: kCurrentIdKey)
        } catch {
            print("❌ Error guardando perfiles: \(error)")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: kProfilesKey) {
            do {
                profiles = try JSONDecoder().decode([KidProfile].self, from: data)
            } catch {
                print("❌ Error cargando perfiles: \(error)")
                profiles = []
            }
        }
        if let idStr = UserDefaults.standard.string(forKey: kCurrentIdKey),
           let uuid = UUID(uuidString: idStr) {
            currentId = uuid
        }
    }
}