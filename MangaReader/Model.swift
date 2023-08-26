//
//  temp.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-08-18.
//


import CoreData

class Model {
    
    static let instance = Model()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {(description, error) in
            if let error = error {
                print("Error Loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("Saved successfully")
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
    
    func deleteFolder(folder: Folder) {
       
        context.delete(folder)
        
    }
    func deleteCover(cover: Cover) {
        
        context.delete(cover)
        
    }
    func deleteComic(comic: Comic) {
        
        context.delete(comic)
        
    }
}
