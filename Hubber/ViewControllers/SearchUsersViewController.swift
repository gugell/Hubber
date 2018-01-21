//
//  SearchUsersViewController.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/20/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchUsersViewController:  UIViewController,UITableViewDelegate {

    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>()
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private let viewModel = SearchUsersViewModel()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    bindRx()
    
    }
    
    func bindRx() {
        dataSource.configureCell = { dataSource, tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserCell
        cell.configure(title: user.login ?? "" ,
                       description: "\(user.bio ?? "")",
                       language: "",
                       avatar:  user.avatarUrl ?? "")
        return cell
    }
    
    self.searchController.searchBar.rx.text
        .bind(to:viewModel.inputs.searchKeyword)
    .addDisposableTo(disposeBag)
    
    self.tableView.rx.reachedBottom
        .bind(to:viewModel.inputs.loadNextPageTrigger)
    .addDisposableTo(disposeBag)
    
    self.tableView.rx.itemSelected
    .map { (at: $0, animated: true) }
    .subscribe(onNext: tableView.deselectRow)
    .addDisposableTo(disposeBag)
    
    
    self.viewModel.outputs.elements.asDriver()
    .map { [SectionModel(model: "Users", items: $0)] }
    .drive(self.tableView.rx.items(dataSource: dataSource))
    .addDisposableTo(disposeBag)
    
    self.viewModel.isLoading
    .drive()
    .addDisposableTo(disposeBag)
    
    self.tableView.rx.contentOffset
    .subscribe { _ in
    if self.searchController.searchBar.isFirstResponder {
    _ = self.searchController.searchBar.resignFirstResponder()
    }
    }
    .addDisposableTo(disposeBag)
    
    self.tableView.rx.modelSelected(User.self)
    .subscribe(onNext: { user in
    self.viewModel.inputs.tapped(user: user)
    }).addDisposableTo(disposeBag)
    
    self.viewModel.outputs.selectedViewModel.drive(onNext: { userViewModel in
        let profileController  =  ProfileViewController()
        profileController.viewModel = userViewModel
        self.navigationController?.pushViewController(profileController, animated: true)
    }).addDisposableTo(disposeBag)
    
    }
    
    func configureTableView() {
    self.title = "Search"
    
    self.tableView = UITableView(frame: UIScreen.main.bounds)
    self.tableView.rx.setDelegate(self)
    .addDisposableTo(disposeBag)
    
    self.view = self.tableView
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
    // Do any additional setup after loading the view.
    self.searchController = UISearchController(searchResultsController: nil)
    self.searchController.dimsBackgroundDuringPresentation = false
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.searchBar.sizeToFit()
    
    self.tableView.tableHeaderView = self.searchController.searchBar
    
    definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
