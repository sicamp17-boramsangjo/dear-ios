//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation
import Alamofire

class UploadManager {

    static let instance = UploadManager()

    let apiManager: APIManager = APIManager()

    private init() {}

    func createAnswer(questionID: String, textAnswer: String?, imageAnswer: String?, videoAnswer: String?, receivers: [String]?, mediaSize:CGSize = CGSize(), completion:@escaping ((String?, Error?) -> Void)) {
        let queue = DispatchQueue(label: "com.allaboutswift.dispatchgroup")
        let dispatchGroup = DispatchGroup()

        var attachments: [String:String] = [:]
        var imageUrl: String? = nil
        var videoUrl: String? = nil

        if imageAnswer != nil {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.apiManager.uploadImage(filePath: imageAnswer!) { response, _ in

                    defer {
                        dispatchGroup.leave()
                    }

                    imageUrl = response?["url"] as? String
                }
            }
        }

        if videoAnswer != nil {
            dispatchGroup.enter()
            queue.async(group: dispatchGroup) {
                self.apiManager.uploadVideo(filePath: videoAnswer!) { response, _ in
                    defer {
                        dispatchGroup.leave()
                    }

                    videoUrl = response?["url"] as? String
                }
            }
        }

        dispatchGroup.notify(queue: queue) { [unowned self] in
            self.apiManager.createAnswer(questionID: questionID, answerText: textAnswer, answerPhoto:imageUrl, answerVideo: videoUrl, receivers:receivers, mediaSize:mediaSize, completion:completion)
        }
    }

}
