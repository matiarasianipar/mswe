//
//  DrawViewController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 12/3/21.
//

import UIKit

protocol CanReceive {
    func passDataBack(data: UIImage, graph: [Line])
}

class DrawViewController: UIViewController {
    var delegate: CanReceive?
    var graph = [Line]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let drawView = view as! DrawView
        
        drawView.finishedLines = graph
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let drawView = view as! DrawView
        delegate?.passDataBack(data: drawView.asImage(), graph: drawView.finishedLines)
        
    }
    
    
}
