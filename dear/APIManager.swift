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
    
    func signUp(name: String, phoneNumber:String, birth:Date, gender:Bool, completion:@escaping APICompletion) {
        
        var params = [String:Any]()
        params["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        params["phoneNumber"] = phoneNumber

        let birthdayTuple = birth.getBirthdayElements()
        
        params["year"] = birthdayTuple.year
        params["month"] = birthdayTuple.month
        params["day"] = birthdayTuple.day
        
        params["gender"] = gender ? "male" : "female"
        
        self.request(path: "signup", method:.post, params:params, completion: completion)
    }
    

    private func request(path: String, method: HTTPMethod = .get, params: [String:Any]? = nil, completion: APICompletion?) {

        let fullPath = "\(APIFixture.apiProtocol)://\(APIFixture.apiBaseDomain)/\(path)"
        
        Alamofire.request(fullPath, method:method, parameters:params, encoding: PropertyListEncoding.default)
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
