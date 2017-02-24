//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import ChameleonFramework
import AVFoundation

class PhotoAnswerCell: UITableViewCell {

    weak var imageAnswerView: UIImageView!
    weak var videoButton: UIButton!

    weak var answer: Answer? {
        didSet {
            guard let newAnswer = self.answer else {
                return
            }

            if newAnswer.answerPhoto != nil {
                self.imageAnswerView.sd_setImage(with: URL(string: newAnswer.answerPhoto!))
            }

            self.videoButton.isHidden = newAnswer.answerVideo == nil
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.flatWhite

        let imageView = UIImageView(frame:.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageView)
        self.imageAnswerView = imageView
        self.imageAnswerView.snp.makeConstraints { maker in
            maker.leading.equalTo(16)
            maker.top.equalTo(4)
            maker.bottom.equalTo(4)
            maker.size.equalTo(CGSize(width:240,height:240))
        }

        let videoButton = UIButton(type:.custom)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.backgroundColor = UIColor.red
        videoButton.isUserInteractionEnabled = false
        self.contentView.addSubview(videoButton)
        self.videoButton = videoButton
        videoButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.center.equalTo(imageView.snp.center)
        }
    }

}
