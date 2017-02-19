//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

enum MenuMode {
    case todaysWillItem
    case timeline
}

class ContentBaseViewController: UIViewController {

    weak var topToolbar: UIView!
    weak var menuBar: UIView!
    weak var contentBaseView: UIView!

    var menuMode: MenuMode = .todaysWillItem

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let topToolbar = UIView(frame: .zero)
        topToolbar.translatesAutoresizingMaskIntoConstraints = false
        topToolbar.backgroundColor = UIColor.random()
        self.view.addSubview(topToolbar)
        self.topToolbar = topToolbar
        self.topToolbar.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(60)
        }

        let menubar = UIView(frame: .zero)
        menubar.translatesAutoresizingMaskIntoConstraints = false
        menubar.backgroundColor = UIColor.random()
        self.view.addSubview(menubar)
        self.menuBar = menubar
        self.menuBar.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(topToolbar.snp.bottom)
            maker.height.equalTo(60)
        }

        let contentBaseView = UIView(frame: .zero)
        contentBaseView.translatesAutoresizingMaskIntoConstraints = false
        contentBaseView.backgroundColor = UIColor.random()
        self.view.addSubview(contentBaseView)
        self.contentBaseView = contentBaseView
        self.contentBaseView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(0)
            maker.top.equalTo(menubar.snp.bottom)
        }

        self.setupTodayWillItemMode()
    }

    private func setupTodayWillItemMode() {
        let viewController = WillItemViewController(nibName: nil, bundle: nil)
        self.addChildViewController(viewController)
        viewController.view.frame = self.contentBaseView.bounds
        self.contentBaseView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)

    }
}
