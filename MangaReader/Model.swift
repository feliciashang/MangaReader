//
//  Model.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import Foundation


struct Model {
    private(set) var comics: Array<Comic>
    private(set) var covers: Array<Cover>
    private(set) var chapterList: Dictionary<String, Array<Int>>
    private(set) var timestamps: Dictionary<Int, String>
    init() {
        comics = Array<Comic>()
        covers = Array<Cover>()
        chapterList = Dictionary<String, Array<Int>>()
        
        timestamps = Dictionary<Int, String>()
        covers.append(Cover(id:1, cover: "Ending Maker", chapters:[2,3,4], description: "There are two people who were obssessed with the game, Legend of Heroes 2, and spent thousands of hours on it.The forever number one, Kang Jinho, and the forever number two, Hong Yoohee.One day, when they woke up, they had been reincarnated into their characters within the game…“Hey… You too?”“Hey… Me too!”Legend of Heroes 2’s ending is the end of the human world.However, since there are two of them instead of just one, and not just any two, but the server’s rank one and rank two, things could be different.The journey of the veteran gamers to accomplish the happy ending starts now!", genre: ["Romance", "Video games", "Action"]))
        comics.append(Comic(id: 1, cover: "Cover", chapter: 1, content: "manga"))
        chapterList["Cover"] = Array<Int>()
        chapterList["Cover"]?.append(1)
        comics.append(Comic(id: 2, cover: "Ending Maker", chapter: 3, content: "endingmaker_3"))
        chapterList["Ending Maker"] = Array<Int>()
        chapterList["Ending Maker"]?.append(2)
        comics.append(Comic(id: 3, cover: "Ending Maker", chapter: 1, content: "endingmaker_1"))
        chapterList["Ending Maker"]?.append(3)
        comics.append(Comic(id: 4, cover: "Ending Maker", chapter: 2, content: "endingmaker_2"))
        chapterList["Ending Maker"]?.append(4)
        sortChapter(cover: "Ending Maker")
        
    }
    
    func findComic(comicId id: Int) -> Comic {
        for comic in comics{
            if comic.id == id {
                return comic
            }
        }
        print("error")
        return Comic(id: 1, cover: "Cover", chapter: 1, content: "manga")
        
    }
    func findCover(_ cover: String) -> Cover {
        for comic in covers{
            if comic.cover == cover {
                return comic
            }
        }
        print("error")
        return Cover(id:1, cover: "Ending Maker", chapters:[2,3,4], description: "There are two people who were obssessed with the game, Legend of Heroes 2, and spent thousands of hours on it.The forever number one, Kang Jinho, and the forever number two, Hong Yoohee.One day, when they woke up, they had been reincarnated into their characters within the game…“Hey… You too?”“Hey… Me too!”Legend of Heroes 2’s ending is the end of the human world.However, since there are two of them instead of just one, and not just any two, but the server’s rank one and rank two, things could be different.The journey of the veteran gamers to accomplish the happy ending starts now!", genre: ["romance", "video gamesssss", "action"])
        
    }
    mutating func sortChapter(cover comic: String) {
        chapterList[comic]?.sort(by: >)
    }
    
    mutating func choose(_ comic: Comic) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        timestamps[comic.id] = dateString
        print(timestamps)
    }
   
    struct Cover: Identifiable {
        var id: Int
        var cover: String
        var chapters: Array<Int>
        var description: String
        var genre: Array<String>
    }
    struct Comic: Identifiable {
        var id: Int
        var cover: String
        var chapter: Int
        var content: String
    }
}
