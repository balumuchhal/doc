//
//  APIService.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import Combine
import Foundation

class APIService : APIServiceProtocol {
    
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = "https://67ff5bb258f18d7209f0debe.mockapi.io/documents",
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchDocList() -> AnyPublisher<[Document], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Document].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func editDocument(favorite: Bool? = nil, name: String? = nil, id: String) async throws -> Bool {
        var request = try prepareRequest(httpMethod: "PUT",id: id)
        let payload = EditDocumentRequest(isFavourite: favorite, docName: name)
        request.httpBody = try JSONEncoder().encode(payload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await requestURL(request:request)
    }
    
    func saveDocument(favorite: Bool, name: String) async throws -> Bool {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let payload = EditDocumentRequest(isFavourite: favorite, docName: name)
        request.httpBody = try JSONEncoder().encode(payload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return try await requestURL(request:request)
    }
    
    func deleteDocument(id: String) async throws -> Bool {
        let request = try prepareRequest(httpMethod: "DELETE",id: id)
        return try await requestURL(request:request)
    }
    
    func prepareRequest(httpMethod: String, id: String) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
    
    func requestURL(request: URLRequest) async throws -> Bool {
        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 ||  httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        print(httpResponse.statusCode)
        return true
    }
}

struct EditDocumentRequest: Encodable {
    let isFavourite: Bool?
    let docName: String?
}
