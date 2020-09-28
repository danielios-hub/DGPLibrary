//
//  SpinnerViewController.swift
//  SocialGaming
//
//  Created by Daniel Gallego Peralta on 03/04/2020.
//  Copyright © 2020 Daniel Gallego Peralta. All rights reserved.
//

import Foundation
import UIKit

public class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .large)

    override public func loadView() {
        view = UIView()
        self.view.backgroundColor = .clear
        //view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public func show(controller: UIViewController) {
        // add the spinner view controller
        controller.addChild(self)
        self.view.frame = controller.view.frame
        controller.view.addSubview(self.view)
        self.didMove(toParent: self)
    }
    
    public func hide() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
