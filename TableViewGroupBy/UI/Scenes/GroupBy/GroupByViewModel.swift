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
        let groupingTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[GroupBySectionModel]>
        let groupingTrigger: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    private var lessons = Variable<[[Lesson]]>([[Lesson.init(name: "統計学", credit: 1, difficulty: .B),
                                              Lesson.init(name: "会計学", credit: 2, difficulty: .C),
                                              Lesson.init(name: "微分", credit: 2, difficulty: .A),
                                              Lesson.init(name: "マクロ経済学", credit: 2, difficulty: .B),
                                              Lesson.init(name: "ミクロ経済学", credit: 2, difficulty: .C),
                                              Lesson.init(name: "英語", credit: 2, difficulty: .D),
                                              Lesson.init(name: "積分", credit: 2, difficulty: .B),
                                              Lesson.init(name: "線形代数", credit: 2, difficulty: .B),
                                              Lesson.init(name: "中国語", credit: 2, difficulty: .C),
                                              Lesson.init(name: "社会学", credit: 2, difficulty: .C)]])
    
    private var lessonsDict = Variable<[String:Array<Lesson>]>([:])
    
    internal func transform(input: GroupByViewModel.Input) -> GroupByViewModel.Output {
//
//        let items = self.lessons.asObservable()
//            .map { (multiLessonList) -> [GroupBySectionModel] in
//                return multiLessonList.map { (lessonlist) -> GroupBySectionModel in
//                    return GroupBySectionModel(header: lessonlist.first!.name, items: lessonlist)
//                }
//            }
//            .asDriver(onErrorJustReturn: [])
        
        let items = self.lessonsDict.asObservable()
            .map{ (dictList) -> [GroupBySectionModel] in
                return dictList.map { (dict) -> GroupBySectionModel in
                    return GroupBySectionModel(header: dict.key, items: dict.value)
                }
            }
            .asDriver(onErrorJustReturn: [])
    
        let groupingTrigger = input.groupingTrigger
            .do(onNext: { [weak self] _ -> () in
                guard let wSelf = self else { return }
                
                let lessonList = wSelf.lessons.value[0]

                let groupedDict = Dictionary.init(grouping: lessonList, by: { (lesson) -> String in
                    return lesson.difficulty.rawValue
                })
                
                wSelf.lessonsDict.value = groupedDict
            })
            .asDriver(onErrorJustReturn: ())
        
        return Output(items: items, groupingTrigger: groupingTrigger)
    }
}
