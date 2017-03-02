//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

struct IntroPageViewModel {
    let imageName: String
    let description: String
}

class IntroPageView: UICollectionViewCell {

    var imageView: UIImageView!
    var descriptionLabel: UILabel!

    var viewModel: IntroPageViewModel? {
        didSet {
            self.imageView.image = self.viewModel != nil ? UIImage(named: self.viewModel!.imageName) : nil
            self.descriptionLabel.text = self.viewModel?.description
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {

        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.imageView = imageView

        let descriptionLabel = UILabel(frame:.zero)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.lineBreakMode = .byWordWrapping
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(30)
            maker.trailing.equalToSuperview().inset(30)
            maker.top.equalToSuperview().inset(60)
        }

        self.descriptionLabel = descriptionLabel
    }

    override func prepareForReuse() {
        self.viewModel = nil
        super.prepareForReuse()
    }

}

class IntroViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var pageControl: UIPageControl!
    weak var skipButton: UIButton!
    weak var collectionView: UICollectionView!

    var pageViewModel: [IntroPageViewModel] = [
            IntroPageViewModel(imageName: "intro_first", description: "intro_first"),
            IntroPageViewModel(imageName: "intro_second", description: "intro_second"),
            IntroPageViewModel(imageName: "intro_third", description: "intro_third")
    ]
    var completion: (Void) -> Void

    init(completion: @escaping (Void) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = UIScreen.main.bounds.size
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IntroPageView.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView = collectionView

        let pageControl = UIPageControl(frame:.zero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = self.pageViewModel.count
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(0)
        }

        self.pageControl = pageControl

        let skipButton = UIButton(type: .custom)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.setTitle("Start", for: .normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        self.view.addSubview(skipButton)

        skipButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 60, height: 40))
            maker.trailing.equalTo(0)
            maker.bottom.equalTo(0)
        }
        self.skipButton = skipButton

    }

    func skipButtonTapped() {
        self.completion()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pageViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? IntroPageView else {
            fatalError()
        }

        cell.viewModel = self.pageViewModel[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}
