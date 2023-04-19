//
//  MainViewControllerViewModel.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

class MainViewControllerViewModel {
    var dataModel: Dynamic<DataModel?> = Dynamic(nil)
    private var loadTask: Task<Void, Never>?
    private var searchingTask: Task<Void, Never>?
    private lazy var searchService = GETDataManager()
    var dataArray: [Content] = []
    var isLoading = false
    var page = 0
    
    
    @MainActor
    func getPaginationRequest(page: Int) {
        searchingTask?.cancel()
        searchingTask = Task {
            do {
                let paginationData = try await searchService.getData(requestType: .getDataPagination(page: "\(page)"))
                paginationData.content.forEach { contents in
                    dataArray.append(contents)
                dataModel.value = paginationData
                }
            } catch {
                
            }
        }
    }
}
//    func uploadImage(name: String, id: Int, image: UIImage) {
//            let filename = "\(id).jpg"
//            let boundary = UUID().uuidString
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            var urlRequest = URLRequest(url: URL(string: "https://junior.balinasoft.com/api/v2/photo")!)
//            urlRequest.httpMethod = "POST"
//
//            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            var data = Data()
//
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
//            data.append("\(name)".data(using: .utf8)!)
//
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
//            data.append("\(id)".data(using: .utf8)!)
//
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//            data.append(image.jpegData(compressionQuality: 0.5)!)
//            
//            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//            session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//                
//                if(error != nil){
//                    print("\(error!.localizedDescription)")
//                }
//                
//                guard let responseData = responseData else {
//                    print("no response data")
//                    return
//                }
//                
//                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
//                print(statusCode)
//                
//                if let responseString = String(data: responseData, encoding: .utf8) {
//                    
//                    print("uploaded to: \(responseString)")
//                }
//            }).resume()
//        }

