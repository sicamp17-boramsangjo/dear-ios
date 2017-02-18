//
//  MessageCell.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import ChameleonFramework

enum MessageCellType {
    case question(Bool)
    case anwser
}

enum MessageContent {
    case Text(String)
    case Image(URL, CGSize)
    case Video(URL, URL, CGSize)
}

protocol MessageCellStyle {

    var cellType: MessageCellType { get }
    func transform() -> CGAffineTransform
    func backgroundColor() -> UIColor
    func fontColor() -> UIColor
}

extension MessageCellStyle {
    func transform() -> CGAffineTransform {
        switch self.cellType {
        case .question:
            return CGAffineTransform(scaleX: -1, y: 1)
        case .anwser:
            return CGAffineTransform.identity
        }
    }

    func backgroundColor() -> UIColor {
        switch self.cellType {
        case .question:
            return UIColor.flatMint()
        case .anwser:
            return UIColor.flatWhite()
        }
    }

    func fontColor() -> UIColor {
        return UIColor.flatBlack()
    }
}

struct MessageViewModel: MessageCellStyle {

    var cellType: MessageCellType
    let content: MessageContent
    let updateTime: Date
}

class MessageCell: UITableViewCell {

    weak var bubble: UIView!
    weak var timeLabel: UILabel!
    weak var contentContainer: UIStackView!
    weak var textContent: UILabel!
    weak var photoContent: UIImageView!
    weak var videoPlayButton: UIImageView!

    var viewModel: MessageViewModel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        let bubble = UIView(frame: .zero)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.layer.cornerRadius = 10
        bubble.clipsToBounds = true
        bubble.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        self.contentView.addSubview(bubble)
        self.bubble = bubble

        let timeLabel = UILabel(frame:.zero)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        self.contentView.addSubview(timeLabel)
        self.timeLabel = timeLabel

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=8)-[timeLabel]-(2)-[bubble]-(8)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["bubble": self.bubble, "timeLabel": self.timeLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[bubble]-(4)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["bubble": self.bubble]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[timeLabel]-(4)-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["timeLabel": self.timeLabel]))

        let textContent = UILabel(frame: .zero)
        textContent.translatesAutoresizingMaskIntoConstraints = false
        textContent.font = UIFont.systemFont(ofSize: 12)
        textContent.numberOfLines = 0
        textContent.lineBreakMode = .byWordWrapping

        let photoView = UIImageView(image:nil)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit

        let videoPlayButton = UIImageView(image:nil)
        videoPlayButton.translatesAutoresizingMaskIntoConstraints = false
        photoView.addSubview(videoPlayButton)
        videoPlayButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.center.equalTo(photoView.center)
        }
        videoPlayButton.isHidden = true
        self.videoPlayButton = videoPlayButton

        let contentContainer = UIStackView(arrangedSubviews: [textContent, photoView])
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        self.photoContent = photoView
        self.textContent = textContent

        contentContainer.axis = .vertical
        contentContainer.alignment = .fill
        contentContainer.spacing = 4

        self.bubble.addSubview(contentContainer)
        self.contentContainer = contentContainer
        contentContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }

    func setupCell(viewModel: MessageViewModel?) {
        self.viewModel = viewModel

        guard let newViewModel = self.viewModel else { return }

        self.timeLabel.text = newViewModel.updateTime.timeAgoSinceDate(numericDates: false)

        switch newViewModel.content {
        case .Text(let textContent):
            self.textContent.text = textContent
            self.photoContent.isHidden = true
        case .Image(let photoURL, _):
            self.photoContent.sd_setImage(with: photoURL)
            self.textContent.isHidden = true
            self.photoContent.isHidden = false
            self.videoPlayButton.isHidden = true
        case .Video(_, let photoURL, _):
            self.photoContent.sd_setImage(with: photoURL)
            self.textContent.isHidden = true
            self.photoContent.isHidden = false
            self.videoPlayButton.isHidden = false
        }

        self.bubble.backgroundColor = newViewModel.backgroundColor()
        self.contentView.transform = newViewModel.transform()
        self.contentContainer.transform = newViewModel.transform()
        self.timeLabel.transform = newViewModel.transform()
        self.textContent.textColor = newViewModel.fontColor()
    }

}
