//
//  ViewController.swift
//  image-processor
//
//  Created by José-María Súnico on 20160624.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
	
	@IBOutlet weak var sourceImageView: UIImageView!
	@IBOutlet var SecondMenu: UIView!
	
	@IBAction func filterButton(sender: UIButton) {
		if (sender.selected){
			hideSecondMenu()
			sender.selected = false
		} else{
			showSecondMenu()
			sender.selected = true
		}
	}
	
	func showSecondMenu(){
		view.addSubview(SecondMenu)
		let bottomConstraint = SecondMenu.bottomAnchor.constraintEqualToAnchor(firstMenu.topAnchor)
		let leftConstraint = SecondMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
		let rightConstraint = SecondMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
		let heightConstraint = SecondMenu.heightAnchor.constraintEqualToConstant(44)
		NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
		view.layoutIfNeeded()
		UIView.animateWithDuration(0.5){
			self.SecondMenu.alpha = 1
		}
	
	}
	
	
	func hideSecondMenu(){
		UIView.animateWithDuration(0.5, animations: {
			self.SecondMenu.alpha = 0

			
		}) {_ in
			self.SecondMenu.removeFromSuperview()
		
		}
	}
	
	
	
	@IBOutlet weak var firstMenu: UIStackView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.sourceImageView.image = UIImage(named: "scenery")
		
		SecondMenu.translatesAutoresizingMaskIntoConstraints = false
		SecondMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
		
		
		
	
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}



/*		let image = UIImage(named: "sample")
let complextring = "   ,something,   greyscale 2 3  ,   Bright +50,   Greyscale,Scale 2,    , Contrast,,,  ,"
workflowInterface(complextring)
let myPipeline = Workflow(withSequence: workflowInterface(complextring))

if myPipeline != nil {
print("Could create turn_greyscale pipeline")
if myPipeline!.somethingWentWrong{
print("...but there were some problems: check spelling...")
}
myPipeline!.apply(image)
} else{
print("Could not create pipeline")
}
let result = myPipeline!.result

*/
	