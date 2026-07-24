//
//  MapaView.swift
//  PA3
//
//  Created by Alumno on 16/06/26.
//
import SwiftUI
import MapKit

struct MapaView: View {

    let lugar: String

    @State private var position: MapCameraPosition = .automatic

    func coordenadasDestino() -> CLLocationCoordinate2D {

        switch lugar {

        case "Miraflores":
            return CLLocationCoordinate2D(
                latitude: -12.1211,
                longitude: -77.0297
            )

        case "Barranco":
            return CLLocationCoordinate2D(
                latitude: -12.1464,
                longitude: -77.0205
            )

        case "Centro de Lima":
            return CLLocationCoordinate2D(
                latitude: -12.0464,
                longitude: -77.0428
            )

        case "Larcomar":
            return CLLocationCoordinate2D(
                latitude: -12.1303,
                longitude: -77.0302
            )

        case "Parque Kennedy":
            return CLLocationCoordinate2D(
                latitude: -12.1219,
                longitude: -77.0297
            )

        default:
            return CLLocationCoordinate2D(
                latitude: -12.0464,
                longitude: -77.0428
            )
        }
    }

    var destino: CLLocationCoordinate2D {
        coordenadasDestino()
    }

    var body: some View {

        ZStack {

            Map(position: $position) {

                Marker(
                    lugar,
                    coordinate: destino
                )
            }
            .ignoresSafeArea()

            VStack {

                HStack {

                    Image(systemName: "magnifyingglass")

                    Text(lugar)

                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding()

                Spacer()

                VStack(alignment: .leading, spacing: 8) {

                    Text(lugar)
                        .font(.title2)
                        .bold()

                    Text("Destino turístico de Lima")
                        .foregroundColor(.secondary)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 25
                    )
                )
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {

            position = .region(
                MKCoordinateRegion(
                    center: destino,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        }
    }
}
