//
//  ViewController.swift
//  image-processor
//
//  Created by José-María Súnico on 20160624.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var firstMenu: UIStackView!
	@IBOutlet weak var SecondMenu: UIView!
	@IBOutlet weak var originalImageView: UIImageView!
	@IBOutlet weak var filteredImageView: UIImageView!
	
	@IBOutlet weak var onNewLabel: UIButton!
	@IBOutlet weak var onShareLabel: UIButton!
	@IBOutlet weak var filterButtonLabel: UIButton!
	@IBOutlet weak var compareButton: UIButton!
	
	@IBOutlet weak var filterSlider: UISlider!
	@IBOutlet weak var sliderValue: UILabel!
	
	var currentFilter = "Identity"
	var currentParameter = "1"

	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		dismissViewControllerAnimated(true, completion: nil)
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
			self.originalImageView.image = image
			softReset()
		}
	}
	

	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func onShare(sender: AnyObject) {
		hideSecondMenu()
		self.filterButtonLabel.selected = false
		let activityController = UIActivityViewController(activityItems: [originalImageView.image!], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion: nil)
	}
	
	@IBAction func onNewPhoto(sender: AnyObject) {
		hideSecondMenu()
		self.filterButtonLabel.selected = false
		let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
		actionSheet.addAction((UIAlertAction(title: "Camera", style: .Default, handler: { action in
			self.showCamera()
			})))
		actionSheet.addAction((UIAlertAction(title: "Album", style: .Default, handler: { action in
			self.showAlbum()
		})))
		actionSheet.addAction((UIAlertAction(title: "Cancel", style: .Default, handler: { action in
			//
		})))
			self.presentViewController(actionSheet, animated: true, completion: nil)
	}
	
	func showCamera(){
		let cameraPicker = UIImagePickerController()
		cameraPicker.delegate = self
		cameraPicker.sourceType = .Camera
		presentViewController(cameraPicker, animated: true, completion: nil)
	}
	
	func showAlbum(){
		let cameraPicker = UIImagePickerController()
		cameraPicker.delegate = self
		cameraPicker.sourceType = .PhotoLibrary
		presentViewController(cameraPicker, animated: true, completion: nil)
	}
	
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
		let heightConstraint = SecondMenu.heightAnchor.constraintEqualToConstant(88)
		NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
		view.layoutIfNeeded()

		UIView.animateWithDuration(0.5){
			self.SecondMenu.alpha = 0.75
		}
	
	}
	
	func hideSecondMenu(){
		UIView.animateWithDuration(0.5, animations: {
			self.SecondMenu.alpha = 0
		}) {_ in
			self.SecondMenu.removeFromSuperview()
		}
		
		self.currentFilter = "Identity"
		self.currentParameter = "1"
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.filterSlider.enabled = false
		self.filterButtonLabel.selected = false
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		onNewLabel.setImage(UIImage(named:"NewPhoto"), forState: UIControlState.Normal)
		onShareLabel.setImage(UIImage(named:"Share"), forState: UIControlState.Normal)
		filterButtonLabel.setImage(UIImage(named:"Filter"), forState: UIControlState.Normal)
		filterButtonLabel.setImage(UIImage(named:"Filter"), forState: UIControlState.Selected)
		compareButton.setImage(UIImage(named:"Compare"), forState: UIControlState.Normal)
		compareButton.setImage(UIImage(named:"Compare"), forState: UIControlState.Normal)
		
		SecondMenu.translatesAutoresizingMaskIntoConstraints = false
		SecondMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
		
		self.originalImageView.image = UIImage(named: "landscape")
		
		self.filterSlider.minimumValue = -128
		self.filterSlider.maximumValue = 127
		self.filterSlider.continuous = false
		
		softReset()
	}
	
	@IBAction func filterSliderValue(sender: UISlider) {
		let value = Int8(round(sender.value / 1) * 1)
		self.currentParameter = String(value)
		self.sliderValue.text = self.currentParameter
		filterIt()
	}

	@IBAction func onSaveDown(sender: AnyObject) {
		self.infoLabel.text = "Saving as new base image!"
		self.infoLabel.hidden = false
		self.originalImageView.image = self.filteredImageView.image
		self.originalImageView.alpha = 0
		UIView.animateWithDuration(0.5){
			self.originalImageView.alpha = 0
		}
	}
	
	@IBAction func onSaveUp(sender: UIButton) {
		UIView.animateWithDuration(0.5){
			self.originalImageView.alpha = 1
		}
		softReset()
	}
	
	func softReset(){
		self.originalImageView.hidden = false
		self.filteredImageView.hidden = true
		self.filteredImageView.image = nil
		
		self.infoLabel.text = ""
		self.infoLabel.hidden = true
		
		self.compareButton.enabled = false
		hideSecondMenu()
	}
	
	
	@IBOutlet weak var onSaveLabel: UIButton!
	
	@IBAction func compareButtonDown(sender: UIButton) {
		self.infoLabel.text = "Last saved image"
		self.infoLabel.hidden = false
		self.originalImageView.hidden = false
		UIView.animateWithDuration(0.5){
			self.filteredImageView.alpha = 0
		}
	}
	
	@IBAction func compareButtonUp(sender: UIButton) {
		UIView.animateWithDuration(1){
			self.infoLabel.text = "Current image"
			self.filteredImageView.alpha = 1
		}
		self.infoLabel.text = ""
		self.infoLabel.hidden = true
	}
	
	@IBAction func greyscaleButton(sender: UIButton) {
		self.currentFilter = "Greyscale"
		filterIt()
	}
	
	@IBAction func redButton(sender: UIButton) {
		self.currentFilter = "Red"
		filterIt()
	}
	
	@IBAction func greenButton(sender: UIButton) {
		self.currentFilter = "Green"
		filterIt()
	}
	
	@IBAction func blueButton(sender: UIButton) {
		self.currentFilter = "Blue"
		filterIt()
	}
	
	@IBAction func alphaButton(sender: UIButton) {
		self.currentFilter = "Alpha"
		filterIt()
	}
	
	@IBAction func brightButton(sender: UIButton) {
		self.currentFilter = "Bright"
		filterIt()
	}
	
	@IBAction func contrastButton(sender: UIButton) {
		self.currentFilter = "Contrast"
		filterIt()
	}
	
	@IBAction func gammaButton(sender: UIButton) {
		self.currentFilter = "Gamma"
		filterIt()
	}
	
	@IBAction func solarisationButton(sender: UIButton) {
		self.currentFilter = "Solarisation"
		filterIt()
	}
	
	@IBAction func inversionButton(sender: UIButton) {
		self.currentFilter = "Inversion"
		filterIt()
	}
	
	@IBAction func scaleButton(sender: UIButton) {
		self.currentFilter = "Scale"
		filterIt()
	}
	
	func filterIt() {
		filterSlider.enabled = true
		let myPipeline = Workflow(withSequence: workflowInterface(self.currentFilter + " " + self.currentParameter))
		
		if myPipeline != nil {
			print("Could create the pipeline")
			if myPipeline!.somethingWentWrong{
				print("...but there were some problems: check spelling...")
			}
			myPipeline!.apply(self.originalImageView.image)
		} else{
			print("Could not create pipeline")
		}
		self.filteredImageView.image = myPipeline!.result!
		self.filteredImageView.hidden = false
		self.originalImageView.hidden = true
		self.compareButton.enabled = true
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "toFiltersTable") {
			print("this")
		}
		else{
			print("that")
		}
	}
	
}

	