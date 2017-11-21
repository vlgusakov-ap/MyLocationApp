//
//  ShareButton.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/18/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
    
    //MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.7 : 1
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .black : .gray
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.setTitle("Share", for: .normal)
        self.isEnabled = true
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}
