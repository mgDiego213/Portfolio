//
//  DrawingView.swift
//  SkillUp
//
//  Created by Alumno on 31/10/25.
//

import SwiftUI

struct DrawingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var lines: [Line] = []
    @State private var currentLine = Line(points: [])

    var body: some View {
        VStack {
            Text("🎨 Dibuja tu comida saludable")
                .font(.title2.bold())
                .padding(.top)

            // Lienzo interactivo
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(.green), lineWidth: 5)
                }

                var currentPath = Path()
                currentPath.addLines(currentLine.points)
                context.stroke(currentPath, with: .color(.blue), lineWidth: 5)
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    currentLine.points.append(value.location)
                }
                .onEnded { _ in
                    lines.append(currentLine)
                    currentLine = Line(points: [])
                }
            )
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 5)
            .padding()

            // Botones inferiores
            HStack {
                Button("🗑️ Limpiar") {
                    lines.removeAll()
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Spacer()

                Button("⬅️ Volver") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Dibuja")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Line {
    var points: [CGPoint]
}