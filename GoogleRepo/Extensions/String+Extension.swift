//
//  String+Extension.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 27/09/2024.
//

import Foundation

extension String {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
