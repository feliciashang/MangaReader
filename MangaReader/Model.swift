//
//  Model.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import Foundation
import UIKit
import CoreData

class Model {
  //  private(set) var comics: Array<Comic>
  //  private(set) var covers: Array<Cover>
  //  private(set) var folders: Dictionary<String, Array<String>>
    var mal: Tracker = Tracker()
//    private(set) var chapterList: Dictionary<String, Array<Int>>
    private(set) var timestamps: Dictionary<Int, String>
    let container: NSPersistentContainer
    @Published var savedComics: [Comic] = []
    @Published var savedFolders: [Folder] = []
    @Published var savedCovers: [Cover] = []
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores{( description, error) in
            if let error = error {
                print("ERROR-LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        timestamps = Dictionary<Int, String>()
        fetchComics()
        fetchCovers()
        fetchFolders()
  //      addFolder(name: "ALL", cover: "")
        
//        comics = Array<Comic>()
//        covers = Array<Cover>()
//        folders = Dictionary<String, Array<String>>()
//
        
//        folders["ALL"] = []
//        folders["ALL"]!.append("Ending Maker")
//        folders["ALL"]!.append("Archmage Transcending Through Regression")
//        covers.append(Cover(id:1, cover: "Ending Maker", chapters:[2,3,4], description: "There are two people who were obssessed with the game, Legend of Heroes 2, and spent thousands of hours on it.The forever number one, Kang Jinho, and the forever number two, Hong Yoohee.One day, when they woke up, they had been reincarnated into their characters within the game…“Hey… You too?”“Hey… Me too!”Legend of Heroes 2’s ending is the end of the human world.However, since there are two of them instead of just one, and not just any two, but the server’s rank one and rank two, things could be different.The journey of the veteran gamers to accomplish the happy ending starts now!", genre: ["Romance", "Video games", "Action"]))
//        covers.append(Cover(id:2, cover: "Archmage Transcending Through Regression", chapters:[1], description: "Mikhail Walpurgis, the world’s only 9th-circle Archmage, fell in battle due to a damned hero, and managed to cast one final advanced magic spell, <TIME REVERSAL>. As time rewound, he regressed to 20 years ago.“Fine. I’ll just become the hero instead.”", genre: ["Adventure", "Regression", "Action", "Fantasy"]))
//        comics.append(Comic(id: 1, cover: "Archmage Transcending Through Regression", chapter: 1, content: "Archmage Transcending Through Regression 1"))
//        comics.append(Comic(id: 2, cover: "Ending Maker", chapter: 3, content: "endingmaker_3"))
//        comics.append(Comic(id: 3, cover: "Ending Maker", chapter: 1, content: "endingmaker_1"))
//        comics.append(Comic(id: 4, cover: "Ending Maker", chapter: 2, content: "endingmaker_2"))
//        sortChapter(cover: "Ending Maker")
        
    }
    
    func fetchComics() {
        let request = NSFetchRequest<Comic>(entityName: "Comic")
        
        do {
            savedComics = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addComic(filename: [String], downloaded: Bool, content: String, chapter: Int, cover: Cover) {
        let newComic = Comic(context: container.viewContext)
        newComic.id = Int32(savedComics.count + 1)
        newComic.filename = filename
        newComic.downloaded = downloaded
        newComic.content = content
        newComic.chapter = Int32(chapter)
        newComic.cover = cover
        
        saveComic()
    }
    
    func saveComic() {
        do {
            try container.viewContext.save()
            fetchComics()
        } catch let error {
            print("Eror saving, \(error)")
        }
    }
    
    func fetchFolders() {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        
        do {
            savedFolders = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addFolder(name: String) {
        let newFolder = Folder(context: container.viewContext)
        newFolder.name = name
       
        for folder in savedFolders {
            if folder.name == name {
                return
            }
        }
      //  newFolder.covers?.adding(covers)
        saveFolder()
    }
    func saveFolder() {
        do {
            try container.viewContext.save()
            fetchFolders()
        } catch let error {
            print("Eror saving, \(error)")
        }
    }
    
   
    
    func fetchCovers() {
        let request = NSFetchRequest<Cover>(entityName: "Cover")
        
        do {
            savedCovers = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addCovers(genre: [String], downloaded: Bool, descri: String, cover: String, folder: Folder) {
        let newCover = Cover(context: container.viewContext)
        newCover.id = Int16(savedCovers.count + 1)
        newCover.genre = genre
        newCover.downloaded = downloaded
        newCover.descri = descri
        newCover.cover = cover
        newCover.folder = folder
   //     newCover.addToChapters(chapters)
        
        
        for cover in savedCovers {
            if cover.cover == newCover.cover {
                return
            }
        }
        
        saveFolder()
    }
    func saveCover() {
        do {
            try container.viewContext.save()
            fetchCovers()
        } catch let error {
            print("Eror saving, \(error)")
        }
    }
    
//    func addToFolder(_ folder: String) {
//        folders[folder] = Array<String>()
//    }
    
    // replaced by addFolder
//    func addComic(new_comic comic: String, add_to_folder folder: String) {
//        if (folders[folder] != nil) {
//            folders[folder]!.append(comic)
//        }
//      //  print(folders)
//    }
    
    //replaced by addFOlder, addComic, addCover
//    func addChapter(cover: String, chapter: Int, description: String, genre: Array<String>, filename: Array<String>) {
//        if let index = covers.firstIndex(where: { $0.cover == cover }) {
//            self.comics.append(Comic(id: comics.count + 1, cover: cover, chapter: chapter, content: "", downloaded: true, filename: filename))
//            covers[index].chapters.append(comics.count )
//
//            }
//
//        else {
//            self.covers.append(Cover(id: covers.count + 1, cover: cover, chapters:[comics.count+1], description: description, downloaded: true, genre: genre))
//            self.folders["ALL"]!.append(cover)
//            self.comics.append(Comic(id: comics.count + 1, cover: cover, chapter: chapter, content: "", downloaded: true, filename: filename))
//        }
//        print(self.covers)
//        print(self.comics)
////        print("done")
//    }
    func findComic(comicId id: Int) -> Comic {
//        print("hi")
//        print(id)
//        print(comics)
        
        for comic in savedComics{
            if comic.id == id {
                return comic
            }
        }
        print("error finding comic")
        return savedComics[0]
      //  return Comic(id: 1, cover: "Cover", chapter: 1, content: "manga")
        
    }
    func findCover(_ cover: String) -> Cover {
        for comic in savedCovers{
            if comic.cover == cover {
                return comic
            }
        }
        print("error finding cover")
        return savedCovers[0]
//        return Cover(id:1, cover: "Ending Maker", chapters:[2,3,4], description: "There are two people who were obssessed with the game, Legend of Heroes 2, and spent thousands of hours on it.The forever number one, Kang Jinho, and the forever number two, Hong Yoohee.One day, when they woke up, they had been reincarnated into their characters within the game…“Hey… You too?”“Hey… Me too!”Legend of Heroes 2’s ending is the end of the human world.However, since there are two of them instead of just one, and not just any two, but the server’s rank one and rank two, things could be different.The journey of the veteran gamers to accomplish the happy ending starts now!", genre: ["romance", "video gamesssss", "action"])
        
    }
//    mutating func sortChapter(cover comic: String) {
//     //   chapterList[comic]?.sort(by: >)
//    }
    
     func choose(_ comic: Comic) {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        timestamps[Int(comic.id)] = dateString
        print(timestamps)
         mal.updateManga(name: (comic.cover?.cover)!, chapter: Int(comic.chapter))
        
    }
    func addTracker(name: String) {
        mal.addManga(name: name)
    }
    private func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           
           return paths[0]
       }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = self.getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
   
//    struct Cover: Identifiable {
//        var id: Int
//        var cover: String
//        var chapters: Array<Int>
//        var description: String
//        var downloaded: Bool = false
//        var genre: Array<String>
//    }
//    struct Comic: Identifiable {
//        var id: Int
//        var cover: String
//        var chapter: Int
//        var content: String
//        var downloaded: Bool = false
//        var filename: Array<String> = []
//    }
}
