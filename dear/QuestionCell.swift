//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class QuestionView: UIView {

    weak var questionLabel: UILabel!
    weak var remainTimeLabel: UILabel!
    weak var toggleButton: UIButton!

    var question: String? {
        didSet {
            self.questionLabel.text = self.question
        }
    }

    var deliveredAt: Double? {
        didSet {
            //TODO: 남은 시간 계산하기
            self.remainTimeLabel.text = "3시간 남았어요."
        }
    }

    public override init(frame:CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        self.backgroundColor = UIColor.white

        let remainTimeLabel = UILabel(frame: .zero)
        remainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.lineBreakMode = .byWordWrapping
        remainTimeLabel.font = UIFont.drSDLight14Font()
        remainTimeLabel.textColor = UIColor.drGR01
        remainTimeLabel.numberOfLines = 1
        self.addSubview(remainTimeLabel)
        self.remainTimeLabel = remainTimeLabel
        self.remainTimeLabel.snp.makeConstraints { maker in
            maker.topMargin.equalToSuperview().offset(60)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(14)
        }

        let questionLabel = UILabel(frame: .zero)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textAlignment = .center
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.font = UIFont.drNM23Font()
        questionLabel.textColor = UIColor.drGR01
        questionLabel.numberOfLines = 0
        self.addSubview(questionLabel)
        self.questionLabel = questionLabel
        self.questionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(remainTimeLabel.snp.bottom).offset(26)
            maker.leading.equalToSuperview().offset(46)
            maker.trailing.equalToSuperview().offset(-46)
            maker.bottom.equalToSuperview().offset(-80)
        }

        let toggleButton = UIButton(type: .custom)
        toggleButton.setTitle("OPEN", for: .normal)
        toggleButton.setTitle("CLOSE", for: .selected)
        toggleButton.titleLabel?.font = UIFont.drSDMedium155Font()
        toggleButton.setTitleColor(UIColor.drGR04, for: .normal)
        toggleButton.setTitleColor(UIColor.drGR04, for: .selected)
        toggleButton.addTarget(self, action: #selector(toggleCell(_:)), for: .touchUpInside)
        self.addSubview(toggleButton)
        self.toggleButton = toggleButton
        toggleButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
    }

    @objc private func toggleCell(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
}
