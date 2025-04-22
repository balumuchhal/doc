//
//  CoreHelper.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import Foundation
import CoreData

class CoreHelper:CoreHelperProtocol {
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }
    
    func saveData(doc: Document,isAPIUpdate:Bool = false) {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "docId == %@", doc.docId)
        do {
            let results = try context.fetch(fetchRequest)
            let document: Documents
            if let existingDocument = results.first {
                document = existingDocument
                if isAPIUpdate {
                    guard document.isDataUpdated else { return }
                }
            }
            else {
                document = Documents(context: context)
                document.docId = doc.docId
            }
            document.docName = doc.docName
            document.createdDate = doc.createdDate
            document.isFavourite = doc.isFavourite
            document.isDataUpdated = doc.isDataUpdated
            if context.hasChanges {
                try context.save()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func loadDocument(docId: String) -> Document? {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "docId == %@", docId)
        do {
            let results = try context.fetch(fetchRequest)
            if let document = results.first {
                let doc = Document(docName: document.docName ?? "", createdDate: document.createdDate ?? "", isFavourite: document.isFavourite, docId: document.docId ?? "", isDataUpdated: document.isDataUpdated)
                return doc
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    func loadAllDocument() async -> Task<[Document], Never> {
        Task {
            let context = self.viewContext
            let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                var docs:[Document] = []
                for document in results {
                    let doc = Document(docName: document.docName ?? "", createdDate: document.createdDate ?? "", isFavourite: document.isFavourite, docId: document.docId ?? "", isDataUpdated: document.isDataUpdated)
                    docs.append(doc)
                }
                return docs
            }
            catch {
                return []
            }
        }
    }
    
    func loadPendingUpdateDocument() -> [Document] {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDataUpdated == NO")
        do {
            let results = try context.fetch(fetchRequest)
            var docs:[Document] = []
            for document in results {
                let doc = Document(docName: document.docName ?? "", createdDate: document.createdDate ?? "", isFavourite: document.isFavourite, docId: document.docId ?? "", isDataUpdated: document.isDataUpdated)
                docs.append(doc)
            }
            return docs
        }
        catch {
            return []
        }
    }
    
    func deleteDocument(docId: String) {
        let context = self.viewContext
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "docId == %@", docId)
        do {
            let results = try context.fetch(fetchRequest)
            if let cdDocument = results.first {
                context.delete(cdDocument)
                if context.hasChanges {
                    try context.save()
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
