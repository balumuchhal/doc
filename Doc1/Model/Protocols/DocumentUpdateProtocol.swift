//
//  DocumentUpdateProtocol.swift
//  Doc
//
//  Created by Seja Muchhal on 22/04/25.
//
import Combine

protocol DocumentUpdateProtocol {
    func updateData(docName: String?, isFavourite: Bool?, doc: Document) async
    func saveData(docName: String, isFavourite: Bool) async -> Bool
    func updatePendingData()
    func deleteDocument(docId: String) async
}
