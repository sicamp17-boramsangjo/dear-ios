//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let apiManager: APIManager = APIManager()
    private var willItemList: [WillItem]? {
        didSet {
            if willItemList != nil && self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    private var filteredReceiver: Receiver? {
        didSet {
            self.filteringReceiverCancelButton.isHidden = self.filteredReceiver == nil
        }
    }
    weak var receiverSelectionView: ReceiverSelectionView!
    weak var filteringReceiverCancelButton: UIButton!

    weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.fetchWillItemList { [unowned self] results in
            self.willItemList = results
        }
    }

    private func setupView() {

        self.view.backgroundColor = UIColor.drGR00

        let receiverSelectionView = ReceiverSelectionView(config: .forFilter) {[unowned self] selectedReceiver in
            self.filteredReceiver = selectedReceiver

            if selectedReceiver != nil {
                self.receiverSelectionView.receivers = DataSource.instance.searchReceiver(receiverID: selectedReceiver!.receiverID)
                self.willItemList = DataSource.instance.searchWIllItem(includeReceiverID: selectedReceiver!.receiverID)
            } else {
                self.receiverSelectionView.receivers = DataSource.instance.fetchAllReceivers()
                self.willItemList = DataSource.instance.fetchAllWillItemList()
            }
        }

        receiverSelectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(receiverSelectionView)
        receiverSelectionView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(60)
        }
        self.receiverSelectionView = receiverSelectionView
        self.receiverSelectionView.receivers = DataSource.instance.fetchAllReceivers()

        let filteringReceiverCancelButton = UIButton(type: .roundedRect)
        filteringReceiverCancelButton.setImage(UIImage(named: "icoClose01"), for: .normal)
        filteringReceiverCancelButton.addTarget(self, action: #selector(resetFilteringReceiverButtonTapped(_:)), for: .touchUpInside)
        filteringReceiverCancelButton.translatesAutoresizingMaskIntoConstraints = false
        filteringReceiverCancelButton.isHidden = true
        self.view.addSubview(filteringReceiverCancelButton)
        self.filteringReceiverCancelButton = filteringReceiverCancelButton
        self.filteringReceiverCancelButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.centerY.equalTo(receiverSelectionView.snp.centerY)
            maker.right.equalTo(receiverSelectionView.snp.right).offset(-20)
        }

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.drGR00
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.equalTo(receiverSelectionView.snp.bottom)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        self.tableView.register((TimelineWillItemCell.self), forCellReuseIdentifier: TimelineWillItemCell.identifier())
    }

    private func fetchWillItemList(completion:@escaping ([WillItem]) -> Void) {
        self.apiManager.getWillItemList { response, error in

            guard let willItemList = response?["willitems"] as? Array<Any> else {
                return
            }

            DataSource.instance.storeWillItemList(willItemRawList: willItemList)
            completion(DataSource.instance.fetchAllWillItemList())
        }
    }

    private func launchWillItemDetailViewController(willItem: WillItem) {

        let willItemViewController = WillItemViewController(willItemID: willItem.willitemID)
        willItemViewController.showCloseButton = true
        self.present(willItemViewController, animated: true)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.willItemList == nil {
            return 0
        }

        return self.willItemList!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineWillItemCell.identifier(), for: indexPath) as? TimelineWillItemCell else {
            fatalError()
        }

        cell.willItem = self.willItemList?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        defer {
            tableView.deselectRow(at: indexPath, animated: false)
        }

        guard let willItem = self.willItemList?[indexPath.row] else {
            return
        }

        self.launchWillItemDetailViewController(willItem: willItem)
    }

    @objc private func resetFilteringReceiverButtonTapped(_ button:UIButton) {
        self.receiverSelectionView.receivers = DataSource.instance.fetchAllReceivers()
        self.willItemList = DataSource.instance.fetchAllWillItemList()
    }
}
