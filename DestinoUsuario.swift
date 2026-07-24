//
//  DestinoUsuario.swift
//  PA3
//
//  Created by Alumno on 21/07/26.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct DestinoUsuario: Identifiable, Codable {
    let id: String
    let titulo: String
    let descripcion: String
    let autor: String
    let correo: String
    let imagenNombres: [String]
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case descripcion
        case autor
        case correo
        case imagenNombres
        case timestamp
    }
}

class DestinoImageManager {
    static let shared = DestinoImageManager()

    private init() {}


    private var destinosDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinosFolder = documents.appendingPathComponent("DestinosImagenes", isDirectory: true)

        // Crear directorio si no existe
        if !FileManager.default.fileExists(atPath: destinosFolder.path) {
            try? FileManager.default.createDirectory(at: destinosFolder, withIntermediateDirectories: true)
        }

        return destinosFolder
    }

    func guardarImagen(_ image: UIImage, destinoID: String, index: Int) -> String {
        let nombreArchivo = "\(destinoID)_\(index)_\(UUID().uuidString.prefix(8)).jpg"
        let url = destinosDirectory.appendingPathComponent(nombreArchivo)

        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url)
        }

        return nombreArchivo
    }

    func cargarImagen(nombreArchivo: String) -> UIImage? {
        let url = destinosDirectory.appendingPathComponent(nombreArchivo)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    func eliminarImagenes(nombres: [String]) {
        for nombre in nombres {
            let url = destinosDirectory.appendingPathComponent(nombre)
            try? FileManager.default.removeItem(at: url)
        }
    }

    func urlImagen(nombreArchivo: String) -> URL {
        return destinosDirectory.appendingPathComponent(nombreArchivo)
    }
}


class DestinoFirestoreManager {
    static let shared = DestinoFirestoreManager()
    private let db = Firestore.firestore()

    private init() {}

    func guardarDestino(titulo: String, descripcion: String, autor: String, correo: String, imagenNombres: [String], completion: @escaping (Result<String, Error>) -> Void) {

        let docRef = db.collection("destinosUsuarios").document()
        let destinoData: [String: Any] = [
            "titulo": titulo,
            "descripcion": descripcion,
            "autor": autor,
            "correo": correo,
            "imagenNombres": imagenNombres,
            "timestamp": Timestamp(date: Date())
        ]

        docRef.setData(destinoData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
    }

    func obtenerDestinos(completion: @escaping (Result<[DestinoUsuario], Error>) -> Void) {
        db.collection("destinosUsuarios")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let destinos = documents.compactMap { doc -> DestinoUsuario? in
                    let data = doc.data()
                    return DestinoUsuario(
                        id: doc.documentID,
                        titulo: data["titulo"] as? String ?? "",
                        descripcion: data["descripcion"] as? String ?? "",
                        autor: data["autor"] as? String ?? "",
                        correo: data["correo"] as? String ?? "",
                        imagenNombres: data["imagenNombres"] as? [String] ?? [],
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }

                completion(.success(destinos))
            }
    }

    func eliminarDestino(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("destinosUsuarios").document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
