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
        return model.Folder.folders
    }
//    func findChapter(cover cover: String) -> Model.Comic{
//        return model.findComic(comicId: id)
//    }
}
