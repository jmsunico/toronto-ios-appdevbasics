//
//  TableViewController.swift
//  image-processor
//
//  Created by José-María Súnico on 20160712.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit




class TableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
	@IBOutlet weak var myTableView: UITableView!
	//DATASOURCE SAMPLE
	let filters = ["Red", "Blue", "Green", "Yellow"]
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		myTableView.dataSource = self
		myTableView.delegate = self
		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filters.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
			cell.textLabel?.text = filters[indexPath.row]
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print(filters[indexPath.row])
	}
}
