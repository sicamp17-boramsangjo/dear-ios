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
    weak var attachmentButton: UIButton!
    weak var heightConstraint: Constraint?

    var questionID: String?
    var receivers: [Receiver] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        let textView = UITextView(frame: .zero, textContainer: nil)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)
        self.textView = textView

        let button = UIButton(type: .custom)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(button)
        self.attachmentButton = button

        button.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: 60, height: 40))
        }

        textView.snp.makeConstraints { [unowned self] maker in
            maker.left.equalTo(button.snp.right).offset(4).priority(750)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4).priority(750)
            maker.right.equalToSuperview().offset(-8)
            self.heightConstraint = maker.height.equalTo(30).priority(750).constraint
        }
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
                UploadManager.instance.createAnswer(questionID: self.questionID!, textAnswer:nil, imageAnswer:nil, videoAnswer: savedVideoFilePath, receivers: self.receivers.map { $0.receiverID }) { (_, error: Error?) in
                    if error != nil {
                        print(error)
                    }
                }
            }
        }

        DispatchQueue.main.async {
            UIWindow.visibleViewController()?.present(pickerController, animated: true)
        }
    }

}
