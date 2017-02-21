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
    case uploadImage = "uploadImage"
    case uploadVideo = "uploadVideo"
    case createAnswer = "createAnswer"

    func fullPath() -> String {
        return "\(APIFixture.apiProtocol)://" +
                "\(APIFixture.apiBaseDomain):" +
                "\(APIFixture.apiPort)/" +
                "\(APIFixture.apiBasePath)/" +
                "\(self.rawValue)"
    }
}

typealias APICompletion = (Any?, Error?) -> Void

class APIManager {

    private let session: URLSession
    private let needUserAuthorization: Bool
    static var sessionToken: String?

    init(session: URLSession?, needUserAuthorization: Bool = false) {
        if session != nil {
            self.session = session!
        } else {
            self.session = URLSession.shared
        }
        self.needUserAuthorization = needUserAuthorization
    }

    func createUser(name: String, phoneNumber: String, birth: Date, gender: Bool, completion: APICompletion) {

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

    func getUser(userId: String, completion: APICompletion) {

#if DEBUG
        completion(User.fixture(), nil)
#else
        var params = ["userId": userId]
        self.request(path: .getUser, params:params, completion: completion)
#endif
    }

    func getWillItem(willItemId: String, completion: APICompletion) {
#if DEBUG
        completion(WillItem.fixture(), nil)
#else
        var params = ["willItemId": willItemId]
        self.request(path: .getWillItem, params: params, completion: completion)
#endif
    }

    func createAnswer(questionID: String, answerText: String?, answerPhoto: String?, answerVideo: String?, receivers: [String]?, completion:@escaping APICompletion) {

        var params: [String: Any] = [:]
        if self.needUserAuthorization {
             params["sessionToken"] = APIManager.sessionToken
        }
        params["questionID"] = questionID
        params["answerText"] = answerText
        params["answerPhoto"] = answerPhoto
        params["answerVideo"] = answerVideo
        params["receivers"] = receivers
        params["lastUpdate"] = Date().timeIntervalSince1970

        self.request(path: .createAnswer, params:params, completion:completion)

    }

    private func request(path: APIPath, params: [String:Any]? = nil, completion: APICompletion?) {

        let headers = ["Content-Type": "application/json"]

        let fullPath = path.fullPath()

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

    func upload(path: APIPath, filePath: String, completion: APICompletion?) {

        let fullPath = path.fullPath()
        let fileUrl = URL(fileURLWithPath: filePath)
        Alamofire.upload(multipartFormData: { (data: MultipartFormData) -> Void in
            data.append(fileUrl, withName: fileUrl.lastPathComponent)
        }, to: fullPath, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                completion?(upload, nil)
            case .failure(let encodingError):
                completion?(nil, encodingError)
            }
        })

    }

}
