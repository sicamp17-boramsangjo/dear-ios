//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class TimelineQuestionCell: UITableViewCell {

    weak var questionLabel: UILabel!
    var willItem: WillItem? {
        didSet {
            self.questionLabel.text = willItem?.question
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

        let questionLabel = UILabel(frame:.zero)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        self.contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.questionLabel = questionLabel
    }
}
