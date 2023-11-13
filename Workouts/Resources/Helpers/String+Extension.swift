//
//  String+Extension.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation

extension String {
    var plainTextFromHTML: String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            return nil
        }
    }
}
