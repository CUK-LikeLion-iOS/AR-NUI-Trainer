//
//  CustomizeView.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/20.
//

import UIKit

func makeCornerRoundShape(targetView: UIView, cornerRadius: CGFloat) {
    targetView
        .layer.cornerRadius = cornerRadius
    targetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    targetView.clipsToBounds = true
}
