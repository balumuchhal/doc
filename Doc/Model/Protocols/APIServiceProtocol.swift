//
//  APIServiceProtocol.swift
//  Doc
//
//  Created by Seja Muchhal on 22/04/25.
//


import Combine

protocol APIServiceProtocol {
    func fetchDocList() -> AnyPublisher<[Document], Error>
    func editDocument(favorite: Bool?, name: String?, id: String) async throws -> Bool
    func saveDocument(favorite: Bool, name: String) async throws -> Bool
    func deleteDocument(id: String) async throws -> Bool
}
