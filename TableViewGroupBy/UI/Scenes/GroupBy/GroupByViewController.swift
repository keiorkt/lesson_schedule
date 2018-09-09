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

private let lessonReuseIdentifier = "LessonCell"

class GroupByViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource : RxTableViewSectionedReloadDataSource<GroupBySectionModel>?
    private var viewModel: GroupByViewModel = GroupByViewModel()
    
    private var isAll: Bool = true
    private var isFirstLoad: Bool = true
    
    @IBOutlet weak var groupButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpTableView()
        setUpDataSource()
        bindViewModel()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "講座一覧"
        navigationItem.rightBarButtonItem?.title = "難易度別"
    }
    
    private func setUpTableView() {
        tableView.register(R.nib.lessonCell(), forCellReuseIdentifier: lessonReuseIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.sectionHeaderHeight = 30
    }
    
    private func setUpDataSource() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<GroupBySectionModel>(
            configureCell: { (ds, tv, ip, item) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: lessonReuseIdentifier) as! LessonCell
                cell.bind(item)
                return cell
        },titleForHeaderInSection: { ds, index in
            return ds.sectionModels[index].header
        })
        
        self.dataSource = dataSource
    }
    
    private func bindViewModel() {
        
        let groupingTrigger = groupButton.rx.tap
            .map{ _ in ()}
            .asDriver(onErrorJustReturn: ())
        
        let trigger = rx
            .sentMessage(#selector(viewWillAppear(_:)))
            .map{ _ in ()}
            .share(replay: 1)
        
        let input = GroupByViewModel.Input(trigger: trigger.asDriver(onErrorJustReturn: ()), groupingTrigger: groupingTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        output.trigger
            .drive()
            .disposed(by: disposeBag)
        
        output.groupingTrigger
            .drive(onNext: { [weak self] in
                guard let wSelf = self else { return }
                
                if wSelf.isAll && !wSelf.isFirstLoad {
                    wSelf.navigationItem.rightBarButtonItem?.title = "難易度別"
                    wSelf.isAll = false
                } else {
                    wSelf.navigationItem.rightBarButtonItem?.title = "すべて"
                    wSelf.isAll = true
                }
                
                wSelf.isFirstLoad = false
                
                wSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension GroupByViewController: UIScrollViewDelegate {
    // in order to set the delegate for the tableview
}

