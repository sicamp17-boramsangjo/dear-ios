//
//  SIdeMenuItemCell.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit

class SideMenuItemCell: UITableViewCell {

    var itemIcon: UIImageView!
    var itemLabel: UILabel!

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
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        imageView.contentMode = .scaleAspectFit

        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 12)

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center

        self.contentView.addSubview(stackView)

        stackView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        self.itemIcon = imageView
        self.itemLabel = nameLabel
    }

    func setupMenuItem(icon: UIImage, itemName: String) {
        //self.itemIcon.image = icon
        self.itemLabel.text = itemName
    }

}
