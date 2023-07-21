//
//  ARCharacter.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/22.
//

import ARKit
import SceneKit

// MARK: - Arr Class

class Arr {
    private var sceneView: ARSCNView!
    let arrContainerNode: SCNNode
    let arrNode: SCNNode
    let eulerAngleOfArrNoe: SCNVector3
    private var longPressStartTime: CFTimeInterval = 0.0
    
    init(arrContainerNode: SCNNode, arrNodeName: String) {
        self.arrContainerNode = arrContainerNode
        self.arrNode = arrContainerNode.childNode(withName: arrNodeName, recursively: true)!
        self.eulerAngleOfArrNoe = arrNode.eulerAngles
    }
    
    func setSceneView(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    // MARK: - Private Methods

    private func readyAction() {
        let scaleAction = SCNAction.customAction(duration: 0.0) {
            (node, elapsedTime) in
            self.arrNode.scale = SCNVector3(0.00002, 0.000017, 0.00002)
        }
        arrNode.runAction(scaleAction)
    }
    
    private func highJumpAction(longPressDuration: CFTimeInterval) {
        let scaleAction = SCNAction.customAction(duration: 0.0) {
            (node, elapsedTime) in
            self.arrNode.scale = SCNVector3(0.00002, 0.00002, 0.00002)
        }
        let jumpHeight = CGFloat(longPressDuration) * 0.1
        let jumpAction = SCNAction.moveBy(x: 0, y: jumpHeight, z: 0, duration: 0.2)
        let fallAction = SCNAction.moveBy(x: 0, y: -jumpHeight, z: 0, duration: 0.2)
        let jumpSequence = SCNAction.sequence([scaleAction, jumpAction, fallAction])

        arrNode.runAction(jumpSequence)
    }
    
    // MARK: - Selector Methods

    @objc func jump() {
        let jumpAction = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 0.2)
        let fallAction = SCNAction.moveBy(x: 0, y: -0.03, z: 0, duration: 0.2)
        
        let jumpSequence = SCNAction.sequence([jumpAction, fallAction])
        
        arrNode.runAction(jumpSequence)
    }
    
    @objc func highJump(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == .began) {
            readyAction()
            longPressStartTime = CACurrentMediaTime()
        } else if (gesture.state == .ended) {
            let longPressEndTime = CACurrentMediaTime()
            let longPressDuration = longPressEndTime - longPressStartTime
            highJumpAction(longPressDuration: longPressDuration)
        }
    }
    
    @objc func rightAngleRotate(_ gesture: UISwipeGestureRecognizer) {
        var rightAngleRotatingAction: SCNAction!

        switch gesture.direction {
        case .right:
            rightAngleRotatingAction = SCNAction.rotateBy(x: 0.0, y: CGFloat(GLKMathDegreesToRadians(90)) , z: 0.0, duration: 0.2)
            break
        case .left:
            rightAngleRotatingAction = SCNAction.rotateBy(x: 0.0, y: -CGFloat(GLKMathDegreesToRadians(90)) , z: 0.0, duration: 0.2)
            break
        case .up:
            rightAngleRotatingAction = SCNAction.rotateBy(x: -CGFloat(GLKMathDegreesToRadians(90)), y: 0.0 , z: 0.0, duration: 0.2)
            break
        default:
            rightAngleRotatingAction = SCNAction.rotateBy(x: CGFloat(GLKMathDegreesToRadians(90)), y: 0.0 , z: 0.0, duration: 0.2)
        }
        arrNode.runAction(rightAngleRotatingAction)
    }
    
    @objc func eulerAngleRotate(_ gesture: UIPanGestureRecognizer) {
        
        if (gesture.state == .ended || gesture.state == .cancelled) {
            // 제스처가 끝나거나 취소되면 정면을 바라보게 세팅
            let action = SCNAction.rotateTo(x: CGFloat(eulerAngleOfArrNoe.x), y: CGFloat(eulerAngleOfArrNoe.y), z: CGFloat(eulerAngleOfArrNoe.z), duration: 0.2)
            arrNode.runAction(action)
        } else {
            let translation = gesture.translation(in: sceneView)
            
            let rotationAngleX = CGFloat(translation.x) * 0.001
            let rotationAngleY = CGFloat(translation.y) * 0.001
            
            let yRotation = SCNAction.rotateBy(x: 0, y: rotationAngleX, z: 0, duration: 0)
            let xRotation = SCNAction.rotateBy(x: rotationAngleY, y: 0, z: 0, duration: 0)
            
            arrNode.runAction(yRotation)
            arrNode.runAction(xRotation)
        }
    }
}

// MARK: - Dog Class

class Dog {
    
}
