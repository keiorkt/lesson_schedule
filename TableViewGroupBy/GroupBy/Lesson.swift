//
//  Lesson.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/07.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import Foundation

public struct Lesson {
    let name: String
    let credit: Int
    let difficulty: Difficulty
    
    enum Difficulty: Hashable{
        case A,B,C,D
    }
}
