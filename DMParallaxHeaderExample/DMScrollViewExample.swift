//
//  DMScrollViewExample.swift
//  DMParallaxHeaderExample
//
//  Created by Dominic Miller on 9/11/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import UIKit
import DMParallaxHeader

class DMScrollViewExample: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var SpanichWhite : UIColor = UIColor(red: 0.996, green: 0.992, blue: 0.941, alpha: 1)
    
    var scrollView: DMScrollView!
    var table1: UITableView!
    var table2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parallax Header
        scrollView = DMScrollView(frame: .zero)
        scrollView.parallaxHeader.view = Bundle.main.loadNibNamed("StarshipHeader", owner: self, options: nil)?.first as? UIView // You can set the parallax header view from a nib.
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.mode = .fill
        scrollView.parallaxHeader.minimumHeight = 20
        view.addSubview(scrollView)
        
        table1 = UITableView()
        table1.dataSource = self;
        table1.backgroundColor = SpanichWhite
        scrollView.addSubview(table1)
        
        table2 = UITableView()
        table2.dataSource = self;
        table2.backgroundColor = SpanichWhite
        scrollView.addSubview(table2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.frame
        
        scrollView.frame = frame
        scrollView.contentSize = frame.size
        
        frame.size.width /= 2
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        table1.frame = frame
        
        frame.origin.x = frame.size.width
        table2.frame = frame
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier)
        }
        cell!.textLabel!.text = String(format: "Row \(indexPath.row * 10)")
        cell!.backgroundColor = SpanichWhite;
        return cell!
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("progress \(scrollView.parallaxHeader.progress)")
    }
}

