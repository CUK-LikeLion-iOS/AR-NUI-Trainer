//
//  UIExplorerData.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/20.
//

import ARKit
import SceneKit

// MARK: - UIExplorer Struct

struct UIExplorerResource {
    var stageTitles: [String] {
        return [
            "탭하기 - 짧게", "탭하기 - 길게", "스와이프하기", "드래그하기", "확대하기/축소하기", "회전시키기"
        ]
    }
    private var UIGesture: UIGestureRecognizer!
    
    // MARK: Add GestureRecognizer Methods
    
    mutating func addNewGestureRecognizer(stageNumber: Int, arCharacter: Arr, sceneView: ARSCNView, swipeDirection: UISwipeGestureRecognizer.Direction) {
        switch stageNumber {
        case 0:
            addTapGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.jump), sceneView: sceneView)
            break
        case 1:
            addLongPressGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.highJump), sceneView: sceneView)
            break
        case 2:
            addSwipeGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.rightAngleRotate), sceneView: sceneView, swipeDirection: swipeDirection)
        case 3:
            addPanGestureRecognizer(targetCharacter: arCharacter, handler: #selector(arCharacter.eulerAngleRotate), sceneView: sceneView)
            break
        default:
            break
        }
    }
    
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
    
    
    // MARK: - Remove GestureRecognizer Methods
    
    func removeGestureRecognizer(sceneView: ARSCNView) {
        sceneView.removeGestureRecognizer(UIGesture)
    }
}
