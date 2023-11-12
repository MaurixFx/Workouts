//
//  ExerciseListViewController.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import UIKit
import Combine

final class ExerciseListViewController: UIViewController {
    private enum Constants {
        static let minimumInterSpacing: CGFloat = 8
        static let spinnerSize: CGFloat = 100
        static let collectionViewPadding: CGFloat = 10
    }
    
    private let viewModel: ExerciseListViewModel
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.minimumInterSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExerciseItemViewCell.self, forCellWithReuseIdentifier: ExerciseItemViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()
    
    private var spinnerLoaderView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        return spinner
    }()
    
    private var anyCancellables = [AnyCancellable]()

    // MARK: - Init

    init(viewModel: ExerciseListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    // MARK: - Setup View
    
    private func setUpView() {
        view.backgroundColor = Colors.beige
        configureCollectionView()
        configureSpinnerLoaderView()
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.anchorToSuperview(top: Constants.collectionViewPadding, leading: 0, bottom: Constants.collectionViewPadding, trailing: 0)
    }
    
    private func configureSpinnerLoaderView() {
        view.addSubview(spinnerLoaderView)
        
        spinnerLoaderView.setDimensions(width: Constants.spinnerSize, height: Constants.spinnerSize)
        spinnerLoaderView.centerInSuperview()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Colors.beige
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "Exercices"
    }
    
    // MARK: - Load
    
    func load() {
        Task {
            await viewModel.loadExercises()
        }
    }
    
    // MARK: - BindViewModel
    
    private func bindViewModel() {
        viewModel.currentState.sink { [weak self] state in
            switch state {
            case .loading:
                self?.spinnerLoaderView.startAnimating()
            case .reloadCollection:
                self?.collectionView.reloadData()
                self?.spinnerLoaderView.stopAnimating()
            default:
                break
            }
        }
        .store(in: &anyCancellables)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDelegate

extension ExerciseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(for: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExerciseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.cellSizeItem(with: collectionView.bounds.width)
    }
}
