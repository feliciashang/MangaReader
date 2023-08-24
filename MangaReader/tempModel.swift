//
//  Model.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import Foundation
import UIKit
import CoreData

class tempModel: ObservableObject {
    let manager = temp.instance
    @Published var savedComics: [Comic] = []
    @Published var savedFolders: [Folder] = []
    @Published var savedCovers: [Cover] = []
    @Published var savedHistory: [History] = []
    var mal: Tracker = Tracker()
  //  private(set) var timestamps: Dictionary<Int, String>
    init() {
   //     timestamps = Dictionary<Int, String>()
        fetchCovers()
        fetchFolders()
        addFolder(name: "ALL")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addStuff(genre: ["Adventure"], downloaded: false, descri: "fefefef", name: "Ending Maker", filename: [], content: "endingmaker_3", chapter: 1)
        }
        
        fetchComics()
        fetchHistory()
     //   timestamps[1] = "aoifjaeoijf"
    }
    
    func fetchHistory() {
        let request = NSFetchRequest<History>(entityName: "History")

        do {
            savedHistory = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addHistory(id: Int32, date: String) {
        for history in savedHistory {
            if history.id == id {
                return
            }
        }
        let newHistory = History(context: manager.context)
        newHistory.id = id
        newHistory.time = date
        print("save history")
        save()
    }
    
    func updateHistory(history: History, newTime: String) {
        let existingHistory = history
        existingHistory.time = newTime
        save()
    }
    
    func getHistoryByID(id: Int32) -> History? {
        
        for history in savedHistory {
            if history.id == id {
                return history
            }
        }
        
        return nil
    }
    
    func fetchFolders() {
        let request = NSFetchRequest<Folder>(entityName: "Folder")

        do {
            savedFolders = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    func deleteEverything() {
        for folder in savedFolders {
            manager.deleteFolder(folder: folder)
        }
        for cover in savedCovers {
            manager.deleteCover(cover: cover)
        }
        for comic in savedComics {
            manager.deleteComic(comic: comic)
        }
        save()


    }
    
    func addToFolder(addTo: Folder, cover: Cover) {
        let newFolder = addTo
        newFolder.addToCovers(cover)
        print("save folder")
        save()
    }
    
    func addFolder(name: String) {
        for folder in savedFolders {
            if folder.name == name {
                return
            }
        }
        let newFolder = Folder(context: manager.context)
        newFolder.name = name
        print("save folder")
        save()
    }
    
    
    func save() {
      //  savedFolders.removeAll()
       // savedCovers.removeAll()
       // savedComics.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.save()
            self.fetchFolders()
            self.fetchCovers()
            self.fetchComics()
            self.fetchHistory()
        }
    }
    
    func fetchComics() {
        let request = NSFetchRequest<Comic>(entityName: "Comic")
        
        do {
            savedComics = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }

    func addComic(filename: [String], downloaded: Bool, content: String, chapter: Int, cover: String) {
//        for comic in savedComics {
//            if comic.filename  == filename {
//                return
//            }
//        }
        let newComic = Comic(context: manager.context)
        newComic.id = Int32(savedComics.count + 1)
        newComic.filename = filename
        newComic.downloaded = downloaded
        newComic.content = content
        newComic.chapter = Int32(chapter)
        newComic.cover = getCover(name: cover)
        print("save comic")
        save()
        print(savedComics)
    }
    
    func fetchCovers() {
        let request = NSFetchRequest<Cover>(entityName: "Cover")

        do {
            savedCovers = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
//
    func addCovers(genre: [String], downloaded: Bool, descri: String, name: String) {
        for cover in savedCovers {
            if cover.cover == name {
                return
            }
        }
        let newCover = Cover(context: manager.context)
        newCover.id = Int16(savedCovers.count + 1)
        newCover.genre = genre
        newCover.downloaded = downloaded
        newCover.descri = descri
        newCover.cover = name
      //  newCover.addToFolder(getFolder(name: "ALL") ?? savedFolders[0])
        newCover.folder = getFolder(name: "ALL")
        print("save cover")
        save()
        print(savedCovers)
    }
    
    func addStuff(genre: [String], downloaded: Bool, descri: String, name: String, filename: [String], content: String, chapter: Int) {
        addCovers(genre: genre, downloaded: downloaded, descri: descri, name: name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addComic(filename: filename, downloaded: downloaded, content: content, chapter: chapter, cover: name)
        }
    }
    
    func getFolder(name: String) -> Folder? {
        for folder in savedFolders {
            if folder.name == name {
                return folder
            }
        }
        return nil
    }
    
    func getCover(name: String) -> Cover? {
        for cover in savedCovers {
            if cover.cover == name {
                return cover
            }
        }
        return nil
    }
    
    func getCoverfromFolder(folder: String) -> [Cover] {
        
        for f in savedFolders {
            if f.name == folder {
                return (f.covers?.allObjects as? [Cover])!
            }
        }
        return savedCovers
    }
    
    func getComicfromID(id: Int) -> Comic {
        for comic in savedComics {
            if comic.id == id {
                return comic
            }
        }
        return savedComics[0]
    }
    
    func choose(_ comic: Comic) {
       let date = Date()
       let df = DateFormatter()
       df.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let dateString = df.string(from: date)
      // timestamps[Int(comic.id)] = dateString
      // print(timestamps)
        if let existinghistory = getHistoryByID(id: comic.id) {
            updateHistory(history: existinghistory, newTime: dateString)
        } else {
            addHistory(id: comic.id, date: dateString)
        }
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
    
   //     newCover.addToChapters(chapters)
//
//
//        for cover in savedCovers {
//            if cover.cover == newCover.cover {
//                return
//            }
//        }
//
//
//    }
//    func saveCover() {
//        do {
//            try manager.context.save()
//            fetchCovers()
//        } catch let error {
//            print("Eror saving, \(error)")
//        }
//    }
//
}
