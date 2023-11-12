//
//  ExerciseDetailViewModelTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseDetailViewModelTests: XCTestCase {
    func test_loadExerciseVariations_callsExerciseManager() async {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(service.fetchVariationsWasCalled, "fetchVariations should have been called")
        XCTAssertEqual(service.fetchVariationsCallsCount, 1, "fetchVariations should have been called just once")
    }
    
    func test_loadExerciseVariations_doesNotSetTheExercisesResult_whenExerciseManagerFails() async throws {
        let expectedError = APIError.invalidResponse
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExerciseVariations()
        
        let exerciseVariations: [Exercise] = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "exerciseVariations")
        )
        
        XCTAssertTrue(exerciseVariations.isEmpty, "currentState should be .error when ExerciseManager fails")
    }
    
    func test_loadExerciseVariations_setTheExpectedExercisesResult_whenExerciseManagerSucceeds() async throws {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExerciseVariations()
        
        let exerciseVariations: [Exercise] = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "exerciseVariations")
        )
        
        XCTAssertEqual(exerciseVariations, anyExerciseResponse.results, "currentState should be .error when ExerciseManager fails")
    }
    
    func test_shouldDisplayImagesSection_returnsTrue_whenExerciseHasMoreThanOneImage() {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        XCTAssertTrue(sut.shouldDisplayImagesSection, "shouldDisplayImagesSection should be equal to true when the exercise has more than one image")
    }
    
    func test_shouldDisplayImagesSection_returnsFalse_whenExerciseDoesNotHaveMoreThanOneImage() {
        let (sut, service) = makeSUT(with: anyExerciseResponse.results.first!)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        XCTAssertTrue(sut.shouldDisplayImagesSection == false, "shouldDisplayImagesSection should be equal to false when the exercise does not have more than one image")
    }
    
    func test_exerciseImageURL_returnsAnURL_whenMainImageExists() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.exerciseImageURL, URL(string: "https://fakeURL.com"), "exerciseImageURL should have returned the expected URL")
    }
    
    func test_exerciseImageURL_returnsNil_whenImagesArrayIsEmpty() {
        let (sut, _) = makeSUT(with: Exercise(id: 1, name: "", description: "", images: [], variations: []))
        
        XCTAssertEqual(sut.exerciseImageURL, nil, "exerciseImageURL should have returned nil when images array is empty")
    }
    
    func test_exerciseImageURL_returnsNil_whenMainImageDoesNotExist() {
        let (sut, _) = makeSUT(with: anyExerciseWithoutMainImage)
        
        XCTAssertEqual(sut.exerciseImageURL, nil, "exerciseImageURL should have returned nil when main image does not exist")
    }
    
    func test_name_returnsExpectedValue() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.name, "Abs Abs")
    }
    
    func test_description_returnsExpectedValue() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.description, "bla bla bla bla")
    }
    
    func test_shouldDisplayVariationsSection_returnsTrue_whenExerciseVariationsCollectionIsNotEmpty() async {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(sut.shouldDisplayVariationsSection, "shouldDisplayVariationsSection should be equal to true when the exercisesVariations array is not empty")
    }
    
    func test_shouldDisplayVariationsSection_returnsFalse_whenExerciseVariationsCollectionIsEmpty() async {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .failure(APIError.invalidResponse)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(sut.shouldDisplayVariationsSection == false, "shouldDisplayVariationsSection should be equal to false when the exercisesVariations array is empty")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(with exercise: Exercise) -> (sut: ExerciseDetailViewModel, service: MockExerciseManager) {
        let service = MockExerciseManager()
        let sut = ExerciseDetailViewModel(exercise: exercise, service: service)
        
        return (sut, service)
    }
    
    private var anyExerciseWithTwoImages: Exercise {
        Exercise(id: 1,
                 name: "Abs Abs",
                 description: "bla bla bla bla",
                 images: [
                    ExerciseImage(id: 1, isMain: true, image: "https://fakeURL.com"),
                    ExerciseImage(id: 2, isMain: false, image: "https://fakeURL.com"),
                 ],
                 variations: []
        )
    }
    
    private var anyExerciseWithoutMainImage: Exercise {
        Exercise(id: 1,
                 name: "Abs Abs",
                 description: "bla bla bla bla",
                 images: [
                    ExerciseImage(id: 1, isMain: false, image: "https://fakeURL.com"),
                 ],
                 variations: []
        )
    }
    
    private var anyExerciseResponse: ExerciseResponse {
        .init(results: [
            Exercise(id: 4,
                     name: "Abs Abs",
                     description: "bla bla bla bla",
                     images: [],
                     variations: []
                    )
        ])
    }
    
    private class ExerciseDetailViewModel {
        
        private let exercise: Exercise
        private let service: ExerciseService
        private var exerciseVariations: [Exercise] = []
        
        init(exercise: Exercise, service: ExerciseService = ExerciseManager()) {
            self.exercise = exercise
            self.service = service
        }
        
        func loadExerciseVariations() async {
            if let exercices = try? await service.fetchVariations(for: [1]) {
                exerciseVariations = exercices
            }
        }
        
        var exerciseImageURL: URL? {
            guard let images = exercise.images else { return nil }
            
            return URL(string: images.first(where: { $0.isMain })?.image ?? "")
        }
        
        var name: String {
            exercise.name
        }
        
        var description: String {
            exercise.description
        }
        
        var shouldDisplayImagesSection: Bool {
            guard let images = exercise.images else {
                return false
            }
            
            return images.count > 1
        }
        
        var shouldDisplayVariationsSection: Bool {
            return exerciseVariations.count > 0
        }
    }
}
