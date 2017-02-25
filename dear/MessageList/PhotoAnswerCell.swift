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

                self.imageAnswerView.snp.updateConstraints { maker in

                    let maxHeight = self.maxMediaLength()
                    let newHeight =  (maxHeight / CGFloat(newAnswer.mediaWidth)) * CGFloat(newAnswer.mediaHeight)

                    maker.size.equalTo(CGSize(width:maxHeight, height: (newHeight < maxHeight) ? newHeight : maxHeight))
                 }
            }

            self.dateLabel.text = Date(timeIntervalSince1970: newAnswer.modifiedAt).timeAgoSinceDate(numericDates: true)

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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        self.contentView.addSubview(imageView)
        self.imageAnswerView = imageView
        self.imageAnswerView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.topMargin.equalTo(39)
            maker.size.equalTo(CGSize(width:self.maxMediaLength() ,height:self.maxMediaLength()))
        }

        let videoButton = UIButton(type:.custom)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.contentMode = .center
        videoButton.setImage(UIImage(named: "playButton"), for: .normal)
        videoButton.backgroundColor = UIColor(white: 0, alpha: 0.6)
        videoButton.isUserInteractionEnabled = false
        self.contentView.addSubview(videoButton)
        self.videoButton = videoButton
        videoButton.snp.makeConstraints { maker in
            maker.edges.equalTo(imageView.snp.edges)
        }

        let dateLabel = UILabel(frame: .zero)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.drSDRegular12Font()
        dateLabel.textColor = UIColor.drGR01
        dateLabel.numberOfLines = 1
        self.contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.snp.makeConstraints { maker in
            maker.left.equalTo(imageView.snp.left)
            maker.right.equalTo(imageView.snp.right)
            maker.top.equalTo(imageView.snp.bottom).offset(6)
            maker.bottomMargin.equalTo(-25)
        }
        let splitView = UIView(frame: .zero)
        splitView.backgroundColor = UIColor.rgb256(229, 229, 229)
        splitView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(splitView)
        splitView.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(45)
            maker.trailingMargin.equalTo(0)
            maker.bottomMargin.equalTo(0)
            maker.height.equalTo(1)
        }
    }

    private func maxMediaLength() -> CGFloat {
        return (UIScreen.main.bounds.width - 110)
    }

}
