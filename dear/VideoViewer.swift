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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
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

        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "closeButtonWhite"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.leadingMargin.equalTo(3)
            maker.topMargin.equalTo(30)
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }
    }

    @objc private func closeButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true)
    }

}
