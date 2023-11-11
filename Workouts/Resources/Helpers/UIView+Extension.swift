//
//  UIView+Extension.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import UIKit

extension UIView {
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setHeight(to height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func centerInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    func anchorToSuperview(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
    }
    
    func constraintLeadingTrailing(to referenceView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: referenceView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: referenceView.trailingAnchor).isActive = true
    }
}
