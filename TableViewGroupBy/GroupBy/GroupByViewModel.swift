//
//  GroupByViewModel.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/07.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class GroupByViewModel {
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[SectionModel<String, Lesson>]>
    }
    
    private let disposeBag = DisposeBag()
    private let lessons = Variable<[Lesson]>([Lesson.init(name: "統計学", credit: 1, difficulty: .B),
                                              Lesson.init(name: "会計学", credit: 2, difficulty: .C),
                                              Lesson.init(name: "微分", credit: 2, difficulty: .A),
                                              Lesson.init(name: "マクロ経済学", credit: 2, difficulty: .B),
                                              Lesson.init(name: "ミクロ経済学", credit: 2, difficulty: .C),
                                              Lesson.init(name: "英語", credit: 2, difficulty: .D),
                                              Lesson.init(name: "積分", credit: 2, difficulty: .B),
                                              Lesson.init(name: "線形代数", credit: 2, difficulty: .B),
                                              Lesson.init(name: "中国語", credit: 2, difficulty: .C),
                                              Lesson.init(name: "社会学", credit: 2, difficulty: .C)])
    
    internal func transform(input: GroupByViewModel.Input) -> GroupByViewModel.Output {
        
        let items = self.lessons.asObservable()
            .map{[SectionModel(model: "", items: $0)]}
            .asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
}
