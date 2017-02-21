//
//  SideMenuViewController.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CoreGraphics
import SDWebImage
import ChameleonFramework
import DigitsKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    private var menuItems: [[Any]] = [
            [SideMenuProfileItem(name: "최순실", profileImageUrl:"https://static-cdn.jtvnw.net/jtv_user_pictures/gmdkdsla-profile_image-23beb3368be621ec-300x300.png", receiverName: "박근혜", progress: 0.5) {

            }], [
                    SideMenuItem(title: "New message", iconName: "arrow") {
                    },
                    SideMenuItem(title: "Config alam", iconName: "arrow") {
                        //TODO: open config Alarm
                    },
                    SideMenuItem(title: "Config sending message", iconName: "arrow") {
                        //TODO: open config sending message
                    },
                    SideMenuItem(title: "Tutorial", iconName: "arrow") {
                        //TODO: open tutorial
                    },
                    SideMenuItem(title: "Logout", iconName: "arrow") {
                        DataSource.instance.cleanAllDB()
                        Digits.sharedInstance().logOut()
                        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        delegate.window?.rootViewController = delegate.setupIntroViewGroup()
                    }
            ]
    ]

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        print("init coder style")
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.backgroundColor = UIColor.flatSkyBlueDark
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.view).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(-120)
        }
        self.tableView.register(SideMenuProfileCell.self, forCellReuseIdentifier: "UserProfileCell")
        self.tableView.register(SideMenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menuItems: [Any] = self.menuItems[section]
        return menuItems.count
    }

    private func menuItem(indexPath: IndexPath) -> SideMenuItemRunnable {
        let section = self.menuItems[indexPath.section]
        return section[indexPath.row] as! SideMenuItemRunnable
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let profileCell: SideMenuProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! SideMenuProfileCell

            let menuItem = self.menuItem(indexPath: indexPath) as! SideMenuProfileItem
            profileCell.setupUserProfile(profileImageUrl: menuItem.profileImageUrl, userName: menuItem.name)
            return profileCell

        } else {

            let menuCell: SideMenuItemCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! SideMenuItemCell

            let menuItem = self.menuItem(indexPath: indexPath) as! SideMenuItem
            menuCell.setupMenuItem(icon: UIImage(named:menuItem.iconName)!, itemName: menuItem.title)

            return menuCell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let runnableMenuItem: SideMenuItemRunnable = self.menuItem(indexPath: indexPath)
        runnableMenuItem.handleTapEvent()
    }
}

protocol SideMenuItemRunnable {
    func handleTapEvent() -> Void
}

struct SideMenuItem: SideMenuItemRunnable {
    let title: String
    let iconName: String
    let tapEvent: (Void) -> Void

    func handleTapEvent() {
        self.tapEvent()
    }
}

struct SideMenuProfileItem: SideMenuItemRunnable {
    let name: String
    let profileImageUrl: String
    let receiverName: String
    let progress: Float
    let tapEvent: (Void) -> Void

    func handleTapEvent() {
        tapEvent()
    }

}
