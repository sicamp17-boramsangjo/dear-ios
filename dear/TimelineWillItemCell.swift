//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import DateToolsSwift


class TimelineAnswerCell: UICollectionViewCell {
    weak var dateLabel: UILabel!
    weak var timeLabel: UILabel!
    weak var textAnswer: UILabel!
    weak var photoAnswer: UIImageView!
    weak var videoIcon: UIImageView!

    var answer: Answer? {
        didSet {

            if self.answer == nil {
                return
            }

            textAnswer.isHidden = answer!.answerText == nil
            photoAnswer.isHidden = answer!.answerPhoto == nil
            videoIcon.isHidden = answer!.answerVideo == nil

            dateLabel.text = Date(timeIntervalSince1970: answer!.lastUpdate).timeAgoSinceDate()

            if answer!.answerText != nil {
                textAnswer.text = answer!.answerText
            }

            if answer!.answerPhoto != nil {
                photoAnswer.sd_setImage(with:URL(string: answer!.answerPhoto!))
            }
        }
    }

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }


    private func setupView() {

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true

        let photoAnswer = UIImageView(image: nil)
        photoAnswer.translatesAutoresizingMaskIntoConstraints = false
        photoAnswer.contentMode = .scaleAspectFill
        photoAnswer.backgroundColor = UIColor.clear
        self.addSubview(photoAnswer)
        self.photoAnswer = photoAnswer
        photoAnswer.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let videoIcon = UIImageView(image: nil)
        videoIcon.translatesAutoresizingMaskIntoConstraints = false
        videoIcon.contentMode = .scaleAspectFill
        videoIcon.backgroundColor = UIColor.clear
        self.addSubview(videoIcon)
        self.videoIcon = videoIcon
        videoIcon.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.center.equalToSuperview()
        }

        let dateLabel = UILabel(frame:.zero)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.drSDRegular13Font()
        dateLabel.textColor = UIColor.drGR02
        self.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(17)
            maker.topMargin.equalTo(18)
        }

        let timeLabel = UILabel(frame:.zero)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.drGR02
        self.addSubview(timeLabel)
        self.timeLabel = timeLabel
        timeLabel.snp.makeConstraints { maker in
            maker.trailingMargin.equalTo(17)
            maker.topMargin.equalTo(18)
        }

        let textAnswer = UILabel(frame:.zero)
        textAnswer.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.drSDULight155Font()
        textAnswer.textColor = UIColor.drBK
        self.addSubview(textAnswer)
        self.textAnswer = textAnswer
        textAnswer.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(17)
            maker.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
    }

    override func prepareForReuse() {
        self.dateLabel.text = nil
        self.timeLabel.text = nil
        self.textAnswer.text = nil
        self.photoAnswer.image = nil
        super.prepareForReuse()
    }

}


class TimelineWillItemCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var questionLabel: UILabel!
    weak var moreLabel: UILabel!
    weak var collectionView: UICollectionView!
    weak var countLabel: UILabel!

    var willItem: WillItem? {
        didSet {
            if self.willItem == nil {
                return
            }

            questionLabel.text = self.willItem!.question
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

        self.backgroundColor = UIColor.drGR00

        let questionLabel = UILabel(frame:.zero)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        questionLabel.backgroundColor = UIColor.clear
        questionLabel.font = UIFont.drNM23Font()
        questionLabel.textColor = UIColor.drGR01

        self.contentView.addSubview(questionLabel)
        self.questionLabel = questionLabel
        questionLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(31)
            maker.trailing.equalTo(31)
            maker.top.equalTo(31)
        }

        let moreLabel = UILabel(frame:.zero)
        moreLabel.text = "더보기 >"
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        moreLabel.numberOfLines = 1
        moreLabel.font = UIFont.drSDRegular13Font()
        moreLabel.textColor = UIColor.drGR03
        moreLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(moreLabel)
        self.moreLabel = moreLabel
        moreLabel.snp.makeConstraints { maker in
            maker.left.equalTo(questionLabel.snp.left)
            maker.top.equalTo(questionLabel.snp.bottom).offset(12)
            maker.height.equalTo(15)
        }

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - (32 * 2)), height: (UIScreen.main.bounds.width - (32 * 2))/2 + 10)
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(0, 32, 0, 32)
        collectionView.backgroundColor = UIColor.drGR00
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        self.contentView.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { maker in
            maker.leading.equalTo(0)
            maker.trailing.equalTo(0)
            maker.top.equalTo(moreLabel.snp.bottom).offset(21)
            maker.height.equalTo((UIScreen.main.bounds.width - (32 * 2))/2 + 10)
        }

        collectionView.register(TimelineAnswerCell.self, forCellWithReuseIdentifier: "TimelineAnswerCell")

        let countLabel = UILabel(frame:.zero)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.numberOfLines = 1
        countLabel.font = UIFont.systemFont(ofSize: 13)
        countLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(countLabel)
        self.countLabel = countLabel
        countLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(collectionView.snp.bottom).offset(11)
            maker.height.equalTo(12)
            maker.bottom.equalToSuperview().offset(-14)
        }

        let hairline = UIView(frame: .zero)
        hairline.backgroundColor = UIColor.rgb256(150, 160, 175)
        self.contentView.addSubview(hairline)
        hairline.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(0.5)
         }

    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.willItem == nil {
            return 0
        }

        return self.willItem!.answers.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineAnswerCell", for: indexPath) as? TimelineAnswerCell,
              let answer = self.willItem?.answers[indexPath.row] else {
            fatalError()
        }

        cell.answer = answer
        return cell
    }

}
