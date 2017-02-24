//
// Created by kyungtaek on 2017. 2. 24..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import ASPVideoPlayer

class VideoViewer: UIViewController {

    let videoPath:String

    init(videoPath:String) {
        self.videoPath = videoPath
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.view.backgroundColor = UIColor.black

        let videoPlayer = ASPVideoPlayer(frame:.zero)
        videoPlayer.gravity = .aspectFit
        videoPlayer.tintColor = UIColor.lightGray
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videoPlayer)
        videoPlayer.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        videoPlayer.shouldLoop = true
        videoPlayer.videoURLs = [URL(string: videoPath)!]

        let button = UIButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 60, height: 40))
            maker.leadingMargin.equalToSuperview().offset(8)
            maker.topMargin.equalToSuperview().offset(24)
        }
    }

    @objc private func closeButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true)
    }

}
