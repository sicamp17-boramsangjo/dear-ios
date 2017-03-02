//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation

extension FileManager {

    static func uploadCachePath() -> String {

        let cachesDictionary = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

        let cacheFullPath = "\(cachesDictionary)/upload"

        do {
            try FileManager.default.createDirectory(atPath: cacheFullPath, withIntermediateDirectories: true)
        } catch {
            print(error)
        }

        return cacheFullPath

    }

    static func uniqueFileName(fileExtension: String) -> String {
        let uuid = UUID()
        return "\(uuid.uuidString).\(fileExtension)"
    }

}
