//
//  GroupByViewController.swift
//  TableViewGroupBy
//
//  Created by Keita Iwasaki on 2018/09/07.
//  Copyright © 2018 Keita Iwasaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = "LessonCell"

class GroupByViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource : RxTableViewSectionedReloadDataSource<SectionModel<String,Lesson>>?
    private var viewModel: GroupByViewModel = GroupByViewModel()
    
    
    @IBOutlet weak var groupButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "科目一覧"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        setUpDataSource()
        bindViewModel()
    }
    
    private func setUpDataSource() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Lesson>>(
            configureCell: {ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
                cell.textLabel?.text = item.name
                return cell
        })
        
        self.dataSource = dataSource
    }
    
    private func bindViewModel() {
        
        
        let trigger = rx
            .sentMessage(#selector(viewWillAppear(_:)))
            .map{ _ in ()}
            .share(replay: 1)
        
        let input = GroupByViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
    }
}
