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
    private(set) var downloadPages: Dictionary<Int, String> = Dictionary<Int, String>()
    @IBOutlet var imageView : UIImageView?
    
    let path:String = "https://asura.gg/2226495089-my-daughter-is-a-dragon-chapter-0/"
    
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
    
    func downloadImage(from page: Page) -> String {
        let url = URL(string:page.url)
        var filename = ""
        print("Download Started")
        getData(from: url!) { data, response, error in
            filename = response?.suggestedFilename ?? url!.lastPathComponent
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url!.lastPathComponent)
            print("Download Finished")
            do {
                try data.write(to: self.getDocumentsDirectory().appendingPathComponent(response?.suggestedFilename ?? url!.lastPathComponent))
                                 print("Image saved to: ",self.getDocumentsDirectory())
                self.downloadPages[page.id] = response?.suggestedFilename ?? url!.lastPathComponent
           //     print(self.downloadPages)
                filename = self.downloadPages[page.id]!
            } catch {
                print(error)
            }
        }
        return filename
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
