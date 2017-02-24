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
    weak var dateLabel: UILabel!

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
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(30)
            maker.top.equalToSuperview()
            maker.size.equalTo(CGSize(width:(UIScreen.main.bounds.width - 60),height:(UIScreen.main.bounds.width - 60) * 0.6))
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

        let dateLabel = UILabel(frame: .zero)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.drNMB13Font()
        dateLabel.textColor = UIColor.drGR01
        dateLabel.numberOfLines = 0
        self.contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.snp.makeConstraints { maker in
            maker.left.equalTo(imageView.snp.left)
            maker.right.equalTo(imageView.snp.right)
            maker.top.equalTo(imageView.snp.bottom).offset(9)
        }
    }

}
