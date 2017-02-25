//
// Created by kyungtaek on 2017. 2. 26..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class ReceiverEditCell: UITableViewCell {
    weak var label: UILabel!
    weak var textField: UITextField!

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let label = UILabel(frame:.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        self.label = label

        self.label.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leadingMargin.equalTo(15)
            maker.width.equalTo(70)
        }

        let textField = UITextField(frame:.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textField)
        self.textField = textField

        self.textField.snp.makeConstraints { maker in
            maker.left.equalTo(label.snp.right).offset(28)
            maker.right.equalToSuperview().offset(-16)
            maker.centerY.equalToSuperview()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


class ReceiverEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var tableView: UITableView!
    let apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "받는 이 추가하기"

        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped(_:)))
        rightButton.tintColor = UIColor.drOR
        self.navigationItem.rightBarButtonItem = rightButton

        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.tableView = tableView
        self.tableView.register(ReceiverEditCell.self, forCellReuseIdentifier: "Cell")
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ReceiverEditCell else {
            fatalError()
        }

        if indexPath.row == 0 {
            cell.label.text = "받는 이"
            cell.textField.placeholder = "dear를 받으실 분의 이름"
        } else {
            cell.label.text = "휴대폰 번호"
            cell.textField.placeholder = "010-0000-0000"
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }


    @objc private func saveButtonTapped(_ button: UIBarButtonItem) {

        guard let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReceiverEditCell,
              let secondCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ReceiverEditCell else {
            return
        }

        guard let name = firstCell.textField.text,
              let phoneNumber = secondCell.textField.text else {
            return
        }

        SVProgressHUD.show()
        self.apiManager.addReceiver(name: name, phoneNumber: phoneNumber) { dictionary, error in
            DataSource.instance.updateUserInfo { user in
                self.dismiss(animated: true)
                SVProgressHUD.dismiss()
            }
        }
    }

}
