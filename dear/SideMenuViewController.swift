//
//  SideMenuViewController.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import SDWebImage
import DKImagePickerController

class SideMenuViewController: UIViewController {
    
    var imageView1 = UIImageView()
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var view1 = UIView()
    var button1 = UIButton(type: .system)
    var button2 = UIButton(type: .system)
    var button3 = UIButton(type: .system)
    let apiManager = APIManager()

    var user:User? {
        didSet {

            guard self.user != nil, let userName = self.user?.userName else {
                return
            }

            if let profileImageUrl = self.user?.profileImageUrl {
                self.imageView1.sd_setImage(with:URL(string:profileImageUrl))
            }

            self.label1.text = userName
            self.label2.text = nil
            self.label3.text = "\(DataSource.instance.numOfAnswers())개 답변 작성"
        }
    }
    
    var isOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.user = DataSource.instance.fetchLoginUser()
    }


    private func initView() {
        view.uni(frame: [-300, 0, 300, 667], pad: [])
        view.backgroundColor = UIColor.white
        
        imageView1.uni(frame: [105, 65, 90, 90], pad: [])
        imageView1.backgroundColor = UIColor(hexString: "bec3c8")
        imageView1.layer.cornerRadius = imageView1.bounds.width / 2
        imageView1.layer.masksToBounds = true
        imageView1.isUserInteractionEnabled = true
        imageView1.image = UIImage(named: "profileSample")
        view.addSubview(imageView1)

        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(profileImageTapped(_:)))
        imageView1.addGestureRecognizer(tapGesture)
        
        label1.uni(frame: [0, 170, 300, 25], pad: [])
        label1.textAlignment = .center
        label1.font = UIFont.drNM21Font()
        label1.text = "선영"
        view.addSubview(label1)
        
        label2.uni(frame: [0, 210, 300, 15], pad: [])
        label2.textAlignment = .center
        label2.font = UIFont.drNM15Font()
        label2.text = "6일째 작성중"
        view.addSubview(label2)
        
        label3.uni(frame: [0, 230, 300, 15], pad: [])
        label3.textAlignment = .center
        label3.font = UIFont.drNM15Font()
        label3.text = "36개 답변 작성"
        view.addSubview(label3)
        
        view1.uni(frame: [45, 293, 210, 0.5], pad: [])
        view1.backgroundColor = UIColor.black
        view.addSubview(view1)
        
        button1.uni(frame: [0, 330, 300, 70], pad: [])
        button1.titleLabel!.font = UIFont.drNM24Font()
        button1.setTitle("dear", for: .normal)
        button1.tintColor = UIColor(hexString: "555555")
        button1.addTarget(self, action: #selector(action(button1:)), for: .touchUpInside)
        view.addSubview(button1)
        
        button2.uni(frame: [0, 410, 300, 70], pad: [])
        button2.titleLabel!.font = UIFont.drNM23Font()
        button2.setTitle("도움말", for: .normal)
        button2.tintColor = UIColor(hexString: "555555")
        button2.addTarget(self, action: #selector(action(button2:)), for: .touchUpInside)
        view.addSubview(button2)
        
        button3.uni(frame: [0, 480, 300, 70], pad: [])
        button3.titleLabel!.font = UIFont.drNM23Font()
        button3.setTitle("설정", for: .normal)
        button3.tintColor = UIColor(hexString: "555555")
        button3.addTarget(self, action: #selector(action(button3:)), for: .touchUpInside)
        view.addSubview(button3)
    }
    
    @objc private func action(button1: UIButton) {
        
    }
    
    @objc private func action(button2: UIButton) {
        
    }
    
    @objc private func action(button3: UIButton) {
        let settingViewController = SettingViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: settingViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true)
    }

    @objc private func profileImageTapped(_ gesture: UITapGestureRecognizer) {
        if gesture.state != .ended {
            return
        }

        self.launchImagePickerController()
    }

    private func launchImagePickerController() {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            guard let selectedAsset = assets.first else {
                return
            }

            selectedAsset.fetchFullScreenImage(false) {[unowned self] (image:UIImage?, info:[AnyHashable:Any]?) in

                guard let resultImage = image else {
                    return
                }

                let imageData = UIImageJPEGRepresentation(resultImage, 0.8)
                let savedImageFilePath = "\(FileManager.uploadCachePath())/\(FileManager.uniqueFileName(fileExtension: "jpg"))"
                try! imageData?.write(to: URL(fileURLWithPath: savedImageFilePath))

                UploadManager.instance.uploadNewProfileImage(imagePath: savedImageFilePath) { url, _ in
                    if url == nil {
                        return
                    }
                    self.updateUserProfile()
                }
            }
        }

        DispatchQueue.main.async {
            UIWindow.visibleViewController()?.present(pickerController, animated: true)
        }
    }

    private func updateUserProfile() {
        self.apiManager.getUserInfo {[unowned self] dictionary, error in

            guard let loginUserValue = dictionary else {
                return
            }

            DataSource.instance.storeLoginUser(loginUserValue: loginUserValue)

            DispatchQueue.main.async { [unowned self] in
                self.user = DataSource.instance.fetchLoginUser()
            }
        }
    }

}
