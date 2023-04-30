//
//  DrawView.swift
//  Quiz
//
//  Created by Peiming Chen on 12/2/22.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int?
    var moveRecognizer: UIPanGestureRecognizer!
    var penColor: UIColor?
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        for line in finishedLines {
            line.color.setStroke()
            stroke(line)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay() //flags the view to be redrawn at the end of the loop
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                if penColor != nil {
                    line.color = penColor!
                }
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // add double tap gesture recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true // delay calling touchesbegan
        addGestureRecognizer(doubleTapRecognizer)
        
        // add a one tap gesture recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer) // wait for the doubleTapRecognizer fail
        addGestureRecognizer(tapRecognizer)
        
        // add a long press recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    // When a double-tap occurs, doubleTap(_:) will be called
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        // create an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let clearCanvasAction
                = UIAlertAction(title: "Clear Canvas", style: .default) { _ in
                    self.selectedLineIndex = nil // prevend user double tap while a line is selected
                    self.currentLines.removeAll()
                    self.finishedLines.removeAll()
                    self.setNeedsDisplay()
        }
        alertController.addAction(clearCanvasAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        
//        selectedLineIndex = nil // prevend user double tap while a line is selected
//        currentLines.removeAll()
//        finishedLines.removeAll()
//        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            let changeBlueColor = UIMenuItem(title: "Blue", action: #selector(DrawView.changeBlueColor(_:)))
            let changeYellowColor = UIMenuItem(title: "Yellow", action: #selector(DrawView.changeYellowColor(_:)))
            let changePurpleColor = UIMenuItem(title: "Purple", action: #selector(DrawView.changePurpleColor(_:)))
            let changeOrangeColor = UIMenuItem(title: "Orange", action: #selector(DrawView.changeOrangeColor(_:)))
            menu.menuItems = [deleteItem, changeBlueColor, changeYellowColor, changePurpleColor, changeOrangeColor]
            
            // Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.showMenu(from: self, rect: targetRect)
            menu.showMenu(from: self, rect: targetRect)
        } else {
            // Hide the menu if no line is selected
            menu.hideMenu(from: self)
        }
        setNeedsDisplay()
    }
    
    // return the index of line closet to the given point
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.2) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func changeBlueColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.blue
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        } else {
            penColor = UIColor.blue
        }
    }
    
    @objc func changeYellowColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.yellow
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        } else {
            penColor = UIColor.yellow
        }
    }
    
    @objc func changePurpleColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.purple
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        } else {
            penColor = UIColor.purple
        }
    }
    
    @objc func changeOrangeColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.orange
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        } else {
            penColor = UIColor.orange
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            if selectedLineIndex == nil {
                selectedLineIndex = 0
                let point = gestureRecognizer.location(in: self)
                // Grab the menu controller
                let menu = UIMenuController.shared
                // Make DrawView the target of menu item action messages
                becomeFirstResponder()
                
                // Create a new "Delete" UIMenuItem
                let changeBlueColor = UIMenuItem(title: "Blue", action: #selector(DrawView.changeBlueColor(_:)))
                let changeYellowColor = UIMenuItem(title: "Yellow", action: #selector(DrawView.changeYellowColor(_:)))
                let changePurpleColor = UIMenuItem(title: "Purple", action: #selector(DrawView.changePurpleColor(_:)))
                let changeOrangeColor = UIMenuItem(title: "Orange", action: #selector(DrawView.changeOrangeColor(_:)))
                menu.menuItems = [changeBlueColor, changeYellowColor, changePurpleColor, changeOrangeColor]
                
                // Tell the menu where it should come from and show it
                let targetRect = CGRect(x: point.x, y: point.y, width: 4, height: 2)
                menu.showMenu(from: self, rect: targetRect)
                menu.showMenu(from: self, rect: targetRect)
            }
            selectedLineIndex = nil
            
        }
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        // If a line is selected
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position
            if gestureRecognizer.state == .changed {
                // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                // Redraw the screen
                setNeedsDisplay()
            } else {
                // If no line is selected, do not do anything
                return
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
