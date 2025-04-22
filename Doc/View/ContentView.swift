//
//  ContentView.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var selectedDocumentForEdit: Document?
    @State private var showEditView: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView {
                DocumentListView(viewModel: DocumentListViewModel(documentsPublisher: viewModel.$allDocuments, contentViewModel: viewModel), onEditDocument: { document in
                    selectedDocumentForEdit = document
                    showEditView = true
                }, onFavoriteToggle: { document in
                    viewModel.fetchData()
                })
                .tabItem {
                    Label("Home", systemImage: "doc.text")
                }
                DocumentListView(viewModel: DocumentListViewModel(documentsPublisher: viewModel.$favDocuments, contentViewModel: viewModel), onEditDocument: { document in
                    selectedDocumentForEdit = document
                    showEditView = true
                }, onFavoriteToggle: { document in
                    viewModel.fetchData()
                })
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AddDocumentView(viewModel: AddDocumentViewModel(document: Document()),parentViewModel: viewModel)
                    } label: {
                        VStack {
                            Label("Add Doc", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showEditView) {
                if let document = selectedDocumentForEdit {
                    AddDocumentView(viewModel: AddDocumentViewModel(document: document), parentViewModel: viewModel)
                        .onDisappear { selectedDocumentForEdit = nil }
                }
            }
            .navigationTitle("Documents")
            .navigationBarTitleDisplayMode(.large)
        }
        .padding(0)
        .task {
            viewModel.fetchData()
        }
    }
}
