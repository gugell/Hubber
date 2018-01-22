//
//  ProfileViewController.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public enum Profile {
    case avatar(title: String, avatarUrl: String)
    case detail(title: String, detail: String)
    case listItem(title: String, description: String, language:String, stars:String)
}

public typealias ProfileSectionModel = SectionModel<String, Profile>

class ProfileViewController: UIViewController, UITableViewDelegate {

    var viewModel = ProfileViewModel()
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.

        self.navigationItem.rightBarButtonItems = [
            NavigationItems.logout(self, #selector(logout)).button()
        ]

        dataSource.configureCell = { dataSource, tableView, indexPath, element in
            switch element {
            case let .avatar(_, avatarUrl):
             let cell = tableView.dequeueReusableCell(withIdentifier: "avatarCell") as! AvatarTableViewCell
              cell.contentImageUrl = avatarUrl
               return cell
            case let .detail(_, detail):
                let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                cell.textLabel?.text = detail
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                return cell
            case let .listItem(title, desc, lng, stars):
                let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoCell
                cell.configure(title: title, description: desc, language: lng, stars: stars)
                return cell
            }
        }

        self.viewModel.outputs.profileObservable
        .asObservable()
            .bind(to:self.tableView.rx.items(dataSource: dataSource))
        .addDisposableTo(disposeBag)

        self.viewModel.outputs.selectedRepoViewModel?.drive(onNext: { repoViewModel in
            let repoViewController = RepoViewController()
            repoViewController.viewModel = repoViewModel
            self.navigationController?.pushViewController(repoViewController, animated: true)
        }).addDisposableTo(disposeBag)

    }

    func configureTableView() {

        self.title = NSLocalizedString("Profile", comment: "")
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        self.tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        self.tableView.dataSource = nil
        self.tableView.register(AvatarTableViewCell.self, forCellReuseIdentifier: "avatarCell")
        self.tableView.register(RepoCell.self, forCellReuseIdentifier: "repoCell")
        self.view = self.tableView

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .singleLine

        definesPresentationContext = true

        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.tapped(indexRow: indexPath.row)
            }).addDisposableTo(disposeBag)

    }

    @objc func logout() {
        AuthManager.shared.signOut()
        guard let delegate = UIApplication.shared.delegate as?  AppDelegate else { return }
        delegate.appStateInspector.inspectAppState()
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
