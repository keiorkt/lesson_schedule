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
        let trigger: Driver<Void>
        let groupingTrigger: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    private var isGrouped: Bool = false
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
    
    internal func transform(input: GroupByViewModel.Input) -> GroupByViewModel.Output {

        let trigger = input.trigger
            .do(onNext: {[weak self] _ -> () in
                guard let wSelf = self else { return }
                
                let lessonList = wSelf.lessons.value[0]
            })
            .asDriver(onErrorJustReturn: ())
        
        let items = self.lessons.asObservable()
            .map { (lessonMultiList) -> [GroupBySectionModel] in
                
                if lessonMultiList.count == 1 {
                    self.isGrouped = false
                } else {
                    self.isGrouped = true
                }
                
                return lessonMultiList.map { (lessonList) -> GroupBySectionModel in
                    
                    switch self.isGrouped {
                        case true:
                            return GroupBySectionModel(header: lessonList[0].difficulty.rawValue, items: lessonList)
                        case false:
                            return GroupBySectionModel(header: "すべて", items: lessonList)
                    }
                }
            }
            .asDriver(onErrorJustReturn: [])
        
    
        let groupingTrigger = input.groupingTrigger
            .do(onNext: { [weak self] _ -> () in
                guard let wSelf = self else { return }
                
                if wSelf.isGrouped == true {
                    
                    let flatLessonList = [wSelf.lessons.value.reduce([], +)]
                    
                    wSelf.lessons.value = flatLessonList
                    wSelf.isGrouped = false
                } else {
                    let lessonList = wSelf.lessons.value[0]
                    
                    let groupedDict = Dictionary.init(grouping: lessonList, by: { (lesson) -> String in
                        return lesson.difficulty.rawValue
                    })
                    
                    let keys = groupedDict.keys.sorted()
                    
                    var groupedLesson = [[Lesson]]()
                    
                    keys.forEach { (key) in
                        groupedLesson.append(groupedDict[key]!)
                    }
                    
                    wSelf.lessons.value = groupedLesson
                    wSelf.isGrouped = true
                }
            })
            .asDriver(onErrorJustReturn: ())
        
        return Output(items: items,trigger: trigger, groupingTrigger: groupingTrigger)
    }
}
