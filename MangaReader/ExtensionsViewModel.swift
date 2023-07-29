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
    
    
    var pages:Array<Extensions.Page> {
        return extensions.pages
    }
    
    
    var firstpage: Extensions.Page {
        return extensions.pages[0]
    }
    
    func downloadImage(from url: URL){
        extensions.downloadImage(from: url)
    }
    
    func load(fileName: String) -> UIImage? {
        extensions.load(fileName: fileName)
    }
}
