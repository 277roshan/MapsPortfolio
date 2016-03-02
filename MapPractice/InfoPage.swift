//
//  InfoPage.swift
//  MapPractice
//
//  Created by Roshan Thapaliya on 3/1/16.
//  Copyright © 2016 Roshan Thapaliya. All rights reserved.
//

import UIKit
import MapKit


class DetailViewController: UIViewController{
    
    @IBOutlet weak var titleSet: UILabel!
    var cafe_titl: MKAnnotation?
    
    
    override func viewDidLoad() {
        titleSet.text = cafe_titl!.title!
    }
    

}

