//
//  DrawView.swift
//  Quiz
//
//  Created by Matiara Sianipar on 12/1/21.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.hideMenu()
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    var defaultColor = 0
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        //        draw finished lines in black
        //        UIColor.black.setStroke()
        for line in finishedLines {
            line.getColor().setStroke()
            stroke(line)
        }
        
        //        if let line = currentLine {
        ////            if there is a line currently being drawn, do it in red
        //            UIColor.red.setStroke()
        //            stroke(line)
        
        //        draw current lines in red
        UIColor.red.setStroke()
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
        //        let touch = touches.first!
        //
        ////        get location of touch in view's coordinate system
        //        let location = touch.location(in: self)
        //
        //        currentLine = Line(begin: location, end: location)
        
        //        log statemenet to see order of events
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location, color: defaultColor)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let touch = touches.first!
        //        let location = touch.location(in: self)
        //
        //        currentLine?.end = location
        
        //        log statement to see order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if var line = currentLine {
        //            let touch = touches.first!
        //            let location = touch.location(in: self)
        //            line.end = location
        //            finishedLines.append(line)
        //        }
        
        //        currentLine = nil
        
        //        log statement to see order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        log statement to see order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    @objc func doubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Recognized a double tap")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete lines", style: .default, handler: {_ in
            self.selectedLineIndex = nil
            self.currentLines.removeAll()
            self.finishedLines.removeAll()
            self.setNeedsDisplay()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        //        if finishedLines != nil {
        //            let clearAction = UIAlertAction(title: "Clear lines", style: .default) { _ in
        //                self.selectedLineIndex = nil
        //                self.currentLines.removeAll()
        //                self.finishedLines.removeAll()
        //                self.setNeedsDisplay()}
        //        }
        
        
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        //        grab menu controler
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            //            make drawview target of menu item aciton messages
            becomeFirstResponder()
            
            //            create new "delete" uimenuitem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            //            menu.menuItems = [deleteItem]
            
            let blackColor = UIMenuItem(title: "Black", action: #selector(DrawView.blackColor(_:)))
            
            let pinkColor = UIMenuItem(title: "Pink", action: #selector(DrawView.pinkColor(_:)))
            //           menu.menuItems = [deleteItem, pinkColor]
            
            let purpleColor = UIMenuItem(title: "Purple", action: #selector(DrawView.purpleColor(_:)))
            
            let yellowColor = UIMenuItem(title: "Yellow", action: #selector(DrawView.yellowColor(_:)))
            
            menu.menuItems = [deleteItem, blackColor, pinkColor, purpleColor, yellowColor]
            
            //            tell menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.showMenu(from: self, rect: targetRect)
            print("menu should show")
            //            menu.setTargetRect(targetRect, in: self)
            //            menu.showMenu(from: tar, rect: <#T##CGRect#>)
        } else {
            //            hide menu if no line is selected
            menu.hideMenu()
        }
        
        setNeedsDisplay()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        //        find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            //            check few points on line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                //                if tapped point is within 20 points, return line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        //        remove selected line from list of finishedLine
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            //            redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        let point = gestureRecognizer.location(in: self)
        if gestureRecognizer.state == .began {
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
            
        } else if gestureRecognizer.state == .ended {
            let menu = UIMenuController.shared

            if selectedLineIndex == nil {
                
                //            make drawview target of menu item aciton messages
                becomeFirstResponder()
                
                let blackColor = UIMenuItem(title: "Black", action: #selector(DrawView.blackColor(_:)))
                
                let pinkColor = UIMenuItem(title: "Pink", action: #selector(DrawView.pinkColor(_:)))
                //           menu.menuItems = [deleteItem, pinkColor]
                
                let purpleColor = UIMenuItem(title: "Purple", action: #selector(DrawView.purpleColor(_:)))
                
                let yellowColor = UIMenuItem(title: "Yellow", action: #selector(DrawView.yellowColor(_:)))
                
                menu.menuItems = [blackColor, pinkColor, purpleColor, yellowColor]
                
                //            tell menu where it should come from and show it
                let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
                menu.showMenu(from: self, rect: targetRect)
                print("menu should show")
                
            }
            
            else {
                menu.hideMenu()
                selectedLineIndex = nil
            }
        }
        
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        //        if line is selected
        if let index = selectedLineIndex {
            //            when pan recognizer changes its position
            if gestureRecognizer.state == .changed {
                //                how far has pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                //                add translation to current beginning and end points of line
                
                //                make sure there are no copy and paste typos
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                //                redraw screen
                setNeedsDisplay()
            } else {
                //                if no line is selected do not do anything
                return
            }
        }
    }
    @objc func blackColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = 0
            finishedLines[index].getColor().setStroke()
            stroke(finishedLines[index])
            selectedLineIndex = nil
            
            //            redraw everything
            setNeedsDisplay()
        }
        else {
            defaultColor = 0
        }
    }
    
    
    @objc func pinkColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            //            UIColor.systemPink.setStroke()
            finishedLines[index].color = 1
            finishedLines[index].getColor().setStroke()
            stroke(finishedLines[index])
            selectedLineIndex = nil
            
            //            redraw everything
            setNeedsDisplay()
        }
        else {
            defaultColor = 1
        }
    }
    
    @objc func purpleColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = 2
            finishedLines[index].getColor().setStroke()
            stroke(finishedLines[index])
            selectedLineIndex = nil
            
            //            redraw everything
            setNeedsDisplay()
        }  else {
            defaultColor = 2
        }
    }
    
    @objc func yellowColor(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = 3
            finishedLines[index].getColor().setStroke()
            stroke(finishedLines[index])
            selectedLineIndex = nil
            
            //            redraw everything
            setNeedsDisplay()
        }
        else {
            defaultColor = 3
        }
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
