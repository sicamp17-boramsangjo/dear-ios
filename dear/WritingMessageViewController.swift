//
//  File.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 15..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit

class WritingMessageViewController: UIViewController {

    var textView: UITextView!
    let userId: String
    let willItemId: String
    let completion: ((Bool) -> Void)?

    init(userId: String, willItemId: String, completion: @escaping((Bool) -> Void)) {
        self.userId = userId
        self.willItemId = willItemId
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
