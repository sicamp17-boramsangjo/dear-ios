//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class ReadOnlyContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReadOnlyProfileHeaderDelegate {
    
    
    let apiManager:APIManager = APIManager()
    var deceased:User? {
        didSet {
            //TODO: setup tableHeaderView
        }
    }
    var willItemList:[WillItem]? {
        didSet {
            //TODO: reload TableView
        }
    }
    
    var tableView: UITableView!
    var imageView1 = UIImageView()
    var label1 = UILabel()
    
    init(sessionToken:String) {
        super.init(nibName: nil, bundle: nil)
        self.apiManager.readOnlySessionToken = sessionToken
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.getDeceasedInfo { deceased, error in
            
            guard deceased != nil && error == nil else {
                Alert.showError(error ?? InternalError.loginFail)
                return
            }
            
            self.deceased = deceased
        }
        
        self.fetchWillItemList { [unowned self] willItemList, error in
            guard error == nil else {
                Alert.showError(error!)
                return
            }
            
            self.willItemList = willItemList
        }
    }
    
    private func setupView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hexString: "ebeef1")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        tableView.separatorStyle = .none
        let tableHeaderView = ReadOnlyDeceasedProfileHeaderView()
        tableHeaderView.delegate = self
        tableView.tableHeaderView = tableHeaderView
        
        tableView.register(ReadOnlyQuestionCell.self, forCellReuseIdentifier: ReadOnlyQuestionCell.identifier())
        tableView.register(ReadOnlyAnswerCell.self, forCellReuseIdentifier: ReadOnlyAnswerCell.identifier())
        
        imageView1.uni(frame: [0, -261, 375, 331], pad: [])
        imageView1.image = #imageLiteral(resourceName: "nightBg")
        imageView1.isHidden = true
        view.addSubview(imageView1)
        
        label1.uni(frame: [0, 281, 375, 50], pad: [])
        label1.textAlignment = .center
        label1.font = UIFont.drNM19Font()
        label1.textColor = UIColor.white
        label1.text = "dear. 엄마"
        label1.alpha = 0
        label1.isHidden = true
        imageView1.addSubview(label1)
    }
    
    private func fetchWillItemList(completion:@escaping (([WillItem]?, Error?) -> Void)) {
        self.apiManager.getWillItemList { response, error in
            
            guard let willItemRawList = response?["willitems"] as? Array<Any> else {
                completion(nil, InternalError.unknown)
                return
            }
            
            //WARN: !!! 내 유언이 아니기 때문에 Datastore에 save하지 말아야 한다 !!!!
            var willItemList: [WillItem] = []
            
            for willItemRaw in willItemRawList {
                let willItem = WillItem(value: willItemRaw)
                willItemList.append(willItem)
            }
            
            completion(willItemList, nil)
        }
    }
    
    private func getDeceasedInfo(completion: @escaping (User?, Error?) -> Void) {
        self.apiManager.getUserInfo {[unowned self] loginUser, error in
            guard loginUser != nil else {
                completion(nil, error)
                return
            }
            //WARN: !!! 내 유언이 아니기 때문에 Datastore에 save하지 말아야 한다 !!!!
            completion(User(value: loginUser!), nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard let count = self.willItemList?.count else { return 0 }
        return 1//count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let willItem = self.willItemList?[section] else { return 0 }
        return 5//willItem.answers.count + 1 // +1 == question
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return uni(height: [152]) +
                "string data".boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: nil, context: nil).height
        } else {
            if let text = willItemList?[indexPath.section].answers[indexPath.row].answerText {
                return uni(height: [92]) +
                    text.boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: nil, context: nil).height
            } else {
                return uni(height: [92]) + uni(height: [200])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let questionCell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyQuestionCell.identifier()) as! ReadOnlyQuestionCell
            
            questionCell.label1.text = "호랑이는 죽어서 가죽을 남긴다는데, 당신은 죽어서 무엇을 남기고 싶나요?"
            
            return questionCell
        } else {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyAnswerCell.identifier()) as! ReadOnlyAnswerCell
            
            answerCell.label1.text = "비현실적인거 까지는 모르겠고, 버스타고 집에 가는데 문득 예전 일과 오버랩 되는 그런 날이 있는듯. 다 그럴까?"
            answerCell.label2.text = "2016.02.10"
            
            if let _ = willItemList?[indexPath.section].answers[indexPath.row].answerText {
                answerCell.type = 0
            } else if let _ = willItemList?[indexPath.section].answers[indexPath.row].answerPhoto {
                answerCell.type = 1
            } else if let _ = willItemList?[indexPath.section].answers[indexPath.row].answerVideo {
                answerCell.type = 2
            }
            
            return answerCell
        }
    }
    
    func skipHeader() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        var offset = tableView.contentOffset
        if !label1.isHidden {
            offset.y = offset.y - uni(height: [70])
        }
        tableView.setContentOffset(offset, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var percent = 1 - scrollView.contentOffset.y / uni(height: [260])
        percent = (percent <= 0) ? 1 + percent : percent
        if let header = tableView.tableHeaderView as? ReadOnlyDeceasedProfileHeaderView, percent >= 1 {
                header.imageView1.transform = CGAffineTransform(scaleX: percent, y: percent)
                header.label1.frame.origin.y = uni(height: [123]) * percent
                header.label1.transform = CGAffineTransform(scaleX: percent, y: percent)
                header.label1.isHidden = (percent <= 0.7) ? true : false
                
                header.label2.frame.origin.y = uni(height: [203]) * percent
                header.label2.transform = CGAffineTransform(scaleX: percent, y: percent)
                header.label2.isHidden = (percent <= 0.7) ? true : false
        }
        
        imageView1.isHidden = (scrollView.contentOffset.y <= uni(height: [260])) ? true : false
        if scrollView.contentOffset.y <= uni(height: [500]) {
            UIView.animate(withDuration: 0.35, animations: {
                self.label1.alpha = 0
            }, completion: { finish in
                self.label1.isHidden = true
            })
        } else {
            label1.isHidden = false
            UIView.animate(withDuration: 0.35, animations: {
                self.label1.alpha = 1
            })
        }
    }
    
}
