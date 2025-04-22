//
//  Document.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import Combine
import Foundation

final class Document : Codable, Identifiable, ObservableObject {
    
    let id = UUID()
    @Published var docName : String
    let createdDate : String
    @Published var isFavourite : Bool
    var docId : String
    var isDataUpdated : Bool
    
    enum CodingKeys: String, CodingKey {
        case docName
        case createdDate
        case isFavourite
        case docId
    }
    
    init() {
        self.createdDate = Date(timeIntervalSince1970: 0).description
        self.docName = ""
        self.isFavourite = false
        self.docId = ""
        self.isDataUpdated = true
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        docName = try values.decodeIfPresent(String.self, forKey: .docName) ?? ""
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate) ?? ""
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
        docId = try values.decodeIfPresent(String.self, forKey: .docId) ?? ""
        isDataUpdated = true
    }
    
    init(docName: String, createdDate: String, isFavourite: Bool, docId: String,isDataUpdated:Bool) {
        self.docName = docName
        self.createdDate = createdDate
        self.isFavourite = isFavourite
        self.docId = docId
        self.isDataUpdated = isDataUpdated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(docName, forKey: .docName)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isFavourite, forKey: .isFavourite)
        try container.encode(docId, forKey: .docId)
    }
}
