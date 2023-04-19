//
//  MainViewController.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import UIKit

class MainViewController: MVVMController {
    var contentView: MainViewControllerView {
        return view as! MainViewControllerView
    }
    
    let viewModel: MainViewControllerViewModel
    
    init(viewModel: MainViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MainViewControllerView()
    }
    
    override func viewDidLoad() {
        setupDelegates()
        bindViewModel()
        viewModel.getPaginationRequest(page: viewModel.page)
    }
    
    override func bindViewModel() {
        viewModel.dataModel.bind {[weak self] dataModel in
            self?.contentView.tableView.reloadData()
        }
    }
    
    override func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    private func fetchMoreData() {
        if !viewModel.isLoading {
            viewModel.page += 1
            viewModel.isLoading = true
            viewModel.getPaginationRequest(page: viewModel.page)
            viewModel.dataModel.bind { model in
                self.contentView.tableView.reloadData()
                self.viewModel.isLoading = false
            }
        }
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DataCell.self), for: indexPath)
        
        guard let dataModel = viewModel.dataModel.value?.content,
              let pagesCount = viewModel.dataModel.value?.totalPages else { return cell }
        
        (cell as? DataCell)?.set(dataModel: viewModel.dataArray[indexPath.row])
        
        if indexPath.row == viewModel.dataArray.count - 1 {
            if pagesCount <= pagesCount {
                fetchMoreData()
            }
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let dataCount = viewModel.dataModel.value?.content.count,
//                let pagesCount = viewModel.dataModel.value?.totalPages else { return }
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        let deltaOffset = maximumOffset - currentOffset
//
//        if deltaOffset <= 0, dataCount <= pagesCount  {
//            fetchMoreData()
//        }
//    }
}
