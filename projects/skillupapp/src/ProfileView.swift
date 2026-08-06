//
//  ProfileView.swift
//  SkillUp
//
//  Created by Alumno on 09/10/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: ProfilesStore

    @State private var showAvatarPicker = false
    @State private var showNewProfileSheet = false
    @State private var tempName: String = ""
    @State private var tempEmoji: String = "🦊"
    @State private var editingName: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // Perfil actual
                    
                    if let current = store.currentProfile {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Theme.primary.opacity(0.12))
                                .frame(width: 130, height: 130)

                            Text(current.emoji)
                                .font(.system(size: 64))
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                tempEmoji = current.emoji
                                showAvatarPicker = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 28))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, Theme.primary)
                                    .shadow(radius: 3)
                            }
                            .offset(x: 6, y: 6)
                        }

                        VStack(spacing: 6) {
                            // Editar nombre in place
                            HStack {
                                TextField("Tu nombre", text: Binding(
                                    get: { editingName.isEmpty ? current.name : editingName },
                                    set: { editingName = $0 }
                                ))
                                .multilineTextAlignment(.center)
                                .font(.title3.weight(.semibold))
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 260)

                                Button {
                                    let newName = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if !newName.isEmpty { store.renameCurrent(to: newName) }
                                    editingName = ""
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(Theme.accent)
                                }
                                .accessibilityLabel("Guardar nombre")
                            }

                            Text("Puntos: \(current.points)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }

                        Divider().padding(.vertical, 4)
                    }

                    // Lista de perfiles (para cambiar)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Perfiles").font(.largeTitle.bold())
                        
                        .foregroundStyle(.white)


                        ForEach(store.profiles) { p in
                            Button {
                                store.selectProfile(p.id)
                                editingName = ""
                            } label: {
                                HStack {
                                    Text(p.emoji)
                                    VStack(alignment: .leading) {
                                        Text(p.name).font(.subheadline).bold()
                                        Text("Puntos: \(p.points)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if p.id == store.currentId {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundStyle(Theme.accent)
                                    }
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        tempName = ""
                        tempEmoji = "🦊"
                        showNewProfileSheet = true
                    } label: {
                        Label("Nuevo perfil", systemImage: "person.badge.plus")
                    }
                }
            }
            // Picker de emojis para el perfil actual
            .sheet(isPresented: $showAvatarPicker) {
                EmojiPickerView(avatarEmoji: Binding(
                    get: { store.currentProfile?.emoji ?? "🦊" },
                    set: { store.setEmojiForCurrent($0) }
                ))
            }
            // Crear perfil nuevo
            .sheet(isPresented: $showNewProfileSheet) {
                NewProfileSheet(tempName: $tempName, tempEmoji: $tempEmoji) {
                    store.addProfile(name: tempName, emoji: tempEmoji)
                }
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

// MARK: - Selector de emojis (reutilizado)
struct EmojiPickerView: View {
    @Binding var avatarEmoji: String
    @Environment(\.dismiss) private var dismiss

    private let emojiOptions = [
        "🦊","🐶","🐱","🐼","🐯","🦁",
        "🐸","🐵","🐨","🦄","🐤","🐙",
        "🚀","🎮","⚽️","🏀","🎸","🎨",
        "🌈","🌟","🍎","🍕","🧩","🎯"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Elige tu avatar").font(.title2.bold())

                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Theme.primary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    Text(avatarEmoji).font(.system(size: 56))
                }
                .padding(.bottom, 8)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
                        ForEach(emojiOptions, id: \.self) { e in
                            Button {
                                avatarEmoji = e
                                dismiss()
                            } label: {
                                Text(e)
                                    .font(.system(size: 32))
                                    .frame(width: 48, height: 48)
                                    .background(avatarEmoji == e ? Theme.accent.opacity(0.25) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Hoja para crear un nuevo perfil
struct NewProfileSheet: View {
    @Binding var tempName: String
    @Binding var tempEmoji: String
    var onCreate: () -> Void
    @Environment(\.dismiss) private var dismiss

    private let emojiOptions = [
        "🦊","🐶","🐱","🐼","🐯","🦁",
        "🐸","🐵","🐨","🦄","🐤","🐙",
        "🚀","🎮","⚽️","🏀","🎸","🎨",
        "🌈","🌟","🍎","🍕","🧩","🎯"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Crear nuevo perfil").font(.title2.bold())

                TextField("Nombre del perfil", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Emoji preview
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Theme.primary.opacity(0.1))
                        .frame(width: 100, height: 100)
                    Text(tempEmoji).font(.system(size: 48))
                }

                // Emoji grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
                        ForEach(emojiOptions, id: \.self) { e in
                            Button { tempEmoji = e } label: {
                                Text(e)
                                    .font(.system(size: 32))
                                    .frame(width: 48, height: 48)
                                    .background(tempEmoji == e ? Theme.accent.opacity(0.25) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.vertical)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        onCreate()
                        dismiss()
                    }
                    .disabled(tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}