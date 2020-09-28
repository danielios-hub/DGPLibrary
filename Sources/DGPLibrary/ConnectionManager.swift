//
//  ConnectionManager.swift
//  SocialGaming
//
//  Created by Daniel Gallego Peralta on 01/07/2020.
//  Copyright © 2020 Daniel Gallego Peralta. All rights reserved.
//

import DGPExtensionCore
import UIKit

private let _instance = ConnectionManager()

public class ConnectionManager {
    
    private let margin : CGFloat = 10
    private let heightMsgInfo : CGFloat = 40
    static let NOTIFICATION_CONNECTION_BACK = "connection_back"
    
    public typealias BlockFinish = () -> Void
    private var blockFinish : BlockFinish? = nil
    
    public class var sharedInstance : ConnectionManager {
        return _instance
    }
    
    public func isConnected() -> Bool {
        return Reachability.isConnected()
    }
    
    public func startManager() {
        if !isConnected() {
            checkConnectionBack()
        }
    }
    
    //MARK: - OFFLINE
    
    public func createInfoViewWithLayout(_ parentView : UIView, offset: CGFloat, block: BlockFinish?) -> UIView {
        let infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = .black_midnight_light
        parentView.addSubview(infoView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-Regular", size: 15)
        label.text = "MSG_OFFLINE".localized
        label.textAlignment = .center
        infoView.addSubview(label)
        let bottom = setLayoutInfoView(parentView, infoView: infoView, label: label, offset: offset)
        
        showInfoViewWithLayout(parentView, infoView: infoView, offset: offset, bottomLayout: bottom, block: block)
        return infoView
    }
    
    public func showInfoViewWithLayout(_ parentView: UIView, infoView : UIView, offset : CGFloat, bottomLayout: NSLayoutConstraint, block: BlockFinish?) {
        bottomLayout.constant = -offset
        UIView.animate(withDuration: 0.5, animations: {
            parentView.layoutIfNeeded()
        }, completion: { (state) in
            if state {
                let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.hideInfoViewWithLayout(parentView, infoView: infoView, offset: offset, bottomLayout: bottomLayout, block: block)
                }
            }
        })
    }
    
    public func hideInfoViewWithLayout(_ parentView: UIView, infoView : UIView, offset : CGFloat, bottomLayout: NSLayoutConstraint, block: BlockFinish?) {
        bottomLayout.constant = getOffsetView(offset)
        UIView.animate(withDuration: 0.5, animations: {
            parentView.layoutIfNeeded()
        }, completion: { (state) in
            if state {
                infoView.removeFromSuperview()
                if let block = block {
                    block()
                }
            }
        })
    }
    
    private func getOffsetView(_ value: CGFloat) -> CGFloat {
        if value == 0 {
            return self.heightMsgInfo
        } else {
            return value
        }
    }
    
    private func setLayoutInfoView(_ parentView: UIView, infoView: UIView, label: UILabel, offset: CGFloat) -> NSLayoutConstraint {
        let left = NSLayoutConstraint(item: infoView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: infoView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: infoView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: getOffsetView(offset))
        let height = NSLayoutConstraint(item: infoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightMsgInfo)
        parentView.addConstraints([left, right, bottom, height])
        
        let leftLabel = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: infoView, attribute: .left, multiplier: 1, constant: margin)
        let rightLabel = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: infoView, attribute: .right, multiplier: 1, constant: -margin)
        let heightLabel = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightMsgInfo)
        let centerLabel = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: infoView, attribute: .centerY, multiplier: 1, constant: 0)
        parentView.addConstraints([leftLabel, rightLabel, heightLabel, centerLabel])
        parentView.layoutIfNeeded()
        return bottom
    }
    
    @discardableResult
    public func createInfoView(_ parentView : UIView, offset: CGFloat, block: BlockFinish?) -> UIView {
        let infoView = UIView(frame: CGRect(x: 0, y: parentView.frame.size.height, width: parentView.frame.size.width, height: heightMsgInfo))
        infoView.backgroundColor = .black_midnight_light
        parentView.addSubview(infoView)
        
        let label = UILabel(frame: CGRect(x: margin, y: 0, width: infoView.frame.size.width - (margin * 2), height: heightMsgInfo))
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-Regular", size: 15)
        label.text = "MSG_OFFLINE".localized
        label.textAlignment = .center
        infoView.addSubview(label)
        showInfoView(parentView, infoView: infoView, offset: offset, block: block)
        return infoView
    }
    
    public func showInfoView(_ parentView: UIView, infoView : UIView, offset : CGFloat, block: BlockFinish?) {
        UIView.animate(withDuration: 0.5, animations: {
            infoView.frame.origin.y -= self.heightMsgInfo + offset
        }, completion: { (state) in
            if state {
                let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.hideInfoView(parentView, infoView: infoView, offset: offset, block: block)
                }
            }
        })
    }
    
    public func hideInfoView(_ parentView: UIView, infoView : UIView, offset : CGFloat, block: BlockFinish?) {
        UIView.animate(withDuration: 0.5, animations: {
            infoView.frame.origin.y = parentView.frame.size.height
        }, completion: { (state) in
            if state {
                infoView.removeFromSuperview()
                if let block = block {
                    block()
                }
            }
        })
    }
    
    public func checkConnectionBack() {
        if self.isConnected() {
            notifiedConnectionBack()
        } else {
            let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.checkConnectionBack()
            }
        }
    }
    
    private func notifiedConnectionBack() {
        let center = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: ConnectionManager.NOTIFICATION_CONNECTION_BACK), object: nil, userInfo: [:])
        center.post(notification)
    }
}
