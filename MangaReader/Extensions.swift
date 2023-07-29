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
    @IBOutlet var imageView : UIImageView?
    
    let path:String = "https://asura.gg/dungeon-odyssey-chapter-57/"
    
    init() {
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
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            do {
                                 try data.write(to: self.getDocumentsDirectory().appendingPathComponent("image.jpg"))
                                 print("Image saved to: ",self.getDocumentsDirectory())
                             } catch {
                                 print(error)
                             }
            
        }
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
    
    struct Page: Identifiable, Hashable {
        var id: Int
        
        let url: String
       // let number: Int
    }
    
    
}
