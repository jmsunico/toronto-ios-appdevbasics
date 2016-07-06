//
//  ViewController.swift
//  image-processor
//
//  Created by José-María Súnico on 20160624.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit
var pickerDataSource : [[String]] = [[],[]]
var lastFilter = "Identity"
var lastParameter = "0"

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	let imagePicker = UIImagePickerController()
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			sourceImageContainer.contentMode = .ScaleAspectFit
			sourceImageContainer.image = pickedImage
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBOutlet weak var sourceImageContainer: UIImageView!
	@IBAction func sourceImagePicker(sender: UIButton) {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	@IBOutlet weak var filterPicker: UIPickerView!
	@IBOutlet weak var filteredImageContainer: UIImageView!
	
	@IBAction func userPressedReturn(sender: UITextField) {
		self.applyFilter(commandLine.text!)
	}
	@IBOutlet weak var commandLine: UITextField!
	@IBAction func textFieldEditingbegin(sender: UITextField) {
		//
	}
	@IBAction func textFieldEditingend(sender: UITextField) {
		applyFilter(commandLine.text!)
	}
	
	func applyFilter(commands : String) -> UIImage{
		let myPipeline : Workflow = Workflow(withSequence: workflowInterface(commands))!
		
		if myPipeline.somethingWentWrong{
		print("...but there were some problems: check spelling...")
		myPipeline.sequence
			print(myPipeline.sequence)}
			myPipeline.apply(image)
			myPipeline.result
		}
		filteredImageContainer.image = myPipeline.resul
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		//Initialise pickerDataSource

		for (key, _) in functionsDictionary{
			pickerDataSource[0].append(key)
		}
		for parameter in -128...127{
			pickerDataSource[1].append(String(parameter))
		}
		imagePicker.allowsEditing = false
		imagePicker.delegate = self
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
		self.filterPicker.dataSource = self
		self.filterPicker.delegate = self
		filterPicker.selectRow(5, inComponent: 0, animated: true)
		filterPicker.selectRow(128, inComponent: 1, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//This method indicates that the number of components of the view selector is just one, the name of the song
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 2
	}
	
	//This method indicates that the number of items in the component equals the number of elements in the  array
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerDataSource[component].count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerDataSource[component][row]
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		print(pickerDataSource[component][row])
	}
	
	// Preparation for storyboard-based applications
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
}


