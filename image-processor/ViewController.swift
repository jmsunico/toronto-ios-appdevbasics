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
	
	@IBOutlet weak var brightButtonLabel: UIButton!
	@IBOutlet weak var contrastButtonLabel: UIButton!
	@IBOutlet weak var greyscaleButtonLabel: UIButton!
	@IBOutlet weak var inversionButtonLabel: UIButton!
	@IBOutlet weak var solarisationButtonLabel: UIButton!
	@IBOutlet weak var gammaButtonLabel: UIButton!
	@IBOutlet weak var redButtonLabel: UIButton!
	@IBOutlet weak var greenButtonLabel: UIButton!
	@IBOutlet weak var blueButtonLabel: UIButton!
	@IBOutlet weak var alphaButtonLabel: UIButton!
	@IBOutlet weak var scaleButtonLabel: UIButton!
	
	var currentFilter = "Identity"
	var currentParameter = "1"
	
	@IBOutlet weak var activityView: UIActivityIndicatorView!
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		dismissViewControllerAnimated(true, completion: nil)
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
			self.originalImageView.image = image
			softReset()
			self.infoLabel.text = ""
			self.filteredImageView.image = self.originalImageView.image
			self.filteredImageView.hidden = true
			self.originalImageView.hidden = false
			self.originalImageView.alpha = 1
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func onShare(sender: AnyObject) {
		self.originalImageView.image = self.filteredImageView.image
		self.filterButtonLabel.selected = false
		let activityController = UIActivityViewController(activityItems: [self.originalImageView.image!], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion: nil)
		softReset()
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
	}
	
	@IBAction func onNewPhoto(sender: AnyObject) {
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
		softReset()
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
		self.view.addSubview(SecondMenu)
		
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
		self.view.addSubview(activityView)
		self.view.bringSubviewToFront(activityView)
		self.activityView.hidden = false
		
		// Do any additional setup after loading the view, typically from a nib.
		onNewLabel.setImage(UIImage(named:"NewPhoto"), forState: UIControlState.Normal)
		onShareLabel.setImage(UIImage(named:"Share"), forState: UIControlState.Normal)
		filterButtonLabel.setImage(UIImage(named:"Filter"), forState: UIControlState.Normal)
		filterButtonLabel.setImage(UIImage(named:"Filter"), forState: UIControlState.Selected)
		compareButton.setImage(UIImage(named:"Compare"), forState: UIControlState.Normal)
		compareButton.setImage(UIImage(named:"Compare"), forState: UIControlState.Normal)

		brightButtonLabel.setImage(UIImage(named:"bright"), forState: UIControlState.Normal)
		contrastButtonLabel.setImage(UIImage(named:"contrast"), forState: UIControlState.Normal)
		gammaButtonLabel.setImage(UIImage(named:"gamma"), forState: UIControlState.Normal)
		greyscaleButtonLabel.setImage(UIImage(named:"greyscale"), forState: UIControlState.Normal)
		solarisationButtonLabel.setImage(UIImage(named:"solarisation"), forState: UIControlState.Normal)
		inversionButtonLabel.setImage(UIImage(named:"inversion"), forState: UIControlState.Normal)
		redButtonLabel.setImage(UIImage(named:"red"), forState: UIControlState.Normal)
		greenButtonLabel.setImage(UIImage(named:"green"), forState: UIControlState.Normal)
		blueButtonLabel.setImage(UIImage(named:"blue"), forState: UIControlState.Normal)
		
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
		self.sliderValue.text = self.currentFilter + ": " + self.currentParameter
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
		self.activityView.hidden = true
		
		self.infoLabel.text = ""
		
		self.compareButton.enabled = false
		hideSecondMenu()
	}
	
	
	@IBOutlet weak var onSaveLabel: UIButton!
	
	@IBAction func greyscaleButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		filterSlider.enabled = false
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Greyscale"
		filterIt()
	}
	
	@IBAction func redButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Red"
		self.filterSlider.enabled = true
	}
	
	@IBAction func greenButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Green"
		self.filterSlider.enabled = true
		
	}
	
	@IBAction func blueButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Blue"
		self.filterSlider.enabled = true
	}
	
	@IBAction func alphaButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Alpha"
		self.filterSlider.enabled = true
	}
	
	@IBAction func brightButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1

		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Bright"
		self.filterSlider.enabled = true
	}
	
	@IBAction func contrastButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Contrast"
		self.filterSlider.enabled = true
	}
	
	@IBAction func gammaButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Gamma"
		self.filterSlider.enabled = true
	}
	
	@IBAction func solarisationButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Solarisation"
		self.filterSlider.enabled = true
	}
	
	@IBAction func inversionButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.filterSlider.enabled = false
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Inversion"
		filterIt()
	}
	
	@IBAction func scaleButton(sender: UIButton) {
		self.infoLabel.text = ""
		self.filteredImageView.image = self.originalImageView.image
		self.filteredImageView.hidden = true
		self.originalImageView.hidden = false
		self.originalImageView.alpha = 1
		
		self.sliderValue.text = "1"
		self.filterSlider.setValue(1, animated: true)
		self.currentFilter = "Scale"
		self.filterSlider.enabled = true
	}
	
	func filterIt() {
		self.filteredImageView.alpha = 0
		self.activityView.hidden = false
		self.view.bringSubviewToFront(activityView)
		self.activityView.startAnimating()
		let filteringCommand = self.currentFilter + " " + self.currentParameter
		
		let myPipeline = Workflow(withSequence: workflowInterface(filteringCommand))
		
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
		self.compareButton.enabled = true
		
		self.activityView.stopAnimating()
		self.activityView.hidden = true
		
		self.infoLabel.hidden = false
		self.infoLabel.text = "Applying: '" + self.currentFilter + " " + self.currentParameter + "'"
		original2filtered()
	}
	
	
	func original2filtered () {
		self.filteredImageView.alpha=0
		self.originalImageView.alpha=1
		self.filteredImageView.hidden=false
		self.originalImageView.hidden=false
		UIView.animateWithDuration(1){
			self.filteredImageView.alpha=1
			self.originalImageView.alpha=0
		}
	}
	
	func filtered2original(){
		self.filteredImageView.alpha=1
		self.originalImageView.alpha=0
		self.filteredImageView.hidden=false
		self.originalImageView.hidden=false
		
		UIView.animateWithDuration(1){
			self.filteredImageView.alpha=0
			self.originalImageView.alpha=1
		}
	}
	
	@IBAction func compareButtonDown(sender: UIButton) {
		self.infoLabel.text = "Last saved image"
		filtered2original()
	}
	
	@IBAction func compareButtonUp(sender: UIButton) {
		self.infoLabel.text = "Current image"
		original2filtered()
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

	