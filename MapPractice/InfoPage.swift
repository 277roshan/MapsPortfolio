//
//  InfoPage.swift
//  MapPractice
//
//  Created by Roshan Thapaliya on 3/1/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController{
    
    @IBOutlet weak var titleSet: UILabel!
    var cafe_title: String?
    
    
    override func viewDidLoad() {
        print(cafe_title)
        titleSet.text = cafe_title
    }
    

}

