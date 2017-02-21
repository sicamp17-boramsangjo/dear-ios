//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class WillItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var tableView: UITableView!
    weak var textInputView: InputView!
    weak var inputViewBottomMargin: NSLayoutConstraint!

    deinit {
        self.unregisterNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.registerNotifications()
    }

    private func setupView() {
        let textInputView = InputView(frame: .zero)
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textInputView)
        self.textInputView = textInputView
        self.textInputView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
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
        }

        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.identifier())
        tableView.register(TextAnswerCell.self, forCellReuseIdentifier: TextAnswerCell.identifier())

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView][textInputView]", metrics: nil, views: ["tableView": tableView, "textInputView": textInputView]))
        let inputViewBottomMargin = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: textInputView, attribute: .bottom, multiplier: 1.0, constant: 0)
        inputViewBottomMargin.identifier = "bottomMargin for keyboard"
        self.view.addConstraint(inputViewBottomMargin)
        self.inputViewBottomMargin = inputViewBottomMargin
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func willShowKeyboard(_ notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
              let animationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: animationCurve.uintValue), animations: {
            self.inputViewBottomMargin.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func willHideKeyboard(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
              let animationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: animationCurve.uintValue), animations: {
            self.inputViewBottomMargin.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
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
                "lastUpdate": Date().timeIntervalSince1970
        ])
        cell.answer = sampleAnswer

        return cell
    }

}
