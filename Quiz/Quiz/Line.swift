//
//  Line.swift
//  Quiz
//
//  Created by Matiara Sianipar on 12/1/21.
//

import Foundation
import CoreGraphics
import UIKit

struct Line: Codable {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var color = 0
    
    init (begin: CGPoint, end: CGPoint, color: Int) {
        self.begin = begin
        self.end = end
        self.color = color
    }
    
    func getColor() -> UIColor {
        switch (color) {
        case 0:
            return UIColor.black
        case 1:
            return UIColor.systemPink
        case 2:
            return UIColor.purple
        case 3:
            return UIColor.yellow
        default:
            return UIColor.black
        }
    }
    
}
