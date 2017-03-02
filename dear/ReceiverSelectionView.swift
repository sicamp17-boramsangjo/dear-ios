//
// Created by kyungtaek on 2017. 2. 24..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

enum ReceiverSelectionConfig {
    case forFilter
    case forRecommand

    func getLayoutConfig() -> (direction:UICollectionViewScrollDirection, itemSpacing:Float, lineSpacing:Float, bgColor:UIColor, contentInset: UIEdgeInsets) {
        switch self {
        case .forFilter:
            return (direction: .horizontal,
                    itemSpacing:15,
                    lineSpacing:15,
                    bgColor:UIColor.drGR10,
                    contentInset: UIEdgeInsetsMake(15, 20, 15, 20)
            )
        case .forRecommand:
            return (direction: .horizontal,
                    itemSpacing:15,
                    lineSpacing:15,
                    bgColor:UIColor.rgb256(241, 242, 243),
                    contentInset: UIEdgeInsetsMake(15, 8, 15, 0)
            )
        }
    }

    func textFont() -> UIFont? {
        switch self {
        case .forFilter:
            return UIFont.drSDULight16Font()
        case .forRecommand:
            return UIFont.drSDLight16Font()
        }
    }

    func textColor() -> UIColor {
        return UIColor.drOR
    }
}


class ReceiverNameCell: UICollectionViewCell {

    weak var nameLabel: UILabel!
    var config: ReceiverSelectionConfig = .forFilter

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setupViewIfNeeds()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func setupViewIfNeeds() {

        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.textColor = self.config.textColor()
        label.font = self.config.textFont()
        label.textAlignment = .center
        self.addSubview(label)
        self.nameLabel = label
        label.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

class ReceiverSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var collectionView: UICollectionView!
    let didSelectReceiver:(Receiver?) -> (Void)

    var receivers:[Receiver]? {
        didSet {
            if self.receivers != nil && self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }

    let config: ReceiverSelectionConfig

    init(config: ReceiverSelectionConfig, didSelectReceiver:@escaping (Receiver?) -> Void) {
        self.didSelectReceiver = didSelectReceiver
        self.config = config
        super.init(frame: .zero)
        self.setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        self.backgroundColor = self.config.getLayoutConfig().bgColor

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = config.getLayoutConfig().direction
        layout.minimumInteritemSpacing = CGFloat(config.getLayoutConfig().itemSpacing)
        layout.minimumLineSpacing = CGFloat(config.getLayoutConfig().lineSpacing)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = config.getLayoutConfig().contentInset
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        self.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        collectionView.register(ReceiverNameCell.self, forCellWithReuseIdentifier: "ReceiverNameCell")
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receivers?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiverNameCell", for: indexPath) as? ReceiverNameCell,
              let receiver = self.receivers?[indexPath.row] else {
            fatalError()
        }
        cell.config = self.config
        cell.setupViewIfNeeds()
        cell.nameLabel.text = receiver.name
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let receiver = self.receivers?[indexPath.row] else {
            return CGSize(width: 0, height: 0)
        }

        let size = (receiver.name as NSString).size(attributes: [NSFontAttributeName : self.config.textFont()])
        return CGSize(width: size.width + 18, height: 30)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }

        guard let receiver = self.receivers?[indexPath.row] else {
            return
        }

        self.didSelectReceiver(receiver)
    }

}
