//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class ReadOnlyContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        tableView.separatorStyle = .none
        let tableHeaderView = ReadOnlyDeceasedProfileHeaderView()
        tableView.tableHeaderView = tableHeaderView
        
        tableView.register(ReadOnlyQuestionCell.self, forCellReuseIdentifier: ReadOnlyQuestionCell.identifier())
        tableView.register(ReadOnlyAnswerCell.self, forCellReuseIdentifier: ReadOnlyAnswerCell.identifier())
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
        guard let count = self.willItemList?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let willItem = self.willItemList?[section] else { return 0 }
        return willItem.answers.count + 1 // +1 == question
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return uni(height: [79]) +
                "string data".boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: nil, context: nil).height
        } else {
            if let text = willItemList?[indexPath.section].answers[indexPath.row].answerText {
                return uni(height: [72]) +
                    text.boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: nil, context: nil).height
            } else {
                return uni(height: [72]) + uni(height: [200])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let questionCell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyQuestionCell.identifier()) as! ReadOnlyQuestionCell
            return questionCell
        } else {
            let answerCell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyAnswerCell.identifier()) as! ReadOnlyAnswerCell
            
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
    
}
