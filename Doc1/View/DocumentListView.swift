//
//  DocumentListView.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//
import SwiftUI

struct DocumentListView: View {
    
    @StateObject var viewModel:DocumentListViewModel
    @State private var showDeleteAlert = false
    
    let onEditDocument: (Document) -> Void
    let onFavoriteToggle: (Document) -> Void
    
    var body: some View {
        List {
            if let errorMessage = viewModel.contentViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            else {
                ForEach(viewModel.documents.indices, id: \.self) { index in
                    DocCardView(doc: viewModel.documents[index], onFavoriteToggle: onFavoriteToggle)
                        .swipeActions(edge: .leading) {
                            editAction(index)
                        }
                        .swipeActions(edge: .trailing) {
                            deleteAction(index)
                        }
                }
            }
        }
        .alert("Record deleted successfully", isPresented: $showDeleteAlert) {
            Button("Okay", role: .cancel) {
                
            }
        }
        .listStyle(.plain)
        .padding(0)
    }
    
    
    private func deleteAction(_ index: Int) -> some View {
        Button {
            Task {
                await viewModel.deleteDocument(index)
                showDeleteAlert = true
            }
        } label: {
            VStack {
                Text("Delete")
            }
        }
        .tint(Color.red)
    }
    
    private func editAction(_ index: Int) -> some View {
        Button {
            onEditDocument(viewModel.documents[index])
        } label: {
            VStack {
                Image(systemName: "note.text")
                Text("Edit")
            }
        }
        .tint(Color.orange)
    }
}
