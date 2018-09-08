//
//  Lesson.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/07.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import Foundation

public struct Lesson: Comparable {
    let name: String
    let credit: Int
    let difficulty: Difficulty
    
    enum Difficulty: String {
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
    }
    
    public static func < (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.difficulty.rawValue < rhs.difficulty.rawValue
    }
}

