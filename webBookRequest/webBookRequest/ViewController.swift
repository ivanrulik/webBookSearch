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
    
    @IBOutlet weak var viewBook: UITextView!
    
    
    func sincro(input:UITextField){
        let ISBN: String = input.text!
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let url = NSURL(string : urls)
        let datos:NSData? = NSData(contentsOf: url! as URL)
        let texto = NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
        
        if (texto == "{}"){
            viewBook.text = "El ISBN ingresado fue mal ingresado o no existe"
        }
        else {
            viewBook.text = texto as String?
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func bookSearch(_ sender: Any) {
        
        sincro(input: inputISBN)
    }
    @IBAction func clearViewBook(_ sender: Any) {
        viewBook.text = "Book retrieved information"
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        inputISBN.resignFirstResponder()
    }
    

}

