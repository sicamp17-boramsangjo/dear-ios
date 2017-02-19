//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class WillItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var tableView: UITableView!
    weak var textInputView: InputView!
    var inputViewHeight: Constraint? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        let textInputView = InputView(frame: .zero)
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textInputView)
        self.textInputView = textInputView
        self.textInputView.snp.makeConstraints {[unowned self] maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            self.inputViewHeight = maker.height.equalTo(40).priority(750).constraint
        }

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalTo(textInputView.snp.top)
        }

        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier())
        tableView.register(TextAnswerCell.self, forCellReuseIdentifier: TextAnswerCell.identifier())
    }

    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return 3
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier(), for: indexPath) as? QuestionCell else {
                fatalError()
            }

            cell.question = "살아오는 동안 생각나는 가장 기뻣던 부모님과의 추억은 무엇인가요?"
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextAnswerCell.identifier(), for: indexPath) as? TextAnswerCell else {
            fatalError()
        }

        var sampleAnswer = Answer(value: [
                "textContent": "4학년때 아버지가 갖고싶어하던 컴퓨터를 사주셨을때.. 그때는 몰랐지만 그로인해 더 넓은 세상을 보게 되었고 지금은 개발자가 되어있네",
                "lastUpdate":Date().timeIntervalSince1970
        ])
        cell.answer = sampleAnswer

        return cell
    }

}
