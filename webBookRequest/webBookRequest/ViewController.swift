//
//  ViewController.swift
//  webBookRequest
//
//  Created by Ivan Rulik on 7/20/20.
//  Copyright © 2020 Ivan Rulik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputISBN: UITextField!
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelAutores: UILabel!
    
    @IBOutlet weak var uiImageViewCover: UIImageView!
    
    
    func sincro(input:UITextField, completion:  @escaping (String?,String?,String?, Error?) -> Void){
        let ISBN: String = input.text!
        let ISBNKey: String = "ISBN:"+ISBN
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let url = URL(string : urls)!
        
        URLSession.shared.dataTask(with: url){ (jsonData, _, error) in
            if let error = error {
                print("Error getting book: \(error)")
                return
            }
            guard let bookData = jsonData else {
                print("Error retrieving data from data task")
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: bookData, options: JSONSerialization.ReadingOptions.mutableLeaves)
                print(json)
                let dico1 = json as! NSDictionary
                var title = ""
                var author = ""
                var cover = ""
                if dico1[ISBNKey] == nil {
                    
                }
                else{
                    let dico2 = dico1[ISBNKey] as! NSDictionary
                    title = dico2["title"] as! NSString as String
                    if dico2["cover"] == nil {
                         print("there is no cover")
                    }
                    else{
                        let dico3 = dico2["cover"] as! NSDictionary
                        cover = dico3["medium"] as! String
                    }
                    let dico4 = dico2["authors"] as! Array<Any>
                    let numAuthors = dico4.count as Int
                    for index in 0...(numAuthors-1){
                        let author1 = dico4[index] as! NSDictionary
                        let tempauthor = author1["name"] as! String
                        if (index > 0){
                            author = author + ", " + tempauthor
                        }
                        else{
                            author = tempauthor
                        }
                    }
                    print(title+" "+author+"\n"+cover+" # of authors \(numAuthors)")
                }
                completion(title,author,cover,nil)
            }
            catch{
                print("Error decoding data to type book : \(error)")
                completion(nil,nil,nil,error)
            }
        }.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func bookSearch(_ sender: Any) {
        
        sincro(input: inputISBN, completion:{ title,author,cover, error in
            DispatchQueue.main.async {
                if(title == ""){
                    self.labelTitulo.text = "The ISBN does not exist"
                    self.labelAutores.text = "or it wast typed wrong"
                }
                else{
                    self.labelTitulo.text = title
                    self.labelAutores.text = author
                    if cover == ""{
                        
                    }
                    else{
                        let coverUrl = URL(string: cover!)
                        guard let bookCoverData = try? Data(contentsOf: coverUrl!) else{return}
                        self.uiImageViewCover.image = UIImage(data: bookCoverData)
                        }
                    }
            }
        })
    }

    @IBAction func clearBtn(_ sender: Any) {
        self.labelTitulo.text = "Titulo"
        self.labelAutores.text = "Autores"
        self.uiImageViewCover.image = nil
    }
    
    
    
    @IBAction func backgroundTap(_ sender: Any) {
        inputISBN.resignFirstResponder()
    }
    
    
    

}

