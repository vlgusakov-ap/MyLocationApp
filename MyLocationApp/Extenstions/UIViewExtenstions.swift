//
//  UIViewExtenstions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/19/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

extension UIView {
    
    func enableTapToDismissKeyboard() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func addGradientLayer() {
        addGradientLayer(with: [UIColor.green.cgColor, UIColor.blue.cgColor])
    }
    
    func addGradientLayer(with colors: NSArray, for location : [NSNumber] = [0.0, 1.0], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors as? [CGColor]
        gradientLayer.locations = location
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.actions = ["bounds" : NSNull() as CAAction, "position" : NSNull() as CAAction]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
