//
//  Ultis.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 27/09/2024.
//

import Foundation
import UIKit
class Utils {
    class func getLanguageColor(language: String) -> UIColor {
        let colorDict = Utils.readJSONFile(forName: "color_git")
        if let colorLanguage = colorDict[language] as? [String:Any], let colorHex = colorLanguage["color"] as? String {
            let color = UIColor.hexStringToUIColor(hex: colorHex)
            return color
        } else {
            return .clear
        }
    }
    
    class func readJSONFile(forName name: String) -> [String:Any]{
       do {
          if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
          let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
             if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any] {
                return json
             } else {
                print("Given JSON is not a valid dictionary object.")
                 return [:]
             }
          }
       } catch {
          print(error)
       }
        return [:]
    }
}
