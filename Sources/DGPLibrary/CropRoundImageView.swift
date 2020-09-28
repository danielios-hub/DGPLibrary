//
//  CropRoundImageView.swift
//  SocialGaming
//
//  Created by Daniel Gallego Peralta on 02/07/2020.
//  Copyright © 2020 Daniel Gallego Peralta. All rights reserved.
//

import UIKit

public class CropRoundImageView: UIImageView {

    fileprivate var _crop = false
    fileprivate var _rounded = false
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.masksToBounds = true
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBInspectable var crop: Bool {
        set {
            _crop = newValue
            _cropImage()
        }
        get {
            return self._crop
        }
    }
    
    @IBInspectable var rounded: Bool {
        set {
            _rounded = newValue
            _makeRound()
        }
        get {
            return self._rounded
        }
    }
    
    // ROUNDED
    func makeRound() {
        self._rounded = true
        _makeRound()
    }
    
    // CROPPED
    func cropImage() {
        self._crop = true
        _cropImage()
    }
    
    // ROUNDED
    func load() {
        _makeRound()
        _cropImage()
    }
    
    // ROUNDED
    fileprivate func _makeRound() {
        if self._rounded == true {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    
    // CROPPED
    fileprivate func _cropImage() {

        if self.image != nil {
        
            if self._crop == true {
                let image : UIImage  = self.image!
                
                let contextSize: CGSize = image.size
                
                var posX: CGFloat = 0.0
                var posY: CGFloat = 0.0
                var cgwidth: CGFloat = image.size.width
                var cgheight: CGFloat = image.size.height
                
                // See what size is longer and create the center off of that
                if contextSize.width > contextSize.height {
                    posX = ((contextSize.width - contextSize.height) / 2)
                    posY = 0
                    cgwidth = contextSize.height
                    cgheight = contextSize.height
                } else {
                    posX = 0
                    posY = ((contextSize.height - contextSize.width) / 2)
                    cgwidth = contextSize.width
                    cgheight = contextSize.width
                }
                
                let croprect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
                let imageRef: CGImage? = image.cgImage?.cropping(to: croprect);
                
                if let ref = imageRef {
                    let croppedImage: UIImage = UIImage(cgImage: ref, scale: image.scale, orientation: image.imageOrientation)
                    self.image = croppedImage
                } else {
                    let image : UIImage  = self.image!
                    self.image = image
                }
                
            } else {
                let image : UIImage = self.image!
                self.image = image
            }
        }
        
    }
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }

}
