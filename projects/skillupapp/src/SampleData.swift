//
//  SampleData.swift
//  SkillUp
//
//  Created by Alumno on 07/10/25.
//
import Foundation

struct Question: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let options: [String]
    let correct: String
}

enum SampleData {
    static let hygiene = [
        Question(text: "¿Cuánto tiempo debes lavarte las manos?",
                 options: ["5 segundos", "10 segundos", "20 segundos", "1 minuto"],
                 correct: "20 segundos"),
        Question(text: "¿Cuántas veces al día se recomienda cepillarse los dientes?",
                 options: ["1", "2", "3", "5"],
                 correct: "2"),
        Question(text: "¿Qué debes usar al estornudar si no tienes pañuelo?",
                 options: ["Mano", "Codo", "Pared", "Nada"],
                 correct: "Codo")
    ]

    static let food = [
        ("Manzana", "Refresco"),
        ("Agua", "Refresco"),
        ("Zanahoria", "Papas fritas"),
        ("Pescado", "Hamburguesa"),
        ("Ensalada", "Pastel")
    ]

    static let safety = [
        Question(text: "Si ves un cable pelado, ¿qué haces?",
                 options: ["Lo toco", "Aviso a un adulto", "Le echo agua", "Lo piso"],
                 correct: "Aviso a un adulto"),
        Question(text: "Si se cae algo de vidrio, ¿qué haces?",
                 options: ["Lo recojo con las manos", "Pido ayuda a un adulto", "Juego con los pedazos", "Lo pateo"],
                 correct: "Pido ayuda a un adulto"),
        Question(text: "¿Qué no debes hacer con enchufes?",
                 options: ["Usarlos secos", "Jugar con ellos", "Conectar una lámpara", "Desconectar con cuidado"],
                 correct: "Jugar con ellos")
    ]

    static let recycleMap: [String: String] = [
        "Botella": "Plástico",
        "Lata": "Metal",
        "Cáscara": "Orgánico",
        "Cartón": "Papel/Cartón",
        "Papel": "Papel/Cartón"
    ]
}