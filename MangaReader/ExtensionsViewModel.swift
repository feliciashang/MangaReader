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
    
    var links:Array<String> = Array<String>()
    var titles:Array<String> = Array<String>()
    var description: String = ""
    var cover_description: Dictionary<String, String> = Dictionary<String, String>()
    var pages:Array<Extensions.Page> {
        return extensions.pages
    }
    
    
    var firstpage: Extensions.Page {
        return extensions.pages[0]
    }
    
    func downloadImage(from page: Extensions.Page) {
        extensions.downloadImage(from: page)
        
    }
    func getDescription(from path: String, for title: String, completion: @escaping (String, Array<String>, Array<String>) -> Void) {
        extensions.getDescription(from: path, for: title) {(value, value2, value3) in
            self.cover_description[title] = value
            self.description = value
            completion(value, value2, value3)
            return
        }
    }
    var onlineCovers: Array<Extensions.onlineCover> {
        return extensions.onlineCovers
    }
    func getChapters(from path: String, completion: @escaping (Array<String>) -> Void) {
        var array: Array<String> = []
        extensions.getChapters(from: path) {(value) in
            for page in value {
                self.downloadImage(from: page)
                let lastComponent = page.url.components(separatedBy: "/").last ?? "cdc"
                if lastComponent != "ENDING-PAGE.jpg" {
                    array.append(lastComponent)
                }
                
            }
            completion(array)
            //completion(value)
        }
    }
    
//    func getTitles() -> String {
//        let data = ""
//        return data
//    }
    func getMangaList(from path: String, completion: @escaping (Array<String>, Array<String>)-> Void)  {
        
        extensions.getMangaList(from: path) { (value1, value2) in
            
            self.links = value1
            self.titles = value2
         //   print(self.titles)
          //  getTitles()
            completion(value1, value2)
            
        }
        
    }
//    
//    func getlist(from path: String) async-> Array<String> {
//        return await extensions.getlist(from: path)
//    }
    
    
}
