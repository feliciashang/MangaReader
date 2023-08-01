//
//  LibraryViewModel.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-27.
//

import SwiftUI

class LibraryViewModel: ObservableObject {
    
    private static func createModel() -> Model {
        Model()
    }
    
    @Published private var model: Model = LibraryViewModel.createModel()
    
    
    var comics:Array<Model.Comic> {
        return model.comics
    }
    
//    var chapterList: Dictionary<String, Array<Int>> {
//        return model.chapterList
//    }
    
    var coverList: Array<String> {
        var output = Array<String>()
        for item in model.covers {
            output.append(item.cover)
        }
        return output
    }
    
    func findComic(chapterId id: Int) -> Model.Comic{
        return model.findComic(comicId: id)
    }
    func findCover(_ cover: String) -> Model.Cover{
        return model.findCover(cover)
    }
    
    var timestamps: Dictionary<Int, String> {
        print(model.timestamps)
        return model.timestamps
    }
    
    var covers:Array<Model.Cover> {
        return model.covers
    }
    
    func choose(_ comic: Model.Comic) ->Void {
        model.choose(comic)
    }
    
    var folders: Dictionary<String, Array<String>> {
        return model.folders
    }
    
    func addTracker(name: String) {
        model.addTracker(name: name)
    }
    
    func addComic(new_comic comic: String, add_to_folder folder: String) {
        model.addComic(new_comic: comic, add_to_folder: folder)
    }
    
    func addFolder(_ folder: String) {
        model.addFolder(folder)
    }
    
    func addChapter(cover: String, chapter: Int, description: String, genre: Array<String>, filename: Array<String>) {
        model.addChapter(cover: cover, chapter: chapter, description: description, genre: genre, filename: filename)
    }
    
    func load(fileName: String) -> UIImage? {
        model.load(fileName: fileName)
    }
//    func findChapter(cover cover: String) -> Model.Comic{
//        return model.findComic(comicId: id)
//    }
}
