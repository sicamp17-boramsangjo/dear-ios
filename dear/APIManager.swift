//
// Created by kyungtaek on 2017. 2. 13..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation
import Alamofire

enum APIInternalError: Error {
    case notFound
    case unknown
}

enum APIFixture: String {
    case apiProtocol = "http"
    case apiBaseDomain = "indiweb08.cafe24.com"
    case apiPort = "8888"
    case apiBasePath = "app"
}

enum APIPath: String {
    case createUser = "createUser"
    case getUser = "getUser"
    case getWillItem = "getWillItem"
}

typealias APICompletion = (Any?, Error?) -> Void

class APIManager {

    private let session: URLSession
    private let needUserAuthorization: Bool

    init(session: URLSession?, needUserAuthorization: Bool = false) {
        if session != nil {
            self.session = session!
        } else {
            self.session = URLSession.shared
        }
        self.needUserAuthorization = needUserAuthorization
    }

    func createUser(name: String, phoneNumber: String, birth: Date, gender: Bool, completion:@escaping APICompletion) {

#if DEBUG
        completion(User.fixture(), nil)
#else
        var params = [String: Any]()
        params["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        params["phoneNumber"] = phoneNumber

        let birthdayTuple = birth.getBirthdayElements()

        params["year"] = birthdayTuple.year
        params["month"] = birthdayTuple.month
        params["day"] = birthdayTuple.day

        params["gender"] = gender ? "male" : "female"

        self.request(path: .createUser, params:params, completion: completion)
#endif
    }

    func getUser(userId: String, completion:@escaping APICompletion) {

#if DEBUG
        completion(User.fixture(), nil)
#else
        var params = ["userId": userId]
        self.request(path: .getUser, params:params, completion: completion)
#endif
    }

    func getWillItem(willItemId: String, completion:@escaping APICompletion) {
#if DEBUG
        completion(WillItem.fixture(), nil)
#else
        var params = ["willItemId": willItemId]
        self.request(path: .getWillItem, params: params, completion: completion)
#endif
    }

    private func request(path: APIPath, params: [String:Any]? = nil, completion: APICompletion?) {

        let headers = ["Content-Type": "application/json"]

        let fullPath = "\(APIFixture.apiProtocol)://" +
                "\(APIFixture.apiBaseDomain):" +
                "\(APIFixture.apiPort)/" +
                "\(APIFixture.apiBasePath)/" +
                "\(path.rawValue)"

        Alamofire.request(fullPath,
                        method:.post,
                        parameters:params,
                        encoding: PropertyListEncoding.default,
                        headers: headers)
                .validate(statusCode:200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { response in

                    guard let responseCompletion = completion else {
                        return
                    }

                    switch response.result {
                    case .success:
                        responseCompletion(response.result.value, nil)
                    case .failure(let error):
                        responseCompletion(nil, error)
                    }
                }
    }

}
