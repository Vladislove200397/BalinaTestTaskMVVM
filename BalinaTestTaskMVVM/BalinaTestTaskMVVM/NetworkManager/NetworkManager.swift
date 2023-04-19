//
//  NetworkManager.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import UIKit

actor GETDataManager {

    func getData(requestType: APIManager) async throws -> DataModel  {

        let urlRequest = URLRequest(url: APIManager.createURL(request: requestType).url!)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let succesData = try? JSONDecoder().decode(DataModel.self, from: data) else { throw URLError(.cannotDecodeContentData)
        }

        return succesData
    }
}

actor POSTDataManager {
    func uploadData(_ data: Data, to requestType: APIManager) async throws -> URLResponse {
        var request = URLRequest(url: APIManager.createURL(request: requestType).url!)
        
        request.httpMethod = requestType.requestType.requestType

        let (_, response) = try await URLSession.shared.upload(
            for: request,
            from: data
        )
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return response
    }
}

actor ImageLoaderService {

    private var cache = NSCache<NSURL, UIImage>()

    init(cacheCountLimit: Int) {
        cache.countLimit = cacheCountLimit
    }

    func loadImage(for url: URL) async throws -> UIImage {
        if let image = lookupCache(for: url) {
            return image
        }

        let image = try await doLoadImage(for: url)

        updateCache(image: image, and: url)

        return lookupCache(for: url) ?? image
    }

    private func doLoadImage(for url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        return image
    }

    private func lookupCache(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    private func updateCache(image: UIImage, and url: URL) {
        if cache.object(forKey: url as NSURL) == nil {
            cache.setObject(image, forKey: url as NSURL)
        }
    }
}
