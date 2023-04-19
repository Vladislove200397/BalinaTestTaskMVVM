//
//  MainViewControllerViewModel.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import UIKit

class MainViewControllerViewModel {
    var dataModel: Dynamic<DataModel?> = Dynamic(nil)
    private var loadTask: Task<Void, Never>?
    private lazy var searchService = GETDataManager()
    private lazy var postService = POSTDataManager()
    var dataArray: [Content] = []
    var isLoading = false
    var page = 0
    var selectedIndexPath: Int = 0
    var requestError: Dynamic<Error?> = Dynamic(nil)
    var urlResponse: Dynamic<URLResponse?> = Dynamic(nil)
    
    @MainActor
    func getPaginationRequest(page: Int) {
        loadTask?.cancel()
        loadTask = Task {
            do {
                let paginationData = try await searchService.getData(requestType: .getDataPagination(page: "\(page)"))
                paginationData.content.forEach { contents in
                    dataArray.append(contents)
                    dataModel.value = paginationData
                }
            } catch {
                requestError.value = error
            }
        }
    }
    
    @MainActor
    func postData(name: String, id: Int, image: UIImage) {
        loadTask?.cancel()
        loadTask = Task {
            do {
                let urlResponse = try await postService.uploadData(name, id, image, to: .postData)
                self.urlResponse.value = urlResponse
            } catch {
                requestError.value = error
            }
        }
    }
}

