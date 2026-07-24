//
//  ClimaView.swift
//  PA3
//
//  Created by Alumno on 11/06/26.
//
import SwiftUI

struct ClimaView: View {

    let ciudad: String
    let lugar: String

    @State private var clima: ClimaData?

    var body: some View {

        ScrollView {

            VStack(spacing: 25) {

                Text("Clima en \(lugar)")
                    .font(.largeTitle)
                    .bold()

                if let clima = clima {

                    VStack(spacing: 15) {

                        Image(systemName: iconoSistema(clima.icono))
                            .font(.system(size: 100))
                            .foregroundStyle(.orange)

                        Text("\(Int(clima.temperatura))°C")
                            .font(.system(size: 55))
                            .bold()

                        Text(clima.descripcion.capitalized)
                            .font(.title3)

                        Divider()

                        Label(
                            "Humedad: \(clima.humedad)%",
                            systemImage: "drop.fill"
                        )

                        Label(
                            "Sensación térmica: \(Int(clima.sensacionTermica))°C",
                            systemImage: "thermometer"
                        )

                        Label(
                            Date.now.formatted(
                                date: .omitted,
                                time: .shortened
                            ),
                            systemImage: "clock.fill"
                        )

                        Text(recomendacionTuristica(clima))
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                    .padding()

                } else {

                    ProgressView("Consultando clima...")
                }
            }
        }
        .navigationTitle("Clima")
        .task {

            do {

                clima = try await WeatherService.shared.obtenerClima(
                    ciudad: ciudad
                )

            } catch {

                print(error)
            }
        }
    }

    func recomendacionTuristica(_ clima: ClimaData) -> String {

        if clima.temperatura > 28 {
            return "Excelente día para visitar Miraflores."
        }

        if clima.temperatura > 22 {
            return "Ideal para caminar y despejar la mente"
        }

        if clima.temperatura > 18 {
            return "Buen clima para recorrer el Centro Histórico."
        }

        return "Lleva una casaca ligera."
    }

    func iconoSistema(_ icono: String) -> String {

        switch icono {

        case "01d":
            return "sun.max.fill"

        case "01n":
            return "moon.fill"

        case "02d":
            return "cloud.sun.fill"

        case "02n":
            return "cloud.moon.fill"

        case "03d", "03n":
            return "cloud.fill"

        case "04d", "04n":
            return "smoke.fill"

        case "09d", "09n":
            return "cloud.rain.fill"

        case "10d":
            return "cloud.sun.rain.fill"

        case "10n":
            return "cloud.moon.rain.fill"

        case "11d", "11n":
            return "cloud.bolt.fill"

        case "13d", "13n":
            return "snowflake"

        case "50d", "50n":
            return "cloud.fog.fill"

        default:
            return "sun.max.fill"
        }
    }
}
