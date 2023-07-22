//
//  UIExplorerData.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/20.
//

import ARKit
import SceneKit

enum Stage: Int {
    case shortTap = 0, longTap, swipe, drag, pinch, rotate
}

// MARK: - UIExplorer Struct

struct UIExplorerResource {
    var stageTitles: [String] {
        return [
            "탭하기 - 짧게", "탭하기 - 길게", "스와이프하기", "드래그하기", "확대하기/축소하기", "회전시키기"
        ]
    }
    private var UIGesture: UIGestureRecognizer!
    
    // MARK: Add GestureRecognizer Methods
    
    mutating func addNewGestureRecognizer(stage: Stage, arCharacter: Arr, sceneView: ARSCNView, swipeDirection: UISwipeGestureRecognizer.Direction) {
        switch stage {
        case .shortTap:
            addTapGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.jump), sceneView: sceneView)
            break
        case .longTap:
            addLongPressGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.highJump), sceneView: sceneView)
            break
        case .swipe:
            addSwipeGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.rightAngleRotate), sceneView: sceneView, swipeDirection: swipeDirection)
        case .drag:
            addPanGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.eulerAngleRotate), sceneView: sceneView)
            break
        case .pinch:
            addPinchGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.scaleUpAndDown), sceneView: sceneView)
        case .rotate:
            addRotationGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.zAxisRotate), sceneView: sceneView)
            break
        }
    }
    
    // MARK: - GestureRecognizer Feature Methods
    
    private mutating func addTapGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView) {
        let tapGesture = UITapGestureRecognizer(target: targetCharacter, action: action)
        
        sceneView.addGestureRecognizer(tapGesture)
        self.UIGesture = tapGesture
    }
    
    private mutating func addLongPressGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView) {
        let longPressGesture = UILongPressGestureRecognizer(target: targetCharacter, action: action)
        
        longPressGesture.minimumPressDuration = 0.1
        sceneView.addGestureRecognizer(longPressGesture)
        self.UIGesture = longPressGesture
    }
    
    private mutating func addSwipeGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView, swipeDirection: UISwipeGestureRecognizer.Direction) {
        let swipeGesture = UISwipeGestureRecognizer(target: targetCharacter, action: action)
        
        swipeGesture.direction = swipeDirection
        sceneView.addGestureRecognizer(swipeGesture)
        self.UIGesture = swipeGesture
    }
    
    private mutating func addPanGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView) {
        let panGesture = UIPanGestureRecognizer(target: targetCharacter, action: action)

        sceneView.addGestureRecognizer(panGesture)
        self.UIGesture = panGesture
    }
    
    private mutating func addPinchGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView) {
        let pinchGesture = UIPinchGestureRecognizer(target: targetCharacter, action: action)
        
        sceneView.addGestureRecognizer(pinchGesture)
        self.UIGesture = pinchGesture
    }
    
    private mutating func addRotationGestureRecognizer(targetCharacter: Any, handler action: Selector?, sceneView: ARSCNView) {
        let rotationGesture = UIRotationGestureRecognizer(target: targetCharacter, action: action)
        
        sceneView.addGestureRecognizer(rotationGesture)
        self.UIGesture = rotationGesture
    }
    
    
    // MARK: - Remove GestureRecognizer Methods
    
    func removeGestureRecognizer(sceneView: ARSCNView) {
        sceneView.removeGestureRecognizer(UIGesture)
    }
}
