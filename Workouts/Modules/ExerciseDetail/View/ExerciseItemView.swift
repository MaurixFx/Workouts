//
//  ExerciseItemView.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import SwiftUI

struct ExerciseItemView: View {
    let viewModel: ExerciseItemViewModel
    
    private enum Constants {
        static let mainSpacing: CGFloat = 20
        static let imageSize: CGFloat = 160
        static let heightView: CGFloat = 220
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let borderOpacity: CGFloat = 0.6
    }

    var body: some View {
        VStack(spacing: Constants.mainSpacing) {
            ExerciseImageView(viewModel: .init(exerciseImage: viewModel.mainExerciseImage))
                .frame(height: Constants.imageSize)
            
            Text(viewModel.name)
                .font(.custom(
                    "AvenirNext-Medium",
                    fixedSize: 12))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
        }
        .frame(width: Constants.imageSize, height: Constants.heightView, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(.white)
        )
        .mask(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(.gray.opacity(Constants.borderOpacity), lineWidth: Constants.lineWidth)
        )
    }
}

struct ExerciseItemView_Previews: PreviewProvider {
    static let viewModel = ExerciseItemViewModel(
        name: "Abdominales",
        mainExerciseImage: nil)
    
    static var previews: some View {
        ExerciseItemView(viewModel: viewModel)
    }
}


