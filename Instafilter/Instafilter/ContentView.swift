//
//  ContentView.swift
//  Instafilter
//
//  Created by Robert Shrestha on 9/8/20.
//  Copyright © 2020 robert. All rights reserved.
//
import CoreImage
import CoreImage.CIFilterBuiltins

import SwiftUI

// MARK: Section 1: How property wrappers become structs
struct SectionOneView: View {
    @State private var blurAmount: CGFloat = 0 {
        didSet {
            // State wraps its value using a non-mutating setter, which means neither blurAmount or the State struct wrapping it are changing – our binding is directly changing the internally stored value, which means the property observer is never being triggered.
            print("New value is \(blurAmount)")
        }
    }
    var body: some View {
        VStack {
            Text("Hello World")
            .blur(radius: blurAmount)
            Slider(value: $blurAmount, in: 0...20)
            .padding()
        }
    }
}
// MARK: Section 2: Creating custom bindings in SwiftUI
struct SectionTwoView: View {
    @State private var blurAmount: CGFloat = 0

    var body: some View {
        let blur = Binding<CGFloat> (
            get: {
                self.blurAmount
        },
            set: {
                self.blurAmount = $0
                print("New value is \(self.blurAmount)")
            }
        )
        return VStack {
            Text("Hello World")
                .blur(radius: blurAmount)
            Slider(value: blur, in: 0...20)
                .padding()
        }
    }
}

// MARK: Section 3: Showing multiple options with ActionSheet
struct ActionSheetView: View {
    @State private var showingActionSheet = false
    @State private var backgroundColor = Color.white
    var body: some View {
        Text("Hello World")
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture(perform: {
                self.showingActionSheet.toggle()
            })
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Change background"), message: Text("Select a new Color"), buttons: [
                .default(Text("Red")) {self.backgroundColor = .red },
                .default(Text("Green")){self.backgroundColor = .green},
                .default(Text("Blue")){self.backgroundColor = .blue},
                .cancel()
            ])
        }
    }
}
// MARK: Section 4: Integrating Core Image with SwiftUI
struct CoreImageView: View {
    @State private var image: Image?
    var body: some View {
        VStack {
            image?
                .resizable()
            .scaledToFit()
        }.onAppear(perform: loadImage)
    }
    func loadImage() {
//        image = Image("Example")
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        /*
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = beginImage
            currentFilter.intensity = 1
        */

        /*
        let currentFilter = CIFilter.pixellate()
        currentFilter.inputImage = beginImage
        currentFilter.scale = 100
        */
        /*
        let currentFilter = CIFilter.crystallize()
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.radius = 200
        */

        guard let currentFilter = CIFilter(name: "CITwirlDistortion") else { return }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(2000, forKey: kCIInputRadiusKey)
        currentFilter.setValue(CIVector(x: inputImage.size.width / 2, y: inputImage.size.height / 2), forKey: kCIInputCenterKey)

        guard let outputImage = currentFilter.outputImage else { return }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)

        }
    }
}

// MARK: Section 7: How to save images to the user’s photo library
class ImageSaver: NSObject {
    var successHandler: (()-> Void)?
    var errorHandler:((Error)-> Void)?
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError) , nil)
    }
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
// MARK: Section 5: Wrapping a UIViewController in a SwiftUI view
struct UIVCWrapperView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false

    // MARK: Section 6: Using coordinators to manage SwiftUI view controllers
    @State private var inputImage: UIImage?

    var body: some View {
        VStack {
            image?
            .resizable()
            .scaledToFit()

            Button("Select Image") {
                self.showingImagePicker = true
            }
        }
            // MARK: Section 6: Using coordinators to manage SwiftUI view controllers
            // ondismiss parameter added
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image:self.$inputImage)
        }

    }
    // MARK: Section 6: Using coordinators to manage SwiftUI view controllers
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        // MARK: Section 7: How to save images to the user’s photo library
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
}
    // MARK: Section 8: Building our basic UI
struct InstaFilterView: View{
    @State private var image: Image?
    @State private var filterIntensity = 0.5

    @State private var filterRadius = 0.5

     // MARK: Section 9: Importing an image into SwiftUI using UIImagePickerController
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    // MARK: Section 10: Basic image filtering using Core Image
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    // MARK: Section 11: Customizing our filter using ActionSheet
    @State private var showingFilterSheet = false

