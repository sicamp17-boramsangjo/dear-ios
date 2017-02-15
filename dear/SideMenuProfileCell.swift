//
//  ProfileCell.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import CoreGraphics
import SDWebImage
import ChameleonFramework

class SideMenuProfileCell: UITableViewCell {
    private var profileImageVIew: UIImageView!
    private var userNameLabel: UILabel!
    private var progress: UIProgressView!
    private var receiverNameLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = UIColor.clear

        let imageView = UIImageView.init(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.flatYellow().cgColor

        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }

        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)

        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0.4
        progress.progressTintColor = UIColor.flatYellow()
        progress.backgroundColor = UIColor.flatYellowColorDark()
        progress.snp.makeConstraints { (make) in
            make.width.equalTo(80)
        }

        let receiverNameLabel = UILabel(frame: .zero)
        receiverNameLabel.translatesAutoresizingMaskIntoConstraints = false
        receiverNameLabel.textColor = UIColor.white
        receiverNameLabel.font = UIFont.systemFont(ofSize: 10)

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, progress, receiverNameLabel])
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .center

        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 80, left: 0, bottom: 30, right: 0))
        }

        self.userNameLabel = nameLabel
        self.profileImageVIew = imageView
        self.progress = progress
        self.receiverNameLabel = receiverNameLabel
    }

    func setupUserProfile(profileImageUrl: String, userName: String) {
        self.profileImageVIew.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
        self.userNameLabel.text = userName
    }

}
