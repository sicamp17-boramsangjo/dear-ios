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
        var font:UIFont? = UIFont.drNM20Font()
        var color:UIColor? = UIColor.rgb256(102, 102, 102)

        if self == .close {
            lineSpacing = 7
            font = UIFont.drNM15Font()
        } else {
            lineSpacing = 10
            font = UIFont.drNM20Font()
        }

        return text.attrString(font: font, color: color, lineSpacing: lineSpacing, alignment: .center)
    }

    func topMargin() -> Int {
        switch self {
        case .close:
            return 12
        case .open:
            return 50
        }
    }

    func bottomMargin() -> Int {
        switch self {
        case .close:
            return -50
        case .open:
            return -62
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
    weak var bottomMargin: Constraint?

    var status: QuestionViewStatus = .open {
        didSet {
            if self.question != nil {
                let result = self.status.questionStringAttribute(text: self.question!)
                self.questionLabel.attributedText = result
                self.updateConstraints()
                self.remainTimeLabel.isHidden = self.status.isHiddenRemainTime()
                self.topMargin?.updateOffset(amount: self.status.topMargin())
                self.bottomMargin?.updateOffset(amount: self.status.bottomMargin())
            }

        }
    }

    var question: String? = "..." {
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

        self.applyCommonShadow()

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
        container.spacing = 44
        self.addSubview(container)

        self.questionLabel = questionLabel
        self.remainTimeLabel = remainTimeLabel

        container.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(UIScreen.main.bounds.width - 80)
            self.topMargin = maker.topMargin.equalTo(50).constraint
            self.bottomMargin = maker.bottomMargin.equalTo(-62).priority(.high).constraint
         }

        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(named: "arrowUp"), for: .normal)
        toggleButton.setImage(UIImage(named: "arrowDown"), for: .selected)
        toggleButton.addTarget(self, action: #selector(toggleCell(_:)), for: .touchUpInside)
        self.addSubview(toggleButton)
        self.toggleButton = toggleButton
        toggleButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 40, height: 40))
            maker.centerX.equalToSuperview()
            maker.bottomMargin.equalTo(-8)
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
