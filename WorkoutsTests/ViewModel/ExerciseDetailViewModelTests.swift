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
        let service = MockExerciseManager()
        let sut = ExerciseDetailViewModel(service: service)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(service.fetchVariationsWasCalled, "fetchVariations should have been called")
        XCTAssertEqual(service.fetchVariationsCallsCount, 1, "fetchVariations should have been called just once")
    }
    
    private class ExerciseDetailViewModel {
        
        private let service: ExerciseService
        
        init(service: ExerciseService = ExerciseManager()) {
            self.service = service
        }
        
        func loadExerciseVariations() async {
            _ = try? await service.fetchVariations(for: [1])
        }
    }
}
