//
//  ExerciseListViewModelTest.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseListViewModelTest: XCTestCase {
    func test_loadExercises_callsExerciseManager() async {
        let service = MockExerciseManager()
        let sut = ExerciseListViewModel(service: service)
        
        await sut.loadExercises()
        
        XCTAssertTrue(service.fetchWasCalled)
    }
    
    private class ExerciseListViewModel {
        private let service: ExerciseService
        
        init(service: ExerciseService) {
            self.service = service
        }

        func loadExercises() async {
            _ = try? await service.fetch()
        }
    }
    
    private class MockExerciseManager: ExerciseService {
        private(set) var fetchWasCalled = false
        private(set) var fetchCallsCount = 0

        func fetch() async throws -> [Exercise] {
            fetchWasCalled = true
            fetchCallsCount += 1
            
            return []
        }
    }
}
