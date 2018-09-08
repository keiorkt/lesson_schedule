//
//  LessonCell.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/08.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LessonCell: UITableViewCell {
    
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.disposeBag = DisposeBag()
    }
    
    func bind(_ item: Lesson) {
        lessonNameLabel.text = item.name
        creditLabel.text = String(item.credit)
        difficultyLabel.text = item.difficulty.rawValue
    }
}
