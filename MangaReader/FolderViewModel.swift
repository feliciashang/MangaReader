//
//  FolderViewModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-02.
//

import SwiftUI

class FolderViewModel: ObservableObject {
    
    private static func createModel() -> FolderModel {
        FolderModel()
    }
    
    @Published private var folderModel: FolderModel = FolderViewModel.createModel()
    
    var folders: Dictionary<String, Array<String>> {
    //    print(folderModel.folders["Master"])
        return folderModel.folders
    }
    
    func addFolder(_ folder: String) {
        folderModel.addFolder(folder)
       // print(folders)
    }
    
    func addComic(new_comic comic: String, add_to_folder folder: String) {
        folderModel.addComic(new_comic: comic, add_to_folder: folder)
    }
    
}
