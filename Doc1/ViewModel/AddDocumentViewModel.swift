//
//  AddDocumentViewModel.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//


import Foundation
import Combine

class AddDocumentViewModel: ObservableObject {
    @Published var document: Document
    @Published var name:String = ""
    @Published var isFavourite:Bool = false
    let documentUpdate:DocumentUpdateProtocol
    
    var isUserSubmitted = false
    var isUsernameValid: Bool {
        name.count > 0
    }

    init(document: Document,documentUpdate:DocumentUpdateProtocol=DocumentUpdate()) {
        self.document = document
        name = document.docName
        isFavourite = document.isFavourite
        self.documentUpdate = documentUpdate
    }
    
    func save() async -> Bool {
        if !name.isEmpty {
            if document.docId.isEmpty {
               return await documentUpdate.saveData(docName: name,isFavourite: isFavourite)
            }
            else {
                await documentUpdate.updateData(docName: name,isFavourite: isFavourite,doc: document)
                return true
            }
        }
        else {
            return true
        }
    }
}
