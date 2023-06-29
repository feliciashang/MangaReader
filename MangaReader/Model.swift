//
//  Model.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import Foundation


struct Model {
    private(set) var comics: Array<Comic>
    private(set) var chapterList: Dictionary<String, Array<Int>>
    private(set) var timestamps: Dictionary<Int, String>
    init() {
        comics = Array<Comic>()
        
        chapterList = Dictionary<String, Array<Int>>()
        timestamps = Dictionary<Int, String>()
        
        comics.append(Comic(id: 1, cover: "cover", chapter: 1, content: "manga"))
        chapterList["cover"] = Array<Int>()
        chapterList["cover"]?.append(1)
        comics.append(Comic(id: 2, cover: "endingmaker_cover", chapter: 3, content: "endingmaker_3"))
        chapterList["endingmaker_cover"] = Array<Int>()
        chapterList["endingmaker_cover"]?.append(2)
        comics.append(Comic(id: 3, cover: "endingmaker_cover", chapter: 1, content: "endingmaker_1"))
        chapterList["endingmaker_cover"]?.append(3)
        comics.append(Comic(id: 4, cover: "endingmaker_cover", chapter: 2, content: "endingmaker_2"))
        chapterList["endingmaker_cover"]?.append(4)
        sortChapter(cover: "endingmaker_cover")
        
    }
    
    func findComic(comicId id: Int) -> Comic {
        for comic in comics{
            if comic.id == id {
                return comic
            }
        }
        print("error")
        return Comic(id: 1, cover: "cover", chapter: 1, content: "manga")
        
    }
    mutating func sortChapter(cover comic: String) {
        chapterList[comic]?.sort(by: >)
    }
    
    mutating func choose(comic comic: Comic) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        timestamps[comic.id] = dateString
        print(timestamps)
    }
    
    struct Comic: Identifiable {
        var id: Int
        var cover: String
        var chapter: Int
        var content: String
    }
}
