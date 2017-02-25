//
// Created by kyungtaek on 2017. 2. 26..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class ReceiverListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var tableView: UITableView!

    var receiverList:[Receiver]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.receiverList = DataSource.instance.fetchAllReceivers()
    }

    private func setupView() {

        self.navigationItem.title = "나의 dear 지정"

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.tableView = tableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let headerLabel = UILabel(frame:CGRect(origin: CGPoint(), size: CGSize(width: UIScreen.main.bounds.width, height: 80)))
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.drGR06
        headerLabel.font = UIFont.drSDLight13Font()
        headerLabel.contentMode = .center
        headerLabel.baselineAdjustment = .alignCenters
        headerLabel.numberOfLines = 0
        headerLabel.text = "나의 dear를 지정하면 당신에게 예상하지 못한일이 생겼을 때\n메세지를 볼 수 있는 초대장을 보내드립니다"

        self.tableView.tableHeaderView = headerLabel
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.receiverList != nil {
                return self.receiverList!.count
            } else {
                return 0
            }
        } else {
            return 1
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none

        if indexPath.section == 0 {

            guard let receiver = self.receiverList?[indexPath.row] else {
                return cell
            }

            cell.textLabel?.text = receiver.name
            cell.detailTextLabel?.text = receiver.phoneNumber
            cell.detailTextLabel?.textColor = UIColor.drGR06

            return cell

        } else {

            cell.textLabel?.text = "받는 이 추가하기"
            cell.textLabel?.textColor = UIColor.drOR
            return cell

        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        } else {
            return 43
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            self.launchReceiverEditViewController()
        }
    }


    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }


    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        if indexPath.section != 0 {
            return nil
        }

        guard let currentReceiverID = self.receiverList?[indexPath.row].receiverID else {
            return nil
        }

        var deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { action, path in
            DataSource.instance.removeReceiver(receiverID: currentReceiverID)
            self.receiverList = DataSource.instance.fetchAllReceivers()
            self.tableView.reloadData()
        }

        return [deleteAction]
    }

    public func launchReceiverEditViewController() {
        let viewController = ReceiverEditViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}
