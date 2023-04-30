//
//  DrawViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 12/2/22.
//

import UIKit

class DrawViewController: UIViewController {
    @IBOutlet var drawView: DrawView!
    var item: NumQuestion!
    var imageStore: ImageStore!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        imageStore.setImage(drawView.asImage(), forKey: item.imageKey)
    }
}
