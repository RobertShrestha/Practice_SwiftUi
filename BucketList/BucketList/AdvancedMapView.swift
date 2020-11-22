//
//  AdvancedMapView.swift
//  BucketList
//
//  Created by Robert Shrestha on 9/26/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import MapKit

// MARK: Section 7: Advanced MKMapView with SwiftUI
struct AdvancedMapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetail: Bool
    var annotations: [MKPointAnnotation]

    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("Updating")
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: AdvancedMapView

        init(_ parent: AdvancedMapView) {
            self.parent = parent
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        // MARK: Section 8: Customizing MKMapView annotations
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemarker"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }
            parent.selectedPlace = placemark
            parent.showingPlaceDetail = true
        }

    }
}
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct AdvancedMapView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedMapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate),selectedPlace: .constant(MKPointAnnotation.example), showingPlaceDetail: .constant(false), annotations: [MKPointAnnotation.example])
    }
}
