//////////////////////////////////////////////////////////
//                jmsunico@gmail.com                    //
// https://github.com/jmsunico/coursera-toronto-ios.git //
//////////////////////////////////////////////////////////
import UIKit
import XCPlayground

let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))

hostView.layer.borderWidth = 1
hostView.layer.borderColor = UIColor.grayColor().CGColor
hostView.backgroundColor = .whiteColor()

XCPShowView("Host View", view: hostView)

let navigationBar = UINavigationBar(frame: CGRect.zero)
navigationBar.translatesAutoresizingMaskIntoConstraints = false
navigationBar.setItems([UINavigationItem(title: "Login")], animated: false)

let usernameTextField = UITextField(frame: CGRect.zero)
usernameTextField.translatesAutoresizingMaskIntoConstraints = false
usernameTextField.placeholder = "Username"
usernameTextField.borderStyle = .Line

let passwordTextField = UITextField(frame: CGRect.zero)
passwordTextField.translatesAutoresizingMaskIntoConstraints = false
passwordTextField.placeholder = "Password"
passwordTextField.borderStyle = .Line
passwordTextField.secureTextEntry = true

let loginButton = UIButton(type: .System)
loginButton.translatesAutoresizingMaskIntoConstraints = false
loginButton.setTitle("Login", forState: .Normal)

hostView.addSubview(navigationBar)
hostView.addSubview(usernameTextField)
hostView.addSubview(passwordTextField)
hostView.addSubview(loginButton)

let views = ["navigationBar": navigationBar, "name": usernameTextField, "password": passwordTextField, "button": loginButton]
var layoutConstraints = [NSLayoutConstraint]()
layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[navigationBar]|", options: [], metrics: nil, views: views)
layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|-[name(password,button)]-|", options: [], metrics: nil, views: views)
layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[navigationBar(64)]-20-[name(30)]", options: [], metrics: nil, views: views)
layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[name(30)]-10-[password(30)]-20-[button]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: views)
NSLayoutConstraint.activateConstraints(layoutConstraints)

hostView.subviews.map { $0.setNeedsDisplay() }







//////////////////////////////////////////////////////////
// https://github.com/jmsunico/coursera-toronto-ios.git //
//////////////////////////////////////////////////////////

let image = UIImage(named: "sample")

////////// SOME TESTS ///////////

var stage1 = Workflow(withSequence: [("redEnhancer", -2000), ("greenEnhancer", -2000), ("blueEnhancer", 100)])
if stage1 != nil {
	print("Could create workflow stage1")
	stage1!.apply(image)
	stage1!.result
} else{
	print("Couldn't create workflow stage1")
}

var stage2 = Workflow(withSequence: [("alphaEnhancer", 2), ("blueEnhancer", 2)])
if stage2 != nil {
	print("Could create workflow stage2")
	stage2!.apply(image)
	stage2!.result
} else{
	print("Couldn't create workflow stage2")
}

var stage3 = Workflow(withSequence: [("a misspelled/inexistent filter", 10), ("blueEnhancer", 20), ("blueEnhancer", 10), ("blueEnhancer", 10)])
if stage3 != nil {
	print("Could create workflow stage2")
	stage3!.apply(image)
	stage3!.result
} else{
	print("Couldn't create workflow stage2")
}
stage3!.result
