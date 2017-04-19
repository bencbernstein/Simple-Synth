///
/// Shapes.swift
///

import Foundation
import UIKit

class ShapesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let environment = Environment(type: .frog, frame: view.frame)
        
        view.addSubview(environment)
    }
}
