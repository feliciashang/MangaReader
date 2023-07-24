//
//  FolderModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-02.
//

import Foundation

struct FolderModel {
    private(set) var folders: Dictionary<String, Array<String>>
    
    
    init() {
        folders = Dictionary<String, Array<String>>()
        folders["test"] = []
    }
    
    mutating func addFolder(_ folder: String) {
        folders[folder] = Array<String>()
    }
    mutating func addComic(new_comic comic: String, add_to_folder folder: String) {
        if (folders[folder] != nil) {
            folders[folder]!.append(comic)
        }
        print(folders)
    }
}
