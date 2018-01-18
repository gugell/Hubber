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
}

public typealias ProfileSectionModel = SectionModel<String, Profile>

class ProfileViewController: UIViewController, UITableViewDelegate {

    let viewModel = ProfileViewModel()
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private let dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>()

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
            let cell = AvatarTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
              cell.contentImageUrl = avatarUrl
               return cell
            case let .detail(_, detail):
                let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
                cell.textLabel?.text = detail
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                return cell
            }
        }

        self.viewModel.outputs.profileObservable
        .asObservable()
            .bind(to:self.tableView.rx.items(dataSource: dataSource))
        .addDisposableTo(disposeBag)
        
    }

    @objc func logout(){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        self.title = NSLocalizedString("Profile", comment: "")
        self.tableView = UITableView(frame: UIScreen.main.bounds)
        /*
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        */
        self.tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        self.tableView.dataSource = nil
      
        
        self.view = self.tableView
      
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        definesPresentationContext = true
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
          return 150
        }
        return 40
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
