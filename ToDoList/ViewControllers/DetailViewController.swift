//
//  DetailViewController.swift
//  ToDoList
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(data: (item?.image?.data)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
