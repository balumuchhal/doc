//
//  DocCard.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//
import SwiftUI

struct DocCardView: View {
    
    @ObservedObject var doc: Document
    @State private var showRecordSavedAlert = false
    var docUpdate:DocumentUpdate?
    let onFavoriteToggle: (Document) -> Void
    
    init(doc: Document, onFavoriteToggle: @escaping (Document) -> Void) {
        self.doc = doc
        self.docUpdate = DocumentUpdate()
        self.onFavoriteToggle = onFavoriteToggle 
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: Color.primary.opacity(0.4), radius: 4)
            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    Task {
                        await docUpdate?.updateData(isFavourite: !doc.isFavourite, doc: doc)
                        showRecordSavedAlert = true
                        
                    }
                    
                }, label: { Image(doc.isFavourite ? "star-filled": "star") })
                .frame(width: 25,height: 25)
                .padding(.leading, 4)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(doc.docName)")
                    Text("Created: \(doc.createdDate)")
                }
                .padding(.leading, 4)
                Spacer()
            }
            .padding(8)
        }
        .alert(doc.isFavourite ? "Added into favourites": "Removed from favourites", isPresented: $showRecordSavedAlert) {
            Button("Okay") {
                onFavoriteToggle(doc)
            }
        }
        .padding(4)
        .listRowSeparator(.hidden)
    }
}
