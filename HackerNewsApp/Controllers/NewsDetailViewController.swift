//
//  NewsDetailViewController.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 24/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction private func close() {
        navigationController?.popViewController(animated: true)
    }

}
