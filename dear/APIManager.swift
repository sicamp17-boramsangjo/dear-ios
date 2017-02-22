//
// Created by kyungtaek on 2017. 2. 13..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation
import Alamofire

enum APIInternalError: Error {
    case notFound
    case unknown
    case loginFail
    case alreadyExistUser
    case parsingError
    case logicError
}

enum APIStatusCode: Int {
    case success = 200
    case error = 500
}

enum APIFixture: String {
    case apiProtocol = "http"
    case apiBaseDomain = "indiweb08.cafe24.com"
    case apiPort = "8888"
    case apiBasePath = "app"
}

enum APIPath: String {
    case createUser = "createUser"
    case login = "login"
    case logout = "logout"
    case deleteUser = "deleteUser"
    case updateUserInfo = "updateUserInfo"
    case getUserInfo = "getUserInfo"
    case addReceiver = "addReceiver"
    case removeReceiver = "removeReceiver"
    case getReceivers = "getReceivers"
    case getTodaysQuestion = "getTodaysQuestion"
    case uploadImage = "uploadImage"
    case uploadVideo = "uploadVideo"
    case createAnswer = "createAnswer"
    case deleteAnswer = "deleteAnswer"
    case getWillItemList = "getWillItems"
    case getWillItem = "getWillItem"

    func fullPath() -> String {
        return "\(APIFixture.apiProtocol.rawValue)://" +
                "\(APIFixture.apiBaseDomain.rawValue):" +
                "\(APIFixture.apiPort.rawValue)/" +
                "\(APIFixture.apiBasePath.rawValue)/" +
                "\(self.rawValue)"
    }
}

typealias APIBoolCompletion = (Bool, Error?) -> Void
typealias APICompletion = ([String:Any]?, Error?) -> Void

class APIManager {

    static var sessionToken: String?

    func createUser(userName: String, phoneNumber: String, birthDay: Date, password: String, completion: @escaping APICompletion) {

        var params = [String: Any]()
#if DEBUG
        completion(User.fixture(), nil)
        return
#else
        params["userName"] = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        params["phoneNumber"] = phoneNumber
        params["birthDay"] = birthDay.timeIntervalSince1970
        params["password"] = password
#endif

        self.request(path: .createUser, params: params) { [unowned self] dictionary, error in

            if error != nil {
                completion(nil, error)
                return
            }

            guard let sessionToken = dictionary?["sessionToken"] as? String else {
                completion(nil, APIInternalError.unknown)
                return
            }

            APIManager.sessionToken = sessionToken
            self.request(path: .getUserInfo, completion: completion)
        }
    }



    func login(phoneNumber: String, password: String, completion: @escaping (Bool, Error?) -> Void) {

#if DEBUG
        completion(true, nil)
        return
#endif

        self.request(path: .login) { dictionary, error in

            if error != nil {
                completion(false, error)
                return
            }

            guard let sessionToken = dictionary?["sessionToken"] as? String else {
                completion(false, APIInternalError.unknown)
                return
            }

            APIManager.sessionToken = sessionToken
            completion(true, nil)
        }
    }


    func logout(completion: @escaping APIBoolCompletion) {
        self.request(path: .logout) { dictionary, error in
            completion(error == nil, error)
        }
    }


    func deleteUser(completion: @escaping APIBoolCompletion) {
        self.request(path: .deleteUser) { dictionary, error in
            completion(error == nil, error)
        }
    }

    func updateUserInfo(deviceToken:String? = nil, profileImageUrl: String? = nil, pushDuration: Double = -1, lastLoginAlarmDuration: Double = -1, completion:@escaping APIBoolCompletion) {
        var params:[String:Any] = [:]

        if deviceToken != nil {
            params["deviceToken"] = deviceToken
        }
        if profileImageUrl != nil {
            params["profileImageUrl"] = profileImageUrl
        }
        if pushDuration != -1 {
            params["pushDuration"] = pushDuration
        }
        if lastLoginAlarmDuration != -1 {
            params["lastLoginAlarmDuration"] = lastLoginAlarmDuration
        }

        if params.count == 0 {
            completion(false, APIInternalError.unknown)
        }

        self.request(path: .updateUserInfo, params:params) { dictionary, error in
            completion(error == nil, error)
        }
    }


