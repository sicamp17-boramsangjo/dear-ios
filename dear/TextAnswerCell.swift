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

    weak var answer: Answer? {
        didSet {
            guard let newAnwser = self.answer else {
                return
            }

            if newAnwser.answerText != nil {
                textAnswerLabel.text = newAnwser.answerText
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
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.flatWhite
        let answerLabel = UILabel(frame: .zero)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.textAlignment = .left
        answerLabel.font = UIFont.systemFont(ofSize: 14)
        answerLabel.textColor = UIColor.black
        answerLabel.numberOfLines = 0
        self.contentView.addSubview(answerLabel)
        self.textAnswerLabel = answerLabel
        self.textAnswerLabel.snp.makeConstraints { maker in
            maker.edges.equalTo(UIEdgeInsetsMake(4, 16, 4, 8))
        }
    }

}
