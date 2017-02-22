//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import DateToolsSwift

class TimelineAnswerCell: UITableViewCell {

    weak var dateLabel: UILabel!
    weak var textAnswerView: UILabel!
    weak var photoAnswerView: UIImageView!

    var answer: Answer? {
        didSet {
            guard self.answer != nil else {
                return
            }

            self.photoAnswerView.isHidden = true
            self.textAnswerView.isHidden = true

            if let imageUrl = answer?.answerPhoto {
                self.photoAnswerView.sd_setImage(with: URL(string: imageUrl))
                self.photoAnswerView.isHidden = false
            }
            if let textAnswer = answer?.answerText {
                self.textAnswerView.text = textAnswer
                self.textAnswerView.isHidden = false
            }
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

        let dateLabel = UILabel(frame:.zero)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel

        dateLabel.snp.makeConstraints { maker in
            maker.leadingMargin.equalToSuperview().offset(8)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
        }

        let textAnswerView = UILabel(frame:.zero)
        let photoAnswerView = UIImageView(image:nil)

        let contentContainerView = UIStackView(arrangedSubviews: [textAnswerView, photoAnswerView])
        contentContainerView.axis = .vertical
        contentContainerView.alignment = .leading
        contentContainerView.spacing = 0

        self.contentView.addSubview(contentContainerView)
        self.textAnswerView = textAnswerView
        self.photoAnswerView = photoAnswerView

        contentContainerView.snp.makeConstraints { maker in
            maker.left.equalTo(dateLabel.snp.right).offset(8)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(4)
            maker.right.equalToSuperview().offset(-8)
        }

    }
}
