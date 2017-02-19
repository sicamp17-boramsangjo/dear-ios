//
//  AlertHelper.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 20..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import SwiftMessages

class Alert {

    static func showAlert(message: String) {
        let view = MessageView.viewFromNib(layout: .CardView)
        view.configureTheme(.info)
        view.configureDropShadow()
        view.configureContent(body: "\(message)")
        SwiftMessages.show(view: view)
    }
}
