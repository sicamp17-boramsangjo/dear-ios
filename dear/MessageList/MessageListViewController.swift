//
//  MessageListViewController.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 12..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AKSideMenu

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private let apiManager: APIManager
    private var fixture: [MessageViewModel] = [
        MessageViewModel(cellType:.question(true), content:MessageContent.Text("TextContent"), updateTime:Date()),
        MessageViewModel(cellType:.anwser, content:MessageContent.Text("TextContent"), updateTime:Date()),
        MessageViewModel(cellType:.anwser, content:MessageContent.Image(URL(string:"http://coresos.phinf.naver.net/a/2hc588_a/044Ud015ej0w68i1g7gh_x77su7.jpg")!, CGSize(width: 320, height: 240)), updateTime:Date()),
        MessageViewModel(cellType:.anwser, content:MessageContent.Text("TextContent LongLong TextContent LongLong TextContent LongLong TextContent LongLong TextContent LongLongTextContent LongLong TextContent LongLong"), updateTime:Date()),
        MessageViewModel(cellType:.question(false), content:MessageContent.Text("TextContent?"), updateTime:Date()),

    ]

    var testValue: Int?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        print("init nibName style")
        self.apiManager = APIManager(session: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        print("init coder style")
        self.apiManager = APIManager(session: nil)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        self.edgesForExtendedLayout = []

        // Setup navigation item
        self.navigationItem.title = "Dear"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuButtonTapped))

        // setup tableview
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }

        self.tableView = tableView
    }

    @objc private func menuButtonTapped() {
        //TODO: Toggle left side menu
        self.sideMenuViewController?.presentLeftMenuViewController()
    }

    // MARK: UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fixture.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell else {
            fatalError()
        }
        cell.setupCell(viewModel: self.fixture[indexPath.row])

        return cell

    }

}
