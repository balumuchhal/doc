//
//  CoreHelperProtocol.swift
//  Doc
//
//  Created by Seja Muchhal on 22/04/25.
//


import CoreData
import Combine

protocol CoreHelperProtocol {
    
    func saveData(doc: Document, isAPIUpdate: Bool)
    func loadDocument(docId: String) -> Document?
    func loadAllDocument() async -> Task<[Document], Never>
    func loadPendingUpdateDocument() -> [Document]
    func deleteDocument(docId: String)
}
