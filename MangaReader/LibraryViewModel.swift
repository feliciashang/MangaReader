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
    
    var chapterList: Dictionary<String, Array<Int>> {
        return model.chapterList
    }
    
    func findComic(chapterId id: Int) -> Model.Comic{
        return model.findComic(comicId: id)
    }
    
    var timestamps: Dictionary<Int, String> {
        print(model.timestamps)
        return model.timestamps
    }
    
    func choose(_ comic: Model.Comic) ->Void {
        model.choose(comic)
    }
//    func findChapter(cover cover: String) -> Model.Comic{
//        return model.findComic(comicId: id)
//    }
}
