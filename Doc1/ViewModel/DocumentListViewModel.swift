//
//  DocumentListViewModel.swift
//  Doc
//
//  Created by Seja Muchhal on 22/04/25.
//



import Combine
import Foundation

class DocumentListViewModel: ObservableObject {
    
    @Published var documents: [Document] = []
    var contentViewModel:ContentViewModel
    private let documentUpdate:DocumentUpdateProtocol
    
    init(documentsPublisher: Published<[Document]>.Publisher, contentViewModel: ContentViewModel, documentUpdate:DocumentUpdateProtocol=DocumentUpdate()) {
        self.contentViewModel = contentViewModel
        self.documentUpdate = documentUpdate
        documentsPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$documents)
    }
    
    func deleteDocument(_ index: Int) async -> Void {
        await documentUpdate.deleteDocument(docId: documents[index].docId)
        contentViewModel.fetchData()
    }
}
