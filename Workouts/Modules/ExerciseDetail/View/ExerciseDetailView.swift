//
//  ExerciseDetailView.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExerciseDetailView: View {
    @StateObject var viewModel: ExerciseDetailViewModel

    var body: some View {
        ZStack {
            Color(uiColor: Colors.beige)
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    topSection
                    
                    if viewModel.shouldDisplayImagesSection {
                        imagesSection
                    }
                    
                    if viewModel.shouldDisplayVariationsSection {
                        variationsSection
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationBarTitle("", displayMode: .inline)
        .task {
            await viewModel.loadExerciseVariations()
        }
    }
    
    private var topSection: some View {
        VStack(spacing: 30) {
            ExerciseImageView(viewModel: viewModel.exerciseImageViewModel)
                .frame(width: 250, height: 250)
                .cornerRadius(8)
            
            VStack(spacing: 10) {
                Text(viewModel.name)
                    .font(.custom(
                        "AvenirNext-Bold",
                        fixedSize: 17))
                
                Text(viewModel.description)
                    .font(.custom(
                        "AvenirNext-Regular",
                        fixedSize: 15))
            }
        }
    }
    
    private var imagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Images")
                .font(.custom(
                    "AvenirNext-Bold",
                    fixedSize: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider().background(.gray)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.exerciseImages) { exerciseImage in
                        ExerciseImageView(viewModel: .init(exerciseImage: exerciseImage))
                            .frame(width: 150, height: 150)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var variationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Variations")
                .font(.custom(
                    "AvenirNext-Bold",
                    fixedSize: 18))

            Divider()
                .background(.gray)

            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                    ForEach($viewModel.exerciseVariations) { exercise in
                        ExerciseItemView(viewModel: viewModel.exerciseItemViewModel(exercise: exercise.wrappedValue))
                            .onTapGesture {
                                viewModel.didSelectVariation(with: exercise.wrappedValue)
                            }
                    }
                }
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    let viewModel = ExerciseDetailViewModel(exercise: Exercise(id: 1,
                                                                      name: "Abdominales",
                                                                      description: "As a warmup, use light dumbbells, one in each hand. Lunge in alternating directions, forward, sideways, backwards and 45 degree angles.",
                                                                      images: [
                                                                       ExerciseImage(id: 2, isMain: true, image: "")
                                                                              ],
                                                               variations: []), coordinator: ExerciseCoordinatorManager(), isVariationExerciseDetail: false)

    return ExerciseDetailView(viewModel: viewModel)
}
