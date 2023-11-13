//
//  ExerciseImageView.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ExerciseImageView: View {
    let viewModel: ExerciseImageViewModel

    var body: some View {
        WebImage(url: viewModel.exerciseImageURL)
            .placeholder(Image("trainers").resizable())
            .resizable()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}
