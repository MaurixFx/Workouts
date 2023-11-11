//
//  ExerciseListViewController.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import UIKit

final class ExerciseListViewController: UIViewController {
    private let viewModel: ExerciseListViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExerciseItemViewCell.self, forCellWithReuseIdentifier: ExerciseItemViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - Init

    init(viewModel: ExerciseListViewModelProtocol = ExerciseListViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    }
    
    // MARK: - Setup View
    
    private func setUpView() {
        view.backgroundColor = .white
        configureCollectionView()
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: - Load
    
    private func load() {
        Task {
            await viewModel.loadExercises()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ExerciseListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseItemViewCell.identifier, for: indexPath) as? ExerciseItemViewCell else {
            return UICollectionViewCell()
        }

        cell.displayItemExercise(with: viewModel.exerciseListItemViewModel(for: indexPath.row))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExerciseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.cellSizeItem(with: collectionView.bounds.width)
    }
}
