//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation
import Alamofire

class UploadManager {

    static let instance = UploadManager()

    let apiManager: APIManager = APIManager(session: nil, needUserAuthorization: true)

    private init() {}

    func createAnswer(questionID: String, textAnswer: String?, imageAnswer: String?, videoAnswer: String?, receivers: [String]?, completion:@escaping ((Bool, Error?) -> Void)) {
        let queue = DispatchQueue.global()
        let dispatchGroup = DispatchGroup()

        var attachments: [String:String] = [:]
        var imageUrl: String? = nil
        var videoUrl: String? = nil

        if imageAnswer != nil {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.apiManager.upload(path: .uploadImage, filePath: imageAnswer!) { response, _ in

                    defer {
                        dispatchGroup.leave()
                    }

                    guard let responseDictionary = response as? Dictionary<String, String> else {
                        return
                    }

                    imageUrl = responseDictionary["url"]
                }
            }
        }

        if videoAnswer != nil {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.apiManager.upload(path: .uploadVideo, filePath: videoAnswer!) { response, _ in
                    defer {
                        dispatchGroup.leave()
                    }

                    guard let responseDictionary = response as? Dictionary<String, String> else {
                        return
                    }

                    imageUrl = responseDictionary["url"]
                }
            }
        }

        dispatchGroup.notify(queue: queue) { [unowned self] in
            self.apiManager.createAnswer(questionID: questionID, answerText: textAnswer, answerPhoto:imageUrl, answerVideo: videoUrl, receivers:receivers) { _, error in
                guard error == nil else {
                    completion(false, error)
                    return
                }

                completion(true, nil)
            }
        }
    }

}
