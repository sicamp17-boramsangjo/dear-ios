//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import ChameleonFramework

class PhotoAnswerCell: UITableViewCell {

    weak var imageAnswerView: UIImageView!

    weak var answer: Answer? {
        didSet {
            guard let newAnwser = self.answer else {
                return
            }

            if newAnwser.imageContent != nil {
                self.imageAnswerView.sd_setImage(with: URL(string:newAnwser.imageContent!))
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
        self.contentView.backgroundColor = UIColor.flatWhite()

        let imageView = UIImageView(frame:.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        self.imageAnswerView = imageView
        self.imageAnswerView.snp.makeConstraints { maker in
            maker.leading.equalTo(16)
            maker.top.equalTo(4)
            maker.bottom.equalTo(4)
            maker.size.equalTo(CGSize(width: 80, height: 80))
        }

    }

}
