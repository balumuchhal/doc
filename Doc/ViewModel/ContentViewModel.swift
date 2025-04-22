//
//  ContentViewModel.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import Combine

class ContentViewModel: ObservableObject {
    
    @Published var allDocuments: [Document] = []
    @Published var favDocuments: [Document] = []
    @Published var errorMessage: String?
    

    private let apiService: APIServiceProtocol
    private let coreHelper:CoreHelperProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiService: APIServiceProtocol = APIService(),coreHelper:CoreHelperProtocol=CoreHelper()) {
        self.apiService = apiService
        self.coreHelper = coreHelper
        Task {
            let allDocs = await coreHelper.loadAllDocument().value
            if allDocuments.isEmpty {
                await MainActor.run(body: {
                    allDocuments = allDocs
                    favDocuments = allDocs.filter { $0.isFavourite }
                })
            }
        }
    }

    func fetchData() {
        apiService.fetchDocList()
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    self.errorMessage = "Failed to fetch documents."
                case .finished:
                    print("Data fetched successfully")
                }
            } receiveValue: { [weak self]  fetchedDocuments in
                guard let self else { return }
                self.errorMessage = nil
                self.allDocuments = fetchedDocuments
                self.favDocuments = fetchedDocuments.filter { $0.isFavourite }
                self.saveCoreData()
            }
            .store(in: &cancellables)
    }
    
    func saveCoreData() {
        Task {
            for document in allDocuments {
                coreHelper.saveData(doc: document,isAPIUpdate: true)
            }
        }
    }
    
}