    // MARK: Challenge 1: Try making the Save button show an error if there was no image in the image view.

    @State private var title = ""
    @State private var message = ""
    @State private var showErrorMessage = false

    // MARK: Challenge 2: Make the Change Filter button change its title to show the name of the currently selected filter.
    @State private var filterName = "Select Filter"
// MARK: Section 12: Saving the filtered image with UIImageWriteToSavedPhotosAlbum()
    @State private var processedImage: UIImage?
    var body: some View {

        // MARK: Section 10: Basic image filtering using Core Image
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )

        let radius = Binding<Double> (
            get: {
                self.filterRadius
        },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
        }
        )


        let inputKeys = currentFilter.inputKeys
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        image?
                        .resizable()
                        .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                    }
                }.onTapGesture {
                    // MARK: Section 9: Importing an image into SwiftUI using UIImagePickerController
                    self.showingImagePicker = true
                }
                HStack {
//                    Text("Intensity")
//                    Slider(value: intensity)
                    // MARK: Challenge 3: Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
                    if inputKeys.contains(kCIInputIntensityKey) {
                        Text("Intensity")
                        Slider(value: intensity)
                    }
                    if inputKeys.contains(kCIInputRadiusKey) {
                        Text("Radius")
                        Slider(value: radius)
                    }
                    if inputKeys.contains(kCIInputScaleKey) {
                        Text("Scale")
                        Slider(value: intensity)
                    }
                }.padding([.vertical])
                HStack {
                    Button(filterName) {
                         // MARK: Section 11: Customizing our filter using ActionSheet
                        self.showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            self.title = "Error"
                            self.message = "There is no image to save"
                            self.showErrorMessage = true
                            return
                        }
                        let imageSaver = ImageSaver()
                        imageSaver.errorHandler = {
                            print("Opps: \($0.localizedDescription)")
                        }
                        imageSaver.successHandler = {
                            print("Sucess")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }

            }

            .padding([.horizontal,.bottom])
            .navigationBarTitle("Instafilter")

            // MARK: Section 9: Importing an image into SwiftUI using UIImagePickerController
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image:self.$inputImage)
            }
            // MARK: Section 11: Customizing our filter using ActionSheet
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) {
                        self.filterName = "Crystallize"
                        self.setFilter(.crystallize())
                    },
                    .default(Text("Edges")) {  self.filterName = "Edges";self.setFilter(.edges())},
                    .default(Text("Gaussian Blur")) { self.filterName = "Gaussian Blur";self.setFilter(.gaussianBlur())},
                    .default(Text("Pixellate")) { self.filterName = "Pixellater";self.setFilter(.pixellate())},
                    .default(Text("Sepia Tone")) { self.filterName = "Sepia Tone";self.setFilter(.sepiaTone())},
                    .default(Text("Unsharp Mask")) { self.filterName = "Unsharp Mask";self.setFilter(.unsharpMask())},
                    .default(Text("Vignette")) { self.filterName = "Vignette";self.setFilter(.vignette())},
                    .cancel()
                ])
            }
            .alert(isPresented: $showErrorMessage) {
                Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("Ok")))
            }

        }

    }
    // MARK: Section 9: Importing an image into SwiftUI using UIImagePickerController
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //image = Image(uiImage: inputImage)


        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    // MARK: Section 10: Basic image filtering using Core Image

    func applyProcessing() {
        //currentFilter.intensity = Float(filterIntensity)

         // MARK: Section 11: Customizing our filter using ActionSheet
        //self.currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10 , forKey: kCIInputScaleKey)
        }

        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    // MARK: Section 11: Customizing our filter using ActionSheet
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView: View {
    @State private var blurAmount: CGFloat = 0
    var body: some View {
        // MARK: Section 1: How property wrappers become structs
        //SectionOneView()

        // MARK: Section 2: Creating custom bindings in SwiftUI
        //SectionTwoView()

        // MARK: Section 3: Showing multiple options with ActionSheet
       // ActionSheetView()

        // MARK: Section 4: Integrating Core Image with SwiftUI
        //CoreImageView()

        // MARK: Section 5: Wrapping a UIViewController in a SwiftUI view
        //UIVCWrapperView()

         // MARK: Section 8: Building our basic UI
        InstaFilterView()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
