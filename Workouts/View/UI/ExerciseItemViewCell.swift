//
//  ExerciseItemViewCell.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import UIKit
import SDWebImage

final class ExerciseItemViewCell: UICollectionViewCell {
    private enum Constants {
        static let exerciseImageHeight: CGFloat = 180
    }

    private let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static var identifier: String {
        return String(describing: self)
    }

    private let mainStackView = UIStackView()
    private let textDetailStackView = UIStackView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.backgroundColor = .white
        setUpMainStackView()
        setUpTextStackView()
    }

    private func setUpMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        mainStackView.layer.borderWidth = 0.8
        mainStackView.layer.cornerRadius = 8
        mainStackView.layer.masksToBounds = true

        mainStackView.addArrangedSubview(exerciseImageView)
        contentView.addSubview(mainStackView)

        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        exerciseImageView.heightAnchor.constraint(equalToConstant: Constants.exerciseImageHeight).isActive = true
        exerciseImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        exerciseImageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
    }

    private func setUpTextStackView() {
        textDetailStackView.axis = .vertical
        textDetailStackView.distribution = .fill
        textDetailStackView.alignment = .leading

        textDetailStackView.isLayoutMarginsRelativeArrangement = true
        textDetailStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        textDetailStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(textDetailStackView)
    }
    
    // MARK: - displayItemExercise
    
    func displayItemExercise(with viewModel: ExerciseItemViewModel?) {
        guard let viewModel else { return }

        nameLabel.text = viewModel.name
        exerciseImageView.sd_setImage(with: viewModel.mainImageURL)
    }
}

