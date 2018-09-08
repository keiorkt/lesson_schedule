//
//  GroupBySectionModel.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/08.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import Foundation
import RxDataSources

struct GroupBySectionModel {
    var header: String
    var items: [Item]
}

extension GroupBySectionModel: SectionModelType {
    typealias Item = Lesson
    
    init(original: GroupBySectionModel, items: [Lesson]) {
        self = original
        self.items = items
    }
}
