import Foundation

// MARK: - Lugar

struct Lugar: Identifiable {

    let id = UUID()
    let nombre: String
    let descripcion: String
    let imagen: String
    let categoria: String
    let info: String
    let mejoresLugares: [String]
}


struct Destino: Identifiable, Codable {

    var id = UUID()

    var departamento: String
    var region: String
    var lugar: String
    var experiencia: String
    var fecha: Date
}
struct ClimaLugar {

    let nombreLugar: String
    let ciudadAPI: String
}

struct Comentario: Identifiable {
    let id: String
    let nombre: String
    let comentario: String
    let estrellas: Double
    let lugar: String
    let userId: String
}
