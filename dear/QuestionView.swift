//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit


enum QuestionViewStatus {
    case close
    case open

    func questionStringAttribute(text:String) -> NSAttributedString? {

        var lineSpacing:CGFloat = 1.0
        var font:UIFont? = UIFont.drNM23Font()
        var color:UIColor? = UIColor.drBK

        if self == .close {
            lineSpacing = 7
            font = UIFont.drNM13Font()
        } else {
            lineSpacing = 10
            font = UIFont.drNM23Font()
        }

        return text.attrString(font: font, color: color, lineSpacing: lineSpacing, alignment: .center)
    }

    func topMargin() -> Int {
        switch self {
        case .close:
            return 4
        case .open:
            return 40
        }
    }

    func isHiddenRemainTime() -> Bool {
        switch self {
        case .close:
            return true
        case .open:
            return false
        }
    }
}

class QuestionView: UIView {

    weak var questionLabel: UILabel!
    weak var remainTimeLabel: UILabel!
    weak var toggleButton: UIButton!

    weak var topMargin: Constraint?

    var status: QuestionViewStatus = .open {
        didSet {
            if self.question != nil {
                let result = self.status.questionStringAttribute(text: self.question!)
                self.questionLabel.attributedText = result
                self.updateConstraints()
                self.remainTimeLabel.isHidden = self.status.isHiddenRemainTime()
                self.topMargin?.updateOffset(amount: self.status.topMargin())
            }

        }
    }

    var question: String? = "오늘의 질문을 불러오는 중입니다..." {
        didSet {
            if self.question != nil {
                self.questionLabel.attributedText = self.status.questionStringAttribute(text: self.question!)
                self.updateConstraints()
            }
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

        let questionLabel = UILabel(frame: .zero)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textAlignment = .center
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.font = UIFont.drNM23Font()
        questionLabel.textColor = UIColor.drGR01
        questionLabel.numberOfLines = 0

        let remainTimeLabel = UILabel(frame: .zero)
        remainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.lineBreakMode = .byWordWrapping
        remainTimeLabel.font = UIFont.drSDLight14Font()
        remainTimeLabel.textColor = UIColor.drGR01
        remainTimeLabel.numberOfLines = 1

        remainTimeLabel.snp.makeConstraints { maker in
            maker.height.equalTo(14).priority(.high)
        }

        let container = UIStackView(arrangedSubviews: [questionLabel, remainTimeLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.spacing = 20
        self.addSubview(container)

        self.questionLabel = questionLabel
        self.remainTimeLabel = remainTimeLabel

        container.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(UIScreen.main.bounds.width - 80)
            self.topMargin = maker.topMargin.equalTo(40).constraint
            maker.bottomMargin.equalTo(-20).priority(.high)
         }

        let toggleButton = UIButton(type: .custom)
        toggleButton.setTitle("CLOSE", for: .normal)
        toggleButton.setTitle("OPEN", for: .selected)
        toggleButton.titleLabel?.font = UIFont.drSDMedium155Font()
        toggleButton.setTitleColor(UIColor.drBK, for: .normal)
        toggleButton.setTitleColor(UIColor.drBK, for: .selected)
        toggleButton.backgroundColor = UIColor.drGR04
        toggleButton.addTarget(self, action: #selector(toggleCell(_:)), for: .touchUpInside)
        self.addSubview(toggleButton)
        self.toggleButton = toggleButton
        toggleButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 80, height: 30))
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(15)
         }
    }

    @objc private func toggleCell(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if self.status == .open {
            self.status = .close
        } else {
            self.status = .open
        }
    }
}
