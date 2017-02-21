//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import AKSideMenu

enum MenuMode {
    case todaysWillItem
    case timeline
}

class ContentBaseViewController: UIViewController {

    weak var topToolbar: UIView!
    weak var menuBar: UIView!
    weak var contentBaseView: UIView!

    weak var todayButton: UIButton!
    weak var timelineButton: UIButton!

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

        let sideMenuButton = UIButton(type: .custom)
        sideMenuButton.setTitle("Menu", for: .normal)
        sideMenuButton.addTarget(self, action: #selector(sideMenuButtonTapped(_:)), for: .touchUpInside)
        topToolbar.addSubview(sideMenuButton)
        sideMenuButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(8)
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

        let todayButton = UIButton(type: .roundedRect)
        todayButton.setTitle("Today", for: .normal)
        todayButton.addTarget(self, action: #selector(menuChanged(_:)), for: .touchUpInside)

        let timelineButton = UIButton(type: .roundedRect)
        timelineButton.setTitle("Timeline", for: .normal)
        timelineButton.addTarget(self, action: #selector(menuChanged(_:)), for: .touchUpInside)

        let menuButtonContainer = UIStackView(arrangedSubviews: [todayButton, timelineButton])
        menuButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        menuButtonContainer.axis = .horizontal
        menuButtonContainer.alignment = .center
        menuButtonContainer.spacing = 10
        menuBar.addSubview(menuButtonContainer)
        menuButtonContainer.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        self.timelineButton = timelineButton
        self.todayButton = todayButton

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

        self.todayButton.isSelected = true
        self.timelineButton.isSelected = false

        let willItemVC = WillItemViewController(nibName: nil, bundle: nil)
        self.addChildViewController(willItemVC)
        willItemVC.view.frame = self.contentBaseView.bounds
        self.contentBaseView.addSubview(willItemVC.view)
        willItemVC.didMove(toParentViewController: self)
    }

    private func setupTImelineMode() {

        self.todayButton.isSelected = false
        self.timelineButton.isSelected = true

        let timelineVC = TimelineViewController(nibName: nil, bundle: nil)
        self.addChildViewController(timelineVC)
        timelineVC.view.frame = self.contentBaseView.bounds
        self.contentBaseView.addSubview(timelineVC.view)
        timelineVC.didMove(toParentViewController: self)

    }

    @objc private func sideMenuButtonTapped(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.sideMenu?.presentLeftMenuViewController()
    }

    @objc private func menuChanged(_ sender: UIButton) {

        self.childViewControllers.forEach { element in
            element.view.removeFromSuperview()
            element.removeFromParentViewController()
        }

        if sender == self.todayButton {
            self.setupTodayWillItemMode()
        } else {
            self.setupTImelineMode()
        }
    }
}
