//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import ChameleonFramework

class TextAnswerCell: UITableViewCell {

    weak var textAnswerLabel: UILabel!
    weak var dateLabel: UILabel!

    weak var answer: Answer? {
        didSet {
            guard let newAnswer = self.answer else {
                return
            }

            if newAnswer.answerText != nil {
                textAnswerLabel.text = newAnswer.answerText
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupView() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.drGR00

        let answerLabel = UILabel(frame: .zero)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.textAlignment = .left
        answerLabel.font = UIFont.drSDULight16Font()
        answerLabel.textColor = UIColor.drBK
        answerLabel.numberOfLines = 0
        self.contentView.addSubview(answerLabel)
        self.textAnswerLabel = answerLabel
        self.textAnswerLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(30)
            maker.trailing.equalTo(30)
            maker.top.equalTo(23)
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
            maker.left.equalTo(answerLabel.snp.left)
            maker.right.equalTo(answerLabel.snp.right)
            maker.top.equalTo(answerLabel.snp.bottom).offset(9)
        }
    }
}
