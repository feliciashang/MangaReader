//
//  ExtensionsViewModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-27.
//

import Foundation
import UIKit

class ExtensionsViewModel: ObservableObject {
    
    @Published var onlineImage: OnlineImage = .none
    
    enum OnlineImage {
        case none
        case fetching(Int, String)
        case found
        case failed(String)
        
        var urlBeingFetched: (Int, String)? {
            switch self {
            case .fetching(let number, let title): return (number, title)
            default: return nil
            }
        }
        
        var isFetching: Bool {
            urlBeingFetched != nil
        }
        
        var failureReason: String? {
            switch self {
            case .failed(let reason): return reason
            default: return nil
            }
        }
    }
    
    
    private static func createExtension() -> Extensions {
        Extensions()
    }
    
    @Published private var extensions: Extensions = ExtensionsViewModel.createExtension()
    var progressImgArray: [String] = []
    
    func downloadImage(from page: String) {
        extensions.downloadImage(from: page)
        
    }
    
    func downloadCover(from page: String, for title: String, chapterNumber: Int) {
      //  dispatchGroup.notify(queue: .main) {
        self.onlineImage = .fetching(chapterNumber, title)
      //  }
        extensions.downloadCover(from: page, for: title)
    }
    
    func getDescription(from path: String, for title: String, completion: @escaping (String, Array<String>, Array<Int>, String, Array<String>) ->  Void)  {
        extensions.getDescription(from: path, for: title) {(value, value2, value3, value4, value5) in
            completion(value, value2, value3, value4, value5)
            return
        }
    }
    // completion: @escaping (Array<String>) -> Void
    func downloadImageFromUrl(title: String, chapterNumber: Int, from path: String, completion: @escaping (Array<String>) -> Void) {
        
        extensions.getChapters(from: path) {(value) in
            DispatchQueue.global().async
            {
                self.progressImgArray.removeAll()
                let dispatchGroup = DispatchGroup()
                
                for page in value  {
                    let url = URL(string:page)
                    let group = DispatchGroup()
                    print("Download Started")
                    print(url)
                    print("-------GROUP ENTER-------")
                    group.enter()
                    if url != nil {
                        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error  in
                            
                            guard let data = data, error == nil else {
                                DispatchQueue.main.async() {
                                    self.onlineImage = .failed("Couldn't download Chapter: \(error?.localizedDescription)")
                                }
                                return
                                
                            }
                            
                            print(response?.suggestedFilename ?? url!.lastPathComponent)
                            print("Download Finished")
                            do {
                                try data.write(to: self.extensions.getDocumentsDirectory().appendingPathComponent(response?.suggestedFilename ?? url!.lastPathComponent))
                                print("Image saved to: ",self.extensions.getDocumentsDirectory())
                            } catch {
                                print(error)
                            }
                            let lastComponent = page.components(separatedBy: "/").last ?? "cdc"
                            if lastComponent != "ENDING-PAGE.jpg" {
                                print("outside")
                                DispatchQueue.main.async() {
                                    print("isnde")
                                    self.progressImgArray.append(lastComponent)
                                    
                                }
                            }
                            group.leave()
                        }).resume()
                    }
//                    } else {
//                        DispatchQueue.main.async() {
//                            print("url problem")
//                            self.onlineImage = .failed("Problem with Image URL, cannot download")
//                        }
//                        return
//                    }
                    group.wait()
                
                }
                dispatchGroup.notify(queue: .main) {
                    self.onlineImage = .found
                    // have to think about that when it gets here this array of files is the same one we asked for when we called the async function.
                    completion(self.progressImgArray)
                    
                }
            }
        }
    }
    
    
    
    
    func getChapters(from path: String, completion: @escaping (Array<String>) -> Void) {
        var array: Array<String> = []
        extensions.getChapters(from: path) {(value) in
            for page in value {
                self.downloadImage(from: page)
                let lastComponent = page.components(separatedBy: "/").last ?? "cdc"
                if lastComponent != "ENDING-PAGE.jpg" {
                    array.append(lastComponent)
                }
                
            }
            completion(array)
        }
    }
    

    func getMangaList(from path: String, completion: @escaping (Array<String>, Array<String>)-> Void)  {
        
        extensions.getMangaList(from: path) { (value1, value2) in
            completion(value1, value2)
            
        }
        
    }
    
}
