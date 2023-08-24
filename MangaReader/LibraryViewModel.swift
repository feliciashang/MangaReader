//
//  LibraryViewModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-27.
//

import SwiftUI
import CoreData

class LibraryViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores{( description, error) in
            if let error = error {
                print("ERROR-LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
    }
    private static func createModel() -> Model {
        Model()
    }
    
    @Published private var model: Model = LibraryViewModel.createModel()
    
    
    var comics:Array<Comic> {
        return model.savedComics
    }
    
//    var chapterList: Dictionary<String, Array<Int>> {
//        return model.chapterList
//    }
    
    var coverList: Array<String> {
        var output = Array<String>()
        for item in model.savedCovers {
            output.append(item.cover!)
        }
        return output
    }
    
    func findComic(chapterId id: Int) -> Comic{
        return model.findComic(comicId: id)
    }
    func findCover(_ cover: String) -> Cover{
        return model.findCover(cover)
    }
    
    var timestamps: Dictionary<Int, String> {
        print(model.timestamps)
        return model.timestamps
    }
    
    var covers:Array<Cover> {
        return model.savedCovers
    }
    
    func choose(_ comic: Comic) ->Void {
        model.choose(comic)
    }
    
    var folders: Array<Folder> {
        return model.savedFolders
    }
    
    func addTracker(name: String) {
        model.addTracker(name: name)
    }
    
    func addFolder(add_to_folder folder: String) {
        model.addFolder(name: folder)
    }
    
//    func addFolder(_ folder: String) {
//        model.addFolder(folder)
//    }
    
    func addChapter(cover: Cover, chapter: Int, description: String, genre: Array<String>, filename: [String]) {
        model.addComic(filename: filename, downloaded: true, content:"" , chapter: chapter, cover: cover)
    }
    
    func addCovers(genre: [String], downloaded: Bool, descri: String, cover: String, folder: Folder) {
        model.addCovers(genre: genre, downloaded: downloaded, descri: descri, cover: cover, folder: folder)
    }
    
    
    
    func load(fileName: String) -> UIImage? {
        model.load(fileName: fileName)
    }
//    func findChapter(cover cover: String) -> Model.Comic{
//        return model.findComic(comicId: id)
//    }
}
