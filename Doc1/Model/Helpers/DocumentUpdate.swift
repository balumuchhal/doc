//
//  DocumentUpdate.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import Combine
import Foundation

class DocumentUpdate:DocumentUpdateProtocol {
    
    private let apiService: APIServiceProtocol
    private var cancellable: AnyCancellable?
    private let coreHelper:CoreHelperProtocol
    
    init(apiService: APIServiceProtocol = APIService(),coreHelper:CoreHelperProtocol=CoreHelper()) {
        self.coreHelper = coreHelper
        self.apiService = apiService
    }
    
    func updateData(docName: String? = nil, isFavourite: Bool? = nil, doc: Document) async {
        guard docName != nil || isFavourite != nil else { return }
        do {
            let success = try await apiService.editDocument(favorite: isFavourite,name: docName,id: doc.docId)
            doc.isDataUpdated = success
            coreHelper.saveData(doc: doc, isAPIUpdate: false)
            if success {
                await MainActor.run {
                    if let name = docName {
                        doc.docName = name
                    }
                    if let fav  = isFavourite {
                        doc.isFavourite = fav
                    }
                }
            }
        }
        catch {
            doc.isDataUpdated = false
            coreHelper.saveData(doc: doc, isAPIUpdate: false)
            print("Error updating document: \(error)")
        }
    }
    
    func saveData(docName: String, isFavourite: Bool) async -> Bool {
        let doc = Document()
        doc.docName = docName
        doc.isFavourite = isFavourite
        do {
            let success = try await apiService.saveDocument(favorite: isFavourite,name: docName)
            doc.isDataUpdated = success
            coreHelper.saveData(doc: doc, isAPIUpdate: false)
            return true
        }
        catch {
            doc.isDataUpdated = false
            coreHelper.saveData(doc: doc,isAPIUpdate: false)
            print("Error updating document: \(error)")
            return true
        }
    }
    
    func updatePendingData() {
        Task {
            let pending = coreHelper.loadPendingUpdateDocument()
            for pendingDoc in pending {
                if pendingDoc.docId.isEmpty {
                    _ = await saveData(docName: pendingDoc.docName, isFavourite: pendingDoc.isFavourite)
                }
                else {
                    await updateData(docName: pendingDoc.docName, isFavourite: pendingDoc.isFavourite, doc: pendingDoc)
                }
            }
        }
    }
    
    func deleteDocument(docId: String) async {
        do {
            let success = try await apiService.deleteDocument(id: docId)
            if success {
                coreHelper.deleteDocument(docId: docId)
            }
        }
        catch {
            print("Error deleting document: \(error)")
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
