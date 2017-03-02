//
// Created by kyungtaek on 2017. 2. 24..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class AnswerDateCell: UITableViewCell {

    weak var dateLabel: UILabel!

    var date:Date? {
        didSet {
            if self.date != nil {
                self.dateLabel.text = self.date!.format(format: "yyyy-MM-dd")
            }
        }
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        self.layer.cornerRadius = 12
        self.clipsToBounds = true

        let dateLabel = UILabel(frame:.zero)
        dateLabel.textColor = UIColor.white
        dateLabel.backgroundColor = UIColor.drGR02
        dateLabel.font = UIFont.drSDRegular13Font()
        dateLabel.textAlignment = .center
        self.contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 114, height: 24))
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
         }
    }
}