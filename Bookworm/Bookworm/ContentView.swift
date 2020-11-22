//
//  ContentView.swift
//  Bookworm
//
//  Created by Robert Shrestha on 8/30/20.
//  Copyright © 2020 robert. All rights reserved.
//

import SwiftUI
import CoreData
// MARK: Section 1: Creating a custom component with @Binding
struct PushButton: View {
    let title: String
    /// Replacing @State with @Binding for two way binding
    @Binding var isOn: Bool

    var onColor = [Color.red,Color.yellow]
    var offColor = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColor : offColor), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }

}
struct BindingView: View {
    @State var rememberMe = false
    var body: some View{
        VStack(spacing: 20) {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

// MARK: Section 2: Using size classes with AnyView type erasure
struct TypeErasureView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        if sizeClass == .compact {
            return AnyView(VStack {
                Text("Active size class:")
                Text("COMPACT")
                }
            )
        } else {
            return AnyView ( HStack {
                Text("Active size class:")
                Text("Regular")
                }
            )
        }
    }
}
// MARK: Section 3: How to combine Core Data and SwiftUI
struct CoreDataView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>
    var body: some View {
        VStack {
            List {
                ForEach(students, id: \.id) { student in
                    Text("\(student.name ?? "Unknown")")

                }
            }
            Button("Add") {
                let firstNames = ["Ram","Sita","Hari","Shyam"]
                let lastNames = ["Shrestha","Maharjan","Subedhi","Tamang"]
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!

                let student = Student(context: self.moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                try? self.moc.save()
            }
        }
    }
}
// MARK:  Section 4: Creating books with Core Data
struct BookView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book().entity, sortDescriptors: [

        // MARK: Section 8: Sorting fetch requests with NSSortDescriptor
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)

    ]) var books: FetchedResults<Book>
    @State private var showindAddScreen = false
    var body: some View {
        NavigationView {
//            Text("Total Count: \(books.count)")
            // MARK: Section 6: Building a list with @FetchRequest
            List {
                ForEach(books,id: \.self) { book in
//                    NavigationLink( destination: Text(book.title ?? "Unknown title")){
                        // MARK: Section 7: Showing book details
                    NavigationLink( destination: DetailView(book: book)){
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unkown title")
                                .font(.headline)
                            // MARK: Challange 1: Modify ContentView so that books rated as 1 star have their name shown in red.
                                .foregroundColor((book.rating == 1) ? .red : .primary)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)

                        }
                    }
                }
                    // MARK: Section 9: Deleting from a Core Data fetch request
            .onDelete(perform: deleteBooks)
            }
                .navigationBarTitle("Bookworm")
                // MARK: Section 9: Deleting from a Core Data fetch request
                // Edit button added
            .navigationBarItems(leading: EditButton(),trailing:
                Button(action: {
                    self.showindAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
                .sheet(isPresented: $showindAddScreen) {
                    AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
// MARK: Section 9: Deleting from a Core Data fetch request
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}
struct ContentView: View {

    var body: some View {
        // Text("Hello, World!")
        // MARK: Section 1
        //BindingView()

        // MARK: Section 2
        //TypeErasureView()

        // MARK: Section 3
       // CoreDataView()

        // MARK: Section 4
        BookView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
