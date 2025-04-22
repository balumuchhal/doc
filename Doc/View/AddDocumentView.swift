//
//  AddDocumentView.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import SwiftUI

struct AddDocumentView: View {
    @StateObject var viewModel: AddDocumentViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showRecordSavedAlert = false
    let parentViewModel:ContentViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            TextField("Enter Document Name", text: $viewModel.name)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary.opacity(0.4), lineWidth: 1)
                )
            Toggle("Favourite", isOn: $viewModel.isFavourite)
                .padding()
            Button(action: {
                viewModel.isUserSubmitted = true
                if !viewModel.name.isEmpty {
                    Task {
                        if await viewModel.save() {
                            showRecordSavedAlert = true
                        }
                    }
                }
            }, label: { Text("Save") })
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .alert("Record Saved", isPresented: $showRecordSavedAlert) {
            Button("Okay") {
                parentViewModel.fetchData()
                dismiss()
            }
        }
        .navigationTitle(viewModel.document.docId.isEmpty ? "Add Document" : "Edit Document")
        .padding(16)
    }
}
