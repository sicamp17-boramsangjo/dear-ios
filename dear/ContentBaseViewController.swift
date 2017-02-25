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

    weak var menuBar: UIView!
    weak var contentBaseView: UIView!

    weak var sideMenuButton: UIButton!
    weak var todayButton: UIButton!
    weak var timelineButton: UIButton!

    var menuMode: MenuMode = .todaysWillItem
    
    var sideMenuView: SideMenuViewController!
    var menuCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor.white

        let menubar = UIView(frame: .zero)
        menubar.translatesAutoresizingMaskIntoConstraints = false
        menubar.backgroundColor = UIColor.white
        self.view.addSubview(menubar)
        self.menuBar = menubar
        self.menuBar.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
            maker.height.equalTo(40)
        }

        let sideMenuButton = UIButton(type: .custom)
        sideMenuButton.setTitle("M", for: .normal)
        sideMenuButton.titleLabel?.font = UIFont.drSDMedium16Font()
        sideMenuButton.setTitleColor(UIColor.drGR02, for: .normal)
        sideMenuButton.addTarget(self, action: #selector(sideMenuButtonTapped(_:)), for: .touchUpInside)
        menuBar.addSubview(sideMenuButton)
        self.sideMenuButton = sideMenuButton
        sideMenuButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(10)
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }

        let todayButton = UIButton(type: .custom)
        todayButton.setTitle("오늘의 질문", for: .normal)
        todayButton.titleLabel?.font = UIFont.drNM13Font()
        todayButton.setTitleColor(UIColor.drGR04, for: .normal)
        todayButton.setTitleColor(UIColor.drGR01, for: .selected)
        todayButton.addTarget(self, action: #selector(menuChanged(_:)), for: .touchUpInside)
        menuBar.addSubview(todayButton)
        self.todayButton = todayButton
        todayButton.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(40)
        }

        let timelineButton = UIButton(type: .custom)
        timelineButton.setTitle("전체보기", for: .normal)
        timelineButton.titleLabel?.font = UIFont.drSDMedium16Font()
        timelineButton.setTitleColor(UIColor.drGR04, for: .normal)
        timelineButton.setTitleColor(UIColor.drGR02, for: .selected)
        timelineButton.addTarget(self, action: #selector(menuChanged(_:)), for: .touchUpInside)
        menuBar.addSubview(timelineButton)
        self.timelineButton = timelineButton
        timelineButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-10)
            maker.size.equalTo(CGSize(width: 80, height: 40))
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
        
        menuCoverView = UIView()
        menuCoverView.uni(frame: [0, 0, 375, 667], pad: [])
        menuCoverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        menuCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sideMenuButtonTapped(_:))))
        menuCoverView.isHidden = true
        menuCoverView.alpha = 0
        view.addSubview(menuCoverView)
        
        sideMenuView = SideMenuViewController()
        addChildViewController(sideMenuView)
        view.addSubview(sideMenuView.view)
    }

    private func setupTodayWillItemMode() {

        self.todayButton.isSelected = true
        self.timelineButton.isSelected = false

        let willItemVC = WillItemViewController(willItemID: nil)
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
        /*guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.sideMenu?.presentLeftMenuViewController()
         */
        if sideMenuView.isOpen {
            UIView.animate(withDuration: 0.35, animations: {
                self.menuCoverView.alpha = 0
                self.sideMenuView.view.frame.origin.x = -300
            }, completion: { finish in
                self.menuCoverView.isHidden = false
            })
        } else {
            menuCoverView.isHidden = false
            UIView.animate(withDuration: 0.35, animations: {
                self.menuCoverView.alpha = 1
                self.sideMenuView.view.frame.origin.x = 0
            })
        }
        sideMenuView.isOpen = !sideMenuView.isOpen
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
