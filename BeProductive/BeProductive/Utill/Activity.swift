//
//  Activity.swift
//  BeProductive
//
//  Created by Arwa Alattas on 23/05/1443 AH.
//


import UIKit
struct Activity {
    static func showIndicator(parentView:UIView,childView activityIndicator:UIActivityIndicatorView) {
        parentView.addSubview(activityIndicator)
        activityIndicator.center = parentView.center
        activityIndicator.startAnimating()
        parentView.isUserInteractionEnabled = false
    }
    static func removeIndicator(parentView:UIView,childView activityIndicator:UIActivityIndicatorView) {
        activityIndicator.removeFromSuperview()
        activityIndicator.stopAnimating()
        parentView.isUserInteractionEnabled = true
    }
}
