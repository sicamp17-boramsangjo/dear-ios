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

            guard let willItemRawList = response?["results"] as? Array<Any> else {
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let willItem = self.willItemList?[section] else { return 0 }
        return 10//willItem.answers.count + 1 // +1 == question
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
         uni(height: [79]) +
         "현실공간이 비현실적이거나 가상현실처럼 느껴진 적이 있나요? 그것은 어떤 경험이었나요?".boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude),
         options: [.usesLineFragmentOrigin, .usesFontLeading],
         attributes: nil, context: nil).height
         */
        
        /*
         uni(height: [72]) +
         "현실공간이 비현실적이거나 가상현실처럼 느껴진 적이 있나요? 그것은 어떤 경험이었나요?".boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude),
         options: [.usesLineFragmentOrigin, .usesFontLeading],
         attributes: nil, context: nil).height
         */

        return uni(height: [72]) +
            "비현실적인거 까지는 모르겠고, 버스타고 집에 가는데 문득 예전 일과 오버랩 되는 그런 날이 있는듯. 다 그럴까?".boundingRect(with: CGSize.init(width: uni(width: [265]), height: CGFloat.greatestFiniteMagnitude),
                                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                        attributes: nil, context: nil).height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyQuestionCell.identifier()) as! ReadOnlyQuestionCell
        cell.label1.text = "현실공간이 비현실적이거나 가상현실처럼 느껴진 적이 있나요? 그것은 어떤 경험이었나요?"
         */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadOnlyAnswerCell.identifier()) as! ReadOnlyAnswerCell
        cell.label1.text = "비현실적인거 까지는 모르겠고, 버스타고 집에 가는데 문득 예전 일과 오버랩 되는 그런 날이 있는듯. 다 그럴까?"
        cell.label2.text = "2016.02.10"
        
        return cell
    }

}
