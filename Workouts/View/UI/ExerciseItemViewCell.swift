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
        static let mainStackViewPadding: CGFloat = 8
        static let mainStackViewSpacing: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let borderOpacity: CGFloat = 0.6
        static let textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

    private let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 13.0)
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
        contentView.backgroundColor = .clear
        setUpMainStackView()
        setUpTextStackView()
    }

    private func setUpMainStackView() {
        mainStackView.backgroundColor = .white
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = Constants.mainStackViewSpacing
        mainStackView.layer.borderColor = UIColor.lightGray.withAlphaComponent(Constants.borderOpacity).cgColor
        mainStackView.layer.borderWidth = Constants.borderWidth
        mainStackView.layer.cornerRadius = Constants.cornerRadius
        mainStackView.layer.masksToBounds = true

        mainStackView.addArrangedSubview(exerciseImageView)
        contentView.addSubview(mainStackView)
        
        mainStackView.anchorToSuperview(top: Constants.mainStackViewPadding, leading: Constants.mainStackViewPadding, bottom: Constants.mainStackViewPadding, trailing: Constants.mainStackViewPadding)
        
        exerciseImageView.setHeight(to: Constants.exerciseImageHeight)
        exerciseImageView.constraintLeadingTrailing(to: mainStackView)
    }

    private func setUpTextStackView() {
        textDetailStackView.axis = .vertical
        textDetailStackView.distribution = .fill
        textDetailStackView.alignment = .center

        textDetailStackView.isLayoutMarginsRelativeArrangement = true
        textDetailStackView.layoutMargins = Constants.textInsets

        textDetailStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(textDetailStackView)
    }
    
    // MARK: - displayItemExercise
    
    func displayItemExercise(with viewModel: ExerciseItemViewModel?) {
        guard let viewModel else { return }

        nameLabel.text = viewModel.name
        exerciseImageView.sd_setImage(with: viewModel.mainImageURL, placeholderImage: UIImage(named: "trainers"))
    }
}

