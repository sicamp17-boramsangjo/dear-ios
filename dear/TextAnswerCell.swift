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
                textAnswerLabel.attributedText = newAnswer.answerText!.attrString(font: UIFont.drSDULight14Font(), color: UIColor.drGR05, lineSpacing: 1.16, alignment: .center)
                self.dateLabel.text = Date(timeIntervalSince1970: newAnswer.modifiedAt).timeAgoSinceDate(numericDates: true)
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
        answerLabel.numberOfLines = 0
        self.contentView.addSubview(answerLabel)
        self.textAnswerLabel = answerLabel
        self.textAnswerLabel.snp.makeConstraints { maker in
            maker.topMargin.equalTo(35)
            maker.leadingMargin.equalTo(55)
            maker.trailingMargin.equalTo(-55)
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
            maker.left.equalTo(answerLabel.snp.left)
            maker.right.equalTo(answerLabel.snp.right)
            maker.top.equalTo(answerLabel.snp.bottom).offset(6)
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
}
