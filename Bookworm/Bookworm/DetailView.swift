//
//  DetailView.swift
//  Bookworm
//
//  Created by Robert Shrestha on 9/7/20.
//  Copyright © 2020 robert. All rights reserved.
//

// MARK: Section 7: Showing book details
import CoreData
import SwiftUI

struct DetailView: View {
    // MARK: Section 10: Using an alert to pop a NavigationLink programmatically
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth:geo.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)

                }
                Text(self.book.author ?? "Unkown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")


                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                Text(self.formattedDate(date: self.book.date ?? Date()))
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle(Text(self.book.title ?? "Unknown Author"), displayMode: .inline)
        // MARK: Section 10: Using an alert to pop a NavigationLink programmatically
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    // MARK: Challenge 3: Add a new “date” attribute to the Book entity, assigning Date() to it so it gets the current date and time, then format that nicely somewhere in DetailView.
    func formattedDate(date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    // MARK: Section 10: Using an alert to pop a NavigationLink programmatically
    func deleteBook() {
        moc.delete(book)

        //try? self.moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a good book; I really enjoyed it."
        return NavigationView{
            DetailView(book: book)
        }
    }
}
