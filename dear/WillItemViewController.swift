//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import NYTPhotoViewer
import SDWebImage
import SVProgressHUD

class WillItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NYTPhotosViewControllerDelegate {

    weak var closeButton: UIButton!
    weak var questionView: QuestionView!
    weak var tableView: UITableView!
    weak var textInputView: InputView!
    weak var inputViewBottomMargin: NSLayoutConstraint!
    weak var receiverSelectionView: ReceiverSelectionView!

    var apiManager: APIManager = APIManager()

    var willItemID: String?
    var willItem: WillItem? {
        didSet {

            defer {
                self.tableView.reloadData()
            }

            guard let question = self.willItem?.text, let questionID = self.willItem?.questionID else {
                return
            }

            self.questionView.question = question
            self.textInputView.questionID = questionID
        }
    }
    var question:[String: Any]? {
        didSet {
            if self.question != nil {
                self.questionView.question = self.question?["text"] as? String
                self.questionView.deliveredAt = self.question?["deliveredAt"] as? Double
                self.textInputView.questionID = self.question?["questionID"] as? String
            }
        }
    }
    var showCloseButton:Bool = false

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

            SVProgressHUD.show()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                defer {
                    SVProgressHUD.dismiss()
                }

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
    }

    private func fetchWillItem(willItemID: String, completion:@escaping ((WillItem?, Error?) -> Void)) {

        self.apiManager.getWillItem(willItemId: willItemID) { dictionary, error in

            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let willItemID = dictionary?["willitemID"] as? String, let willItemRawInfo = dictionary else {
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

            if willItemRaw != nil, let willItemID = willItemRaw?["willitemID"] as? String {
                DataSource.instance.storeWIllItem(willItemRawInfo: willItemRaw!)
                let willItem = DataSource.instance.fetchWillItem(willItemId: willItemID)
                completion(questionRaw, willItem, nil)
            } else {
                completion(questionRaw, nil, nil)
            }
        }
    }


    private func setupView() {

        self.view.backgroundColor =  UIColor.white

        let textInputView = InputView(frame: .zero)
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        textInputView.reloadWillItem = { (willItemID:String) in
            self.fetchWillItem(willItemID: willItemID) {[unowned self] item, error in
                guard error == nil else {
                    Alert.showError(error!)
                    return
                }
                self.willItem = item
            }
        }

        textInputView.showReceiverList = { isShow in
            self.receiverSelectionView.isHidden = !isShow
        }

        self.view.addSubview(textInputView)
        self.textInputView = textInputView
        self.textInputView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        tableView.backgroundColor = UIColor.drGR00
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        let questionView = QuestionView(frame: .zero)
        questionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionView)
        self.questionView = questionView
        questionView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        tableView.register(TextAnswerCell.self, forCellReuseIdentifier: TextAnswerCell.identifier())
        tableView.register(PhotoAnswerCell.self, forCellReuseIdentifier: PhotoAnswerCell.identifier())

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(space)-[questionView][tableView][textInputView]",
                metrics: ["space": (self.showCloseButton == true ? 60 : 0)],
                views: ["questionView":questionView, "tableView": tableView, "textInputView": textInputView]))
        let inputViewBottomMargin = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: textInputView, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(inputViewBottomMargin)
        self.inputViewBottomMargin = inputViewBottomMargin

        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        self.closeButton = closeButton
        self.closeButton.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(3)
            maker.topMargin.equalTo(30)
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }
        self.closeButton.isHidden = !self.showCloseButton

        let receiverSelectionView = ReceiverSelectionView(config: .forRecommand) {[unowned self] receiver in
            if receiver != nil {
                self.textInputView.textView.text = "\(self.textInputView.textView.text) \(receiver!.name)"
            }
                self.receiverSelectionView.isHidden = true
         }
        receiverSelectionView.receivers = DataSource.instance.fetchAllReceivers()
        receiverSelectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(receiverSelectionView)
        self.receiverSelectionView = receiverSelectionView
        receiverSelectionView.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(57)
            maker.bottom.equalTo(textInputView.snp.top)
        }
        receiverSelectionView.isHidden = true
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

    @objc private func closeButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true)
    }

    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let willItem = self.willItem else {
            return 0
        }

        return willItem.answers.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let answer = self.willItem?.answers[indexPath.row] else { fatalError() }

        if answer.answerPhoto != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoAnswerCell.identifier(), for: indexPath) as? PhotoAnswerCell else { fatalError() }
            cell.answer = answer
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextAnswerCell.identifier(), for: indexPath) as? TextAnswerCell else { fatalError() }
            cell.answer = answer
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        defer {
            tableView.deselectRow(at: indexPath, animated: true)

            if self.questionView.status == .open {
                self.questionView.status = .close
            }

            if self.textInputView.textView.isFirstResponder {
                self.textInputView.textView.resignFirstResponder()
            }
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? PhotoAnswerCell else {
            return
        }

        guard let answer = self.willItem?.answers[indexPath.row], let question = self.question?["text"] as? String, let imagePath = answer.answerPhoto else {
            return
        }

        if answer.answerVideo != nil {
            let videoViewer = VideoViewer(videoPath: answer.answerVideo!)
            self.present(videoViewer, animated: true)
        } else {
            let lastUpdate = Date(timeIntervalSince1970: answer.modifiedAt).timeAgoSinceDate()
            let photo = PhotoModel(image:cell.imageAnswerView.image, summary:question, credit: lastUpdate)
            let photosViewController = NYTPhotosViewController(photos: [photo])

            self.present(photosViewController, animated: true)

            if photo.image == nil {
                SDWebImageDownloader(sessionConfiguration: nil).downloadImage(with: URL(string: imagePath), options: .highPriority, progress: nil) { (image, _, error, _) in
                    photo.image = image
                    photosViewController.updateImage(for: photo)
                }
            }
        }
    }

}
