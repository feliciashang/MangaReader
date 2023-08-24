//
//  ExtensionsViewModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-27.
//

import Foundation
import UIKit

class ExtensionsViewModel: ObservableObject {
    private static func createExtension() -> Extensions {
        Extensions()
    }
    
    @Published private var extensions: Extensions = ExtensionsViewModel.createExtension()
    var progressImgArray: [String] = []
    
    func downloadImage(from page: String) {
        extensions.downloadImage(from: page)
        
    }
    
    func downloadCover(from page: String, for title: String) {
        extensions.downloadCover(from: page, for: title)
    }
    
    func getDescription(from path: String, for title: String, completion: @escaping (String, Array<String>, Array<Int>, String, Array<String>) -> Void) {
        extensions.getDescription(from: path, for: title) {(value, value2, value3, value4, value5) in
            completion(value, value2, value3, value4, value5)
            return
        }
    }
    
    func downloadImageFromUrl(from path: String) {
        extensions.getChapters(from: path) {(value) in
            DispatchQueue.global().async
            {
                let dispatchGroup = DispatchGroup()
                for page in value  {
                    let url = URL(string:page)
                    let group = DispatchGroup()
                    print("Download Started")
                    print(url)
                    print("-------GROUP ENTER-------")
                    group.enter()
                    URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error  in
                        
                        guard let data = data, error == nil else { return }
                        
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
                            DispatchQueue.main.async() {
                                self.progressImgArray.append(lastComponent)
                            }
                        }
                        group.leave()
                    }).resume()
                    group.wait()
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
