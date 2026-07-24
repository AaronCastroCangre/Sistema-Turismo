import Foundation

// MARK: - Modelo de respuesta del clima

struct ClimaData {
    let ciudad: String
    let temperatura: Double
    let descripcion: String
    let icono: String
    let humedad: Int
    let sensacionTermica: Double
}

/// Servicio para consumir la API de OpenWeatherMap.
/// Uso:
///   1. Obtén tu API Key gratis en https://openweathermap.org/api
///   2. Reemplaza el valor de `apiKey` con tu clave
///   3. Llama a `obtenerClima(ciudad:)` desde cualquier ViewModel o View

class WeatherService {

    static let shared = WeatherService()

    private let apiKey = "d88a0dd315cfdc203e4ec94742c56929"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    private init() {}

    func obtenerClima(ciudad: String) async throws -> ClimaData {

        let ciudadEncoded = ciudad.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ciudad
        let urlString = "\(baseURL)?q=\(ciudadEncoded)&appid=\(apiKey)&units=metric&lang=es"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)

        return ClimaData(
            ciudad: json.name,
            temperatura: json.main.temp,
            descripcion: json.weather.first?.description ?? "",
            icono: json.weather.first?.icon ?? "",
            humedad: json.main.humidity,
            sensacionTermica: json.main.feels_like
        )
    }
}


private struct OpenWeatherResponse: Codable {
    let name: String
    let main: MainData
    let weather: [WeatherInfo]
}

private struct MainData: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

private struct WeatherInfo: Codable {
    let description: String
    let icon: String
}
