//
//  NetworkManager.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import UIKit

final class NetworkManager<T: Decodable> {
    
    func sendRequest(requestType: APIManager) async throws -> T {
        let request = URLRequest(url: APIManager.createURL(request: requestType).url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let succesData = try? JSONDecoder().decode(T.self, from: data) else { throw URLError(.cannotDecodeContentData)
        }
        
        return succesData
    }
}

class NetworkManagerForImage {
    private static let imageLoader = ImageLoaderService(cacheCountLimit: 500)

    @MainActor
    func setImage(requestType: APIManager) async throws -> UIImage {
        let url = OpenLibraryAPIManager.createURL(request: requestType).url!
        var image = try await Self.imageLoader.loadImage(for: url)

        if !Task.isCancelled {
            if image.imageIsEmpty() {
                image = UIImage(systemName: "book.closed")!
            }
        }
        return image
    }
}

