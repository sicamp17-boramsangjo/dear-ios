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
    var apiManager: APIManager = APIManager()

    var willItemID: String?
    var willItem: WillItem? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var question:[String: Any]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    init(willItemID: String?) {
        super.init(nibName: nil, bundle: nil)
        self.willItemID = willItemID
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }


    deinit {
        self.unregisterNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.registerNotifications()

        if let willItemID = self.willItemID {
            self.fetchWillItem(willItemID: willItemID) { [unowned self] willItem, error in
                guard error == nil else {
                    Alert.showError(error!)
                    return
                }
                self.willItem = willItem
            }
        } else {
            self.fetchTodaysQuestion { [unowned self] question, willItem, error in
                guard error == nil else {
                    Alert.showError(error!)
                    return
                }

                self.question = question
                if willItem != nil {
                    self.willItem = willItem
                }
            }
        }
    }

    private func fetchWillItem(willItemID: String, completion:@escaping ((WillItem?, Error?) -> Void)) {

        self.apiManager.getWillItem(willItemId: willItemID) { response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let willItemID = response?["willItemID"] as? String, let willItemRawInfo = response else {
                completion(nil, InternalError.unknown)
                return
            }

            DataSource.instance.storeWIllItem(willItemRawInfo: willItemRawInfo)
            let willItem = DataSource.instance.fetchWillItem(willItemId: willItemID)
            completion(willItem, nil)

        }
    }

    private func fetchTodaysQuestion(completion:@escaping ([String:Any]?, WillItem?, Error? ) -> Void) {

        self.apiManager.getTodayQuestion { questionRaw, willItemRaw, error in

            if error != nil {
                completion(nil, nil, error)
                return
            }

            guard let willItemID = willItemRaw?["willItemID"] as? String else {
                completion(nil, nil, InternalError.unknown)
                return
            }

            if willItemRaw != nil {
                DataSource.instance.storeWIllItem(willItemRawInfo: willItemRaw!)
                let willItem = DataSource.instance.fetchWillItem(willItemId: willItemID)
                completion(questionRaw, willItem, nil)
            } else {
                completion(questionRaw, nil, nil)
            }
        }
    }


    private func setupView() {

        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped(_:)))
        }

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

    @objc private func closeButtonTapped(_ button: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {

            guard self.question != nil else {
                return 0
            }

            return 1
        }

        guard let willItem = self.willItem else {
            return 0
        }

        return willItem.answers.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier(), for: indexPath) as? QuestionCell else {
                fatalError()
            }

            if let currentWillItem = self.willItem {
                cell.question = currentWillItem.question
            } else {
                cell.question = self.question?["text"] as? String
                cell.deliveredAt = Date(timeIntervalSince1970: self.question?["deliveredAt"] as! TimeInterval)
            }
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextAnswerCell.identifier(), for: indexPath) as? TextAnswerCell else {
            fatalError()
        }

        cell.answer = self.willItem?.answers[indexPath.row]

        return cell
    }

}
