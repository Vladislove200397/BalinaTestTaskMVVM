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
            self?.viewModel.isLoading = false
        }
        viewModel.urlResponse.bind { response in
            AlertManager.showAlert(on: self, title: "Succes", message: "POST data succeded")
        }
        viewModel.requestError.bind { error in
            AlertManager.showAlert(on: self, title: "Error", message: error?.localizedDescription ?? "")
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
        }
    }
    
    private func callImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DataCell.self), for: indexPath)
        
        guard let pagesCount = viewModel.dataModel.value?.totalPages else { return cell }
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath = indexPath.row
        callImagePicker()
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        let name = "Кулаковский Владислав Александрович"
        let id = viewModel.dataArray[viewModel.selectedIndexPath].id
        
        viewModel.postData(name: name, id: id, image: image)
        
    }
}
