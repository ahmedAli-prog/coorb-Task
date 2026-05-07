//
//  NetworkClient.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

class NetworkClient {
    
    //MARK: - Properties
    var baseUrl : String
    
    //MARK: - Initallizer
    init(baseUrl: String){
        
        self.baseUrl = baseUrl
    }

    //MARK: - Methods
    private func fetchData<T: Decodable>(from url: URL?) async throws -> T {
        
        guard let url else { throw NetworkError.generalError }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            
            if let _ = error as? URLError {
                throw NetworkError.generalError
            } else if let decodingError = error as? DecodingError  {
                throw NetworkError.decodingError(decodingError)
            }
            throw error
        }
    }
    
    private func createURL(with path: String) -> URL? {
        
        return URLComponents(string: "\(baseUrl)\(path)")?.url
    }
    
    func performRequest<T: Decodable>(path: String) async throws -> T {
        
        let url = createURL(with: path)
        return try await fetchData(from: url)
    }
}
