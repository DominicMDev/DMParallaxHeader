//
//  UITableViewExample.swift
//  DMParallaxHeaderExample
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import DMParallaxHeader

class UITableViewExample: UITableViewController, DMParallaxHeaderDelegate {
    
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parallax Header
        tableView.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        tableView.parallaxHeader.height = 300
        tableView.parallaxHeader.mode = .fill
        tableView.parallaxHeader.minimumHeight = 20
        tableView.parallaxHeader.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = String(format: "Height \(indexPath.row * 10)")
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.parallaxHeader.height = CGFloat(indexPath.row * 10)
    }
    
    // MARK: - Parallax header delegate
    
    func parallaxHeaderDidScroll(_ parallaxHeader: DMParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
}
