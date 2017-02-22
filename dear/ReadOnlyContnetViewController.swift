//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class ReadOnlyContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let apiManager:APIManager = APIManager()
    var deceased:User? {
        didSet {
            //TODO: setup tableHeaderView
        }
    }
    var willItemList:[WillItem]? {
        didSet {
            //TODO: reload TableView
        }
    }

    var tableView: UITableView!

    init(sessionToken:String) {
        super.init(nibName: nil, bundle: nil)
        self.apiManager.readOnlySessionToken = sessionToken
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.getDeceasedInfo { deceased, error in

            guard deceased != nil && error == nil else {
                Alert.showError(error ?? InternalError.loginFail)
                return
            }

            self.deceased = deceased
        }

        self.fetchWillItemList { [unowned self] willItemList, error in
            guard error == nil else {
                Alert.showError(error!)
                return
            }

            self.willItemList = willItemList
        }
    }

    private func setupView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let tableHeaderView = ReadOnlyDeceasedProfileHeaderView(frame:.zero)
        tableView.tableHeaderView = tableHeaderView

        tableView.register(ReadOnlyQuestionCell.self, forCellReuseIdentifier: ReadOnlyQuestionCell.identifier())
        tableView.register(ReadOnlyAnswerCell.self, forCellReuseIdentifier: ReadOnlyAnswerCell.identifier())
    }

    private func fetchWillItemList(completion:@escaping (([WillItem]?, Error?) -> Void)) {
        self.apiManager.getWillItemList { response, error in

            guard let willItemRawList = response?["results"] as? Array<Any> else {
                completion(nil, InternalError.unknown)
                return
            }

            //WARN: !!! 내 유언이 아니기 때문에 Datastore에 save하지 말아야 한다 !!!!
            var willItemList: [WillItem] = []

            for willItemRaw in willItemRawList {
                let willItem = WillItem(value: willItemRaw)
                willItemList.append(willItem)
            }

            completion(willItemList, nil)
        }
    }


    private func getDeceasedInfo(completion: @escaping (User?, Error?) -> Void) {
        self.apiManager.getUserInfo {[unowned self] loginUser, error in

            guard loginUser != nil else {
                completion(nil, error)
                return
            }

            //WARN: !!! 내 유언이 아니기 때문에 Datastore에 save하지 말아야 한다 !!!!
            completion(User(value: loginUser!), nil)
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.willItemList?.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let willItem = self.willItemList?[section] else { return 0 }
        return willItem.answers.count + 1 // +1 == question
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyQuestionCell.identifier(), for: indexPath) as? ReadOnlyQuestionCell else { fatalError() }

            //TODO: setup Question Cell

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyAnswerCell.identifier(), for: indexPath) as? ReadOnlyAnswerCell else { fatalError() }

        //TODO: setup Answer Cell

        return cell
    }


}
