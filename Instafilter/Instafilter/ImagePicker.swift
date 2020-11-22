//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Robert Shrestha on 9/9/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
// MARK: Section 5: Wrapping a UIViewController in a SwiftUI view
struct ImagePicker: UIViewControllerRepresentable {

    // MARK: Section 6: Using coordinators to manage SwiftUI view controllers
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: Section 5: Wrapping a UIViewController in a SwiftUI view
    typealias UIViewControllerType = UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()

        // MARK: Section 6: Using coordinators to manage SwiftUI view controllers
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

}
