//
//  WorkoutsEndToEndTests.swift
//  WorkoutsEndToEndTests
//
//  Created by Mauricio Figueroa on 14-11-23.
//

import XCTest
@testable import Workouts

final class WorkoutsEndToEndTests: XCTestCase {
    func test_endToEndTestServerGETExercisesResult_matchesFixedTestExerciseData() async {
        let client = APIClient()
        let expectedExercise = anyTextExercisesData.first!
        
        do {
            let response = try await client.get("https://run.mocky.io/v3/ac5e05d3-470f-4a6a-a9dd-a5d23d760914", responseType: ExerciseResponse.self)
            
            XCTAssertEqual(response.results.first!.id, expectedExercise.id)
            XCTAssertEqual(response.results.first!.name, expectedExercise.name)
            XCTAssertEqual(response.results.first!.description, expectedExercise.description)
            XCTAssertEqual(response.results.first!.images, expectedExercise.images)
            XCTAssertEqual(response.results.first!.variations, expectedExercise.variations)
        } catch {
            XCTFail("Request should have not been failed, it is possible that the mock api is not working")
        }
    }
    
    private var anyTextExercisesData: [Exercise] {
        [
            Exercise(id: 345,
                     name: "2 Handed Kettlebell Swing",
                     description: "<p>Two Handed Russian Style Kettlebell swing</p>",
                     images: [],
                     variations: [345, 249])
        ]
    }
}
