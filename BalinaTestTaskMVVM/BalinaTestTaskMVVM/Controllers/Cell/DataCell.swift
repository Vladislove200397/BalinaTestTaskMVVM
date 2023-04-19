//
//  DataCell.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import UIKit

class DataCell: MVVMTableViewCell {
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var dataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray.withAlphaComponent(0.7)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .medium
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var loadImageTask: Task<Void, Never>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        layoutElements()
        makeConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutElements() {
        addSubview(containerView)
        containerView.addSubview(labelStack)
        containerView.addSubview(dataImageView)
        dataImageView.addSubview(activityIndicatorView)
        labelStack.addArrangedSubview(idLabel)
        labelStack.addArrangedSubview(nameLabel)
    }
    
    override func makeConstraints() {
        containerViewMakeConstraints()
        dataImageViewMakeConstraints()
        labelStackMakeConstraints()
        activityIndicatorViewMakeConstraints()
    }
    
    func set(dataModel: Content) {
        nameLabel.text = dataModel.name
        idLabel.text = "\(dataModel.id)"
        guard let imageURL = dataModel.image else {
            dataImageView.image = UIImage(systemName: "xmark")!
            return
        }
        configureImage(for: URL(string: imageURL)!)
    }
    
    private func configureImage(for url: URL) {
            loadImageTask?.cancel()

            loadImageTask = Task { [weak self] in
                self?.dataImageView.image = nil
                self?.activityIndicatorView.startAnimating()
                
                do {
                    try await self?.dataImageView.setImage(by: url)
                    self?.dataImageView.contentMode = .scaleAspectFit
                } catch {
                    self?.dataImageView.contentMode = .center
                }

                self?.activityIndicatorView.stopAnimating()
            }
        }
}

extension DataCell {
    private func containerViewMakeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    private func dataImageViewMakeConstraints() {
        NSLayoutConstraint.activate([
            dataImageView.heightAnchor.constraint(equalToConstant: 45),
            dataImageView.widthAnchor.constraint(equalToConstant: 50),
            dataImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dataImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
        ])
    }
    
    private func labelStackMakeConstraints() {
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: dataImageView.trailingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            labelStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5)
        ])
    }
    
    private func activityIndicatorViewMakeConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: dataImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: dataImageView.centerYAnchor)
        ])
    }
}
