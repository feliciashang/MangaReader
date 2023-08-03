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
