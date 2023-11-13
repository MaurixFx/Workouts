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
    
    func test_loadExerciseVariations_doesNotSetTheExercisesResult_whenExerciseManagerFails() async {
        let expectedError = APIError.invalidResponse
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(sut.exerciseVariations.isEmpty, "should have not set the exercises result when ExerciseManager fails")
    }
    
    func test_loadExerciseVariations_setTheExpectedExercisesResult_whenExerciseManagerSucceeds() async {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExerciseVariations()
        
        XCTAssertEqual(sut.exerciseVariations, anyExerciseResponse.results, "should have set the exercises result when ExerciseManager succeeds")
    }
    
    func test_shouldDisplayImagesSection_returnsTrue_whenExerciseHasMoreThanOneImage() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertTrue(sut.shouldDisplayImagesSection, "shouldDisplayImagesSection should be equal to true when the exercise has more than one image")
    }
    
    func test_shouldDisplayImagesSection_returnsFalse_whenExerciseDoesNotHaveMoreThanOneImage() {
        let (sut, _) = makeSUT(with: anyExerciseResponse.results.first!)
        
        XCTAssertTrue(sut.shouldDisplayImagesSection == false, "shouldDisplayImagesSection should be equal to false when the exercise does not have more than one image")
    }
    
    func test_shouldDisplayImagesSection_returnsFalse_whenExerciseImagesArrayIsNil() {
        let (sut, _) = makeSUT(with: anyExerciseWithNilImages)
        
        XCTAssertTrue(sut.shouldDisplayImagesSection == false, "shouldDisplayImagesSection should be equal to false when the exercise does not have more than one image")
    }
    
    func test_name_returnsExpectedValue() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.name, "Abs Abs")
    }
    
    func test_description_returnsExpectedValue_whenDescriptionDoesNotContainHTMLFormats() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.description, "bla bla bla bla")
    }
    
    func test_description_returnsExpectedValue_whenDescriptiontContainsHTMLFormats() {
        let (sut, _) = makeSUT(with: anyExerciseWithHTMLDescription)
        
        XCTAssertEqual(sut.description, "Ausgangsposition:\nBeginnen Sie im Stehen mit Kurzhanteln in jeder Hand, mit geradem Rücken und hüftbreit auseinander stehenden Füßen. Die Arme sind entspannt und zeigen nach unten. Die Knie sollten leicht gebeugt, die Bauchmuskeln angespannt und die Schultern nach unten gerichtet sein.\nDie Schritte:\n\t1.\tBeugen Sie einen Arm am Ellenbogen und führen Sie die Hantel bis zur Schulter. Ihr Oberarm sollte während dieser Bewegung unbeweglich bleiben.\n\t2.\tBringen Sie die Hantel wieder nach unten, bis sich Ihr Arm in seiner ursprünglichen, entspannten Position befindet.\n\t3.\tWiederholen Sie die Übung mit dem anderen Arm.\n")
    }
    
    func test_description_returnsEmptyText_whenDescriptiontContainsWrongHTMLFormat() {
        let (sut, _) = makeSUT(with: anyExerciseWithWrongHTMLDescription)
        
        XCTAssertTrue(sut.description.isEmpty, "description should have returned empty text since it has a wrong HTML format")
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
    
    func test_exerciseImages_returnsEmpty_whenExerciseHasAnEmptyImagesArray() {
        let (sut, service) = makeSUT(with: anyExerciseWithHTMLDescription)
        service.fetchResult = .failure(APIError.invalidResponse)
        
        XCTAssertTrue(sut.exerciseImages.isEmpty, "exerciseImages should have returned empty when the exercise does not have a images array list")
    }
    
    func test_exerciseImages_returnsEmpty_whenExerciseHasANilImagesArray() {
        let (sut, service) = makeSUT(with: anyExerciseWithNilImages)
        service.fetchResult = .failure(APIError.invalidResponse)
        
        XCTAssertTrue(sut.exerciseImages.isEmpty, "exerciseImages should have returned empty when the exercise does not have a images array list")
    }
    
    func test_exerciseImages_returnsExpectedImagesArrayList_whenExerciseHasImagesArray() {
        let (sut, service) = makeSUT(with: anyExerciseWithTwoImages)
        service.fetchResult = .failure(APIError.invalidResponse)
        
        XCTAssertEqual(sut.exerciseImages.count, 2, "exerciseImages should have returned the expected amount of images when the exercise has a images array list")
    }
    
    func test_exerciseImageViewModel_returnsExpectedValue() {
        let (sut, _) = makeSUT(with: anyExerciseWithTwoImages)
        
        XCTAssertEqual(sut.exerciseImageViewModel.exerciseImageURL, URL(string: "https://fakeURL.com"), "exerciseImageViewModel should have returned the expected value")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(with exercise: Exercise) -> (sut: ExerciseDetailViewModel, service: MockExerciseManager) {
        let service = MockExerciseManager()
        let sut = ExerciseDetailViewModel(exercise: exercise, service: service)
        
        return (sut, service)
    }
    
    private var anyExerciseWithHTMLDescription: Exercise {
        Exercise(
            id: 1,
            name: "Jumps",
            description: "<p>Ausgangsposition:</p><p>Beginnen Sie im Stehen mit Kurzhanteln in jeder Hand, mit geradem Rücken und hüftbreit auseinander stehenden Füßen. Die Arme sind entspannt und zeigen nach unten. Die Knie sollten leicht gebeugt, die Bauchmuskeln angespannt und die Schultern nach unten gerichtet sein.</p><p>Die Schritte:</p><ol><li>Beugen Sie einen Arm am Ellenbogen und führen Sie die Hantel bis zur Schulter. Ihr Oberarm sollte während dieser Bewegung unbeweglich bleiben.</li><li>Bringen Sie die Hantel wieder nach unten, bis sich Ihr Arm in seiner ursprünglichen, entspannten Position befindet.</li><li>Wiederholen Sie die Übung mit dem anderen Arm.</li></ol>",
            images: [],
            variations: []
        )
    }
    
    private var anyExerciseWithWrongHTMLDescription: Exercise {
        Exercise(
            id: 1,
            name: "Jumps",
            description: "",
            images: [],
            variations: []
        )
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
    
    private var anyExerciseWithNilImages: Exercise {
        Exercise(id: 1,
                 name: "Abs Abs",
                 description: "bla bla bla bla",
                 images: nil,
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
}