    func getUserInfo(userId: String, completion: @escaping APICompletion) {

#if DEBUG
        completion(User.fixture(), nil)
        return
#else
        self.request(path: .getUserInfo) { dictionary, error in

            if error != nil {
                completion(nil, error)
                return
            }

            completion(dictionary["user"], nil)
        }
#endif
    }


    func addReceiver(name: String, phoneNumber: String, completion:@escaping APICompletion) {
        let params:[String:Any] = [
                "name":name,
                "phoneNumber":phoneNumber
        ]

        self.request(path: .addReceiver, params: params, completion: completion)
    }


    func removeReceiver(receiverID: String, completion:@escaping APICompletion) {
        let params:[String:Any] = [
                "receiverID":receiverID
        ]

        self.request(path: .removeReceiver, params: params, completion: completion)
    }


    func getReceiverList(completion:@escaping APICompletion) {
        self.request(path: .getReceivers, completion: completion)
    }


    func getTodayQuestion(completion: @escaping APICompletion) {
        self.request(path: .getTodaysQuestion, completion: completion)
    }

    func uploadImage(filePath: String, completion: @escaping APICompletion) {
        self.upload(path: .uploadImage, filePath: filePath, completion: completion)
    }

    func uploadVideo(filePath: String, completion: @escaping APICompletion) {
        self.upload(path: .uploadVideo, filePath: filePath, completion: completion)
    }


    func createAnswer(questionID: String, answerText: String?, answerPhoto: String?, answerVideo: String?, receivers: [String]?, completion:@escaping APICompletion) {

        var params: [String: Any] = [:]
        params["questionID"] = questionID
        params["answerText"] = answerText
        params["answerPhoto"] = answerPhoto
        params["answerVideo"] = answerVideo
        params["receivers"] = receivers
        params["lastUpdate"] = Date().timeIntervalSince1970

        self.request(path: .createAnswer, params:params, completion:completion)
    }

    func deleteAnswer(answerID: String, completion:@escaping APIBoolCompletion) {
        self.request(path: .deleteAnswer) { dictionary, error in
            completion(error == nil, error)
        }
    }


    func getWillItemList(completion: @escaping APICompletion) {
#if DEBUG
        completion(WillItem.fixtureList(), nil)
        return
#else
        self.request(path: .getWillItemList, completion:completion)
#endif
    }


    func getWillItem(willItemId: String, completion: APICompletion) {
#if DEBUG
        completion(WillItem.fixture(), nil)
        return
#else
        var params = ["willItemId": willItemId]
        self.request(path: .getWillItem, params: params, completion: completion)
#endif
    }


    private func request(path: APIPath, params: [String:Any]? = nil, completion:APICompletion?) {

        let headers = ["Content-Type": "application/json"]

        let fullPath = path.fullPath()

        var paramsWithDefaultParam: [String:Any] = params != nil ? params! : [:]

        paramsWithDefaultParam["sessionToken"] = APIManager.sessionToken

        Alamofire.request(fullPath,
                        method:.post,
                        parameters:paramsWithDefaultParam,
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

                        guard let dictionary = response.result.value as? [String:Any] else {
                            responseCompletion(nil, APIInternalError.parsingError)
                            return
                        }

                        guard dictionary["statusCode"] as? Int != APIStatusCode.success.rawValue, let msg = dictionary["msg"] else {
                            responseCompletion(nil, APIInternalError.logicError)
                            return
                        }

                        responseCompletion(dictionary, nil)
                    case .failure(let error):
                        responseCompletion(nil, error)
                    }
                }
    }

    private func upload(path: APIPath, filePath: String, completion: @escaping APICompletion) {

        let fullPath = path.fullPath()
        let fileUrl = URL(fileURLWithPath: filePath)

        Alamofire.upload(fileUrl, to: fullPath).responseJSON { response in
            switch response.result {
            case .success:
                guard let dictionary = response.result.value as? [String:Any] else {
                    completion(nil, APIInternalError.parsingError)
                    return
                }

                guard dictionary["statusCode"] as? Int != APIStatusCode.success.rawValue, let msg = dictionary["msg"] else {
                    completion(nil, APIInternalError.logicError)
                    return
                }

                completion(dictionary, nil)

            case .failure(let error):
                completion(nil, error)
            }
        }
    }

}
