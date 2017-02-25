//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import DKImagePickerController

class InputView: UIView, UITextViewDelegate {

    weak var textView: UITextView!
    weak var placeholderLabel: UILabel!
    weak var sendButton: UIButton!

    weak var attachmentButton: UIButton!
    weak var heightConstraint: Constraint?

    var questionID: String?
    var receivers: [Receiver] = []
    let apiManager = APIManager()
    var reloadWillItem:((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setupView() {

        self.backgroundColor = UIColor.drGR00

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(button)
        self.attachmentButton = button

        button.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(15)
            maker.bottomMargin.equalTo(-17)
            maker.size.equalTo(CGSize(width: 34, height: 34))
        }

        let textView = UITextView(frame: .zero, textContainer: nil)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        textView.applyCommonShadow()
        textView.tintColor = UIColor.drOR
        textView.textContainerInset = UIEdgeInsetsMake(12.5, 19.5, 12.5, 52)
        textView.textColor = UIColor.drGR01
        textView.font = UIFont.drSDLight16Font()
        self.addSubview(textView)
        self.textView = textView

        textView.snp.makeConstraints { [unowned self] maker in
            maker.left.equalTo(button.snp.right).offset(12).priority(750)
            maker.topMargin.equalTo(15)
            maker.bottomMargin.equalTo(-15).priority(750)
            maker.right.equalToSuperview().offset(-16)
            self.heightConstraint = maker.height.equalTo(40).priority(750).constraint
        }

        let placeholderLabel = UILabel(frame:.zero)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.font = UIFont.drSDLight16Font()
        placeholderLabel.textColor = UIColor.drGR08
        placeholderLabel.text = "\(DataSource.instance.numOfAnswers())번째 메시지를 남겨보세요"
        self.textView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leadingMargin.equalTo(11)
         }
        self.placeholderLabel = placeholderLabel

        let sendButton = UIButton(type: .custom)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for:.normal)
        sendButton.setTitleColor(UIColor.drOR, for: .normal)
        sendButton.titleLabel?.font = UIFont.drSDMedium16Font()
        sendButton.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(sendButton)
        sendButton.snp.makeConstraints { maker in
            maker.bottom.equalTo(textView.snp.bottom).offset(-2)
            maker.trailingMargin.equalTo(-25)
         }

        self.sendButton = sendButton
        self.sendButton.isHidden = true
    }


    @objc func addButtonTapped(_ button: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let attachImageAction = UIAlertAction(title: "attach a picture", style: .default) {[unowned self] _ in
            self.launchImagePickerController()
        }
        actionSheet.addAction(attachImageAction)
        let attachVideoAction = UIAlertAction(title: "attach a video", style: .default) {[unowned self] _ in
            self.launchVideoPickerController()
        }
        actionSheet.addAction(attachVideoAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)

        UIWindow.visibleViewController()?.present(actionSheet, animated: true)
    }

    private func launchImagePickerController() {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            guard let selectedAsset = assets.first else {
                return
            }
        }

        DispatchQueue.main.async {
            UIWindow.visibleViewController()?.present(pickerController, animated: true)
        }
    }

    private func launchVideoPickerController() {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.assetType = .allVideos

        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            guard let selectedAsset: DKAsset = assets.first else {
                return
            }

            let savedVideoFilePath = "\(FileManager.uploadCachePath())/\(FileManager.uniqueFileName(fileExtension: "mp4"))"

            selectedAsset.writeAVToFile(savedVideoFilePath, presetName:AVAssetExportPresetLowQuality) { _ in
                UploadManager.instance.createAnswer(questionID: self.questionID!, textAnswer:nil, imageAnswer:nil, videoAnswer: savedVideoFilePath, receivers: self.receivers.map { $0.receiverID }) { [unowned self] (willItemID, error: Error?) in
                    if error != nil {
                        print(error)
                        return
                    }

                    if willItemID != nil {
                        self.reloadWillItem?(willItemID!)
                    }
                }
            }
        }

        DispatchQueue.main.async {
            UIWindow.visibleViewController()?.present(pickerController, animated: true)
        }
    }

    @objc private func sendButtonTapped(_ button:UIButton) {
        guard let textContent = self.textView.text, textContent.characters.count > 0, let questionID = self.questionID else {
            return
        }

        UploadManager.instance.createAnswer(questionID: questionID, textAnswer: textContent, imageAnswer: nil, videoAnswer: nil, receivers: self.receivers.map {$0.receiverID}) { [unowned self] willItemID, error in
            if error != nil {
                Alert.showError(error!)
                return
            }

            self.textView.text.removeAll()
            if willItemID != nil {
                self.reloadWillItem?(willItemID!)
            }
        }
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLabel.isHidden = true
        self.sendButton.isHidden = false
        return true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.placeholderLabel.isHidden = false
            self.sendButton.isHidden = true
        }
    }

    public func textViewDidChange(_ textView: UITextView) {

        guard let font = UIFont.drSDLight14Font() else {
            return
        }

        var height = textView.text.findHeight(havingWidth:textView.bounds.width - 72 , andFont: font).height
        var lineHeight = font.lineHeight
        var numLine = Int(height / lineHeight)

        self.heightConstraint?.updateOffset(amount: min(90, (25 * numLine + 15)))
    }

}
