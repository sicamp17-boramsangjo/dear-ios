//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class QuestionCell: UITableViewCell {

    weak var questionLabel: UILabel!
    var question: String? {
        didSet {
            self.questionLabel.text = self.question
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
        self.contentView.backgroundColor = UIColor.white
        let questionLabel = UILabel(frame: .zero)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(questionLabel)
        self.questionLabel = questionLabel
        self.questionLabel.snp.makeConstraints { maker in
            maker.height.greaterThanOrEqualTo(160)
            maker.edges.equalTo(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        self.questionLabel.lineBreakMode = .byWordWrapping
        self.questionLabel.textAlignment = .center
        self.questionLabel.font = UIFont.systemFont(ofSize: 20)
        self.questionLabel.textColor = UIColor.black
        self.questionLabel.numberOfLines = 0
    }
}
