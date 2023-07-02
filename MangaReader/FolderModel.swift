//
//  FolderModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-02.
//

import Foundation

struct FolderModel {
    private(set) var folders: Dictionary<String, Array<Int>>
    
    
    init() {
        folders = Dictionary<String, Array<Int>>()
        folders["test"] = []
    }
    
    mutating func addFolder(_ folder: String) {
        folders[folder] = Array<Int>()
    }
    mutating func addComic(new_comic comic: Int, add_to_folder folder: String) {
        folders[folder]?.append(comic)
    }
}
