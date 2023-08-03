//
//  Extensions.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-24.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup

class Extensions {
    var pages: Array<Page> = Array<Page>()
    var display_links: Array<String> = Array<String>()
    var onlineCovers: Array<onlineCover> = Array<onlineCover>()
    @IBOutlet var imageView : UIImageView?
    
  //  let path:String = "https://asura.gg/2226495089-my-daughter-is-a-dragon-chapter-0/"
    
    init() {
//        AF.request( path, method: .get, encoding: URLEncoding.httpBody).responseData  { [self] response in
//            switch response.result {
//            case .success(let value):
//                let data = value
//                let html: String = String(data:data, encoding: .utf8)!
//                do {
//                    let doc: Document = try SwiftSoup.parseBodyFragment(html)
//                    let images = try doc.getElementsByClass("rdminimal")
//                    var inx = 0
//                    for element in try images.select("img").array(){
//                        pages.append(Page(id: inx, url: try element.attr("src")) )
//                        inx += 1
//                    }
//                } catch Exception.Error(let type, let message) {
//                  //  print(message)
//                } catch {
//                  //  print("error")
//                }
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func getChapters(from path: String, completion: @escaping (Array<Page>)  -> Void) {
        AF.request( path, method: .get, encoding: URLEncoding.httpBody).responseData  { [self] response in
            switch response.result {
            case .success(let value):
                let data = value
                let html: String = String(data:data, encoding: .utf8)!
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(html)
                    let images = try doc.getElementsByClass("rdminimal")
                    var inx = 0
                    for element in try images.select("img").array(){
                        pages.append(Page(id: inx, url: try element.attr("src")) )
                        inx += 1
                    }
                    completion(pages)
                } catch Exception.Error(let type, let message) {
                  //  print(message)
                } catch {
                  //  print("error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from page: Page) {
        let url = URL(string:page.url)
        
        print("Download Started")
        getData(from: url!) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url!.lastPathComponent)
            print("Download Finished")
            do {
                try data.write(to: self.getDocumentsDirectory().appendingPathComponent(response?.suggestedFilename ?? url!.lastPathComponent))
                                 print("Image saved to: ",self.getDocumentsDirectory())
            } catch {
                print(error)
            }
        }
       
    }
    
    func downloadCover(from page: String, for title: String) {
        let url = URL(string:page)
        
        print("Download Cover Started")
        getData(from: url!) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
          //  print(response?.suggestedFilename ?? url!.lastPathComponent)
            print("Download Finished")
            do {
                try data.write(to: self.getDocumentsDirectory().appendingPathComponent(title + ".jpg"))
                                 print("Image saved to: ",self.getDocumentsDirectory())
            } catch {
                print(error)
            }
        }
       
    }
    
    func getMangaList(from path: String, completion: @escaping (Array<String>, Array<String>) -> Void)  {
        var links: Array<String> = []
        var titles: Array<String> = []
        AF.request( path, method: .get, encoding: URLEncoding.httpBody).responseData  { [self] response in
            switch response.result {
            case .success(let value):
                let data = value
                let html: String = String(data:data, encoding: .utf8)!
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(html)
                    let link_class = try doc.getElementsByClass("bsx")
                    let els: Elements = try link_class.select("a")
                   // print(try link_class.array())
                    for link in els.array(){
                        links.append(try link.attr("href"))
                    }
                    for title in els.array() {
                        titles.append(try title.attr("title"))
                    }
                    completion(links, titles)
                }
                
                catch Exception.Error(let type, let message) {
                  //  print(message)
                } catch {
                  //  print("error")
                }
     
            case .failure(let error):
                print(error)
            }
        }
    }

    func getDescription(from path: String, for title: String, completion: @escaping (String, Array<String>, Array<Int>, String) -> Void) {
        var description = ""
        var genre: Array<String> = []
        var chapters: Array<String> = []
        var chapter_num: Array<Int> = []
        var cover: String = ""
        AF.request( path, method: .get, encoding: URLEncoding.httpBody).responseData  { [self] response in
            switch response.result {
            case .success(let value):
                let data = value
                let html: String = String(data:data, encoding: .utf8)!
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(html)
                    let desc_class = try doc.getElementsByClass("entry-content entry-content-single")
                    
                    for element in try desc_class.select("p").array(){
                        description += try element.text()
                        description += " "
                    }
                    
                    let mgen = try doc.getElementsByClass("mgen")
                    for element in try mgen.select("a").array(){
                      
                        genre.append(try element.text())
                        
                    }

                    let chapter = try doc.getElementsByClass("eph-num")
                    let els: Elements = try chapter.select("a")
                    for el in els.array(){
                        chapters.append(try el.attr("href"))
                    }
                    
                    let chapter_class = try doc.getElementsByClass("eplister")
                    let data_num: Elements = try chapter_class.select("li")
                    for num in data_num.array() {
                        print(try num.attr("data-num"))
                        chapter_num.append(Int(try num.attr("data-num")) ?? 0)
                        
                    }
                   // print(chapter_num)
                    let cover_class = try doc.getElementsByClass("bixbox animefull")
                    let img: Elements = try cover_class.select("img")
                    cover = try img.attr("src")
                    print(cover)
                 //   print(genre)
                    onlineCovers.append(onlineCover(id: 0, title: title, links: path, description: description, genres: genre))
                    completion(description, chapters, chapter_num, cover)
                } catch Exception.Error(let type, let message) {
                  //  print(message)
                } catch {
                  //  print("error")
                }
               
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    private func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           
           return paths[0]
       }
    
    
    
    struct Page: Identifiable, Hashable {
        var id: Int
        
        let url: String
       // let number: Int
    }
    
    struct onlineCover: Identifiable {
        var id: Int
        var title: String
        var links: String
        var description: String = ""
        var genres: Array<String> = []
    }
    
    
}
