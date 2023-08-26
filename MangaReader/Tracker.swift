//
//  Tracker.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-19.
//

import SwiftUI

class Tracker {
    
//    private static func createAPI() -> AlamofireAPI {
//        AlamofireAPI()
//    }
//
//    @Published private var model: AlamofireAPI = Tracker.createAPI()
//
    var trackers: Dictionary<String, Int>
    init() {
        trackers = Dictionary<String, Int>()
        
    }
    func updateManga(name: String, chapter: Int) {
        print(trackers)
        if let id = trackers[name] {
            AlamofireAPI.shared.updateList(id: id, chapters: chapter)
        }
    }
    func addManga(name: String, completion: @escaping(Bool)->()) throws  {
        var new_name: String = ""
        for i in name {
            if i == " "{
                new_name += "%20"
            } else {
                new_name += String(i)
            }
        }
        print(new_name)
       
        try AlamofireAPI.shared.findID(original_name: name, name: new_name) { (id) in
                if id != nil {
                    print(id)
                    self.trackers[name] = id
                    print(self.trackers)
                    completion(true)
                } else {
                    
                    completion(false)
                }
            }
        
    }
}
