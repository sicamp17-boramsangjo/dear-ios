//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let apiManager: APIManager = APIManager()
    private var willItemList: Results<WillItem>?
    weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.fetchWillItemList { [unowned self] results in
            self.willItemList = results
            self.tableView.reloadData()
        }
    }

    private func setupView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.tableView.register(TimelineQuestionCell.self, forCellReuseIdentifier: TimelineQuestionCell.identifier())
        self.tableView.register((TimelineAnswerCell.self), forCellReuseIdentifier: TimelineAnswerCell.identifier())
    }

    private func fetchWillItemList(completion:@escaping ((Results<WillItem>?) -> Void)) {
        self.apiManager.getWillItemList { response, error in

            guard let willItemList = response?["results"] as? Array<Any> else {
                return
            }

            DataSource.instance.storeWillItemList(willItemRawList: willItemList)
            completion(DataSource.instance.fetchAllWillItemList())
        }
    }

    private func launchWillItemDetailViewController(willItem: WillItem) {

        let willItemViewController = WillItemViewController(willItemID: willItem.willItemID)
        let navigationController = UINavigationController(rootViewController: willItemViewController)
        self.present(navigationController, animated: true)

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let willItemList = self.willItemList else {
            return 0
        }
        return willItemList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let willItem = self.willItemList?[section] else {
            return 0
        }

        return willItem.answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let willItem = self.willItemList?[indexPath.section] else {
            fatalError()
        }

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineQuestionCell.identifier(), for: indexPath) as? TimelineQuestionCell else {
                fatalError()
            }

            cell.willItem = willItem
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineAnswerCell.identifier(), for: indexPath) as? TimelineAnswerCell else {
                fatalError()
            }

            cell.answer = willItem.answers[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let willItem = self.willItemList?[indexPath.section] else {
            return
        }

        self.launchWillItemDetailViewController(willItem: willItem)
    }





}
