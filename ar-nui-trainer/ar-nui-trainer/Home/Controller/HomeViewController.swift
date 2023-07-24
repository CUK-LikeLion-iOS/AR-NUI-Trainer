//
//  HomeViewController.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/19.
//

import UIKit
import SceneKit

class HomeViewController: UIViewController, ARCharacterDelegate {
    
    var characterNum: Int = 0
    let homeResouce: HomeResource = HomeResource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pushedArrButton(_ sender: UIButton) {
        self.characterNum = 0
        moveToARVC(homeVC: self)
    }
    @IBAction func pushedDogButton(_ sender: UIButton) {
        self.characterNum = 1
        moveToARVC(homeVC: self)
    }

    // MARK: - ARCharacterDelegae 필수 메서드
    func selectedARCharacter() -> ARCharacter? {
        if (self.characterNum == 0) {
            guard let containerNode: SCNNode = makeArrContainerNode() else {
                return nil
            }
            return Arr(arrContainerNode: containerNode, arrNodeName: homeResouce.arrNodeName)
        } else {
            guard let containerNode: SCNNode = makeFinnContainerNode() else {
                return nil
            }
            return Finn(finnContainerNode: containerNode, finnNodeName: homeResouce.finnNodeName, finnBodyNodeName: homeResouce.finnBodyNodeName)
        }
    }
    
    // MARK: - Feature Methods

    func makeArrContainerNode() -> SCNNode? {
        let node: SCNNode = SCNNode()

        guard let arrScene = SCNScene(named: homeResouce.arrSceneName) else {
            return nil
        }
        guard let arrNode = arrScene.rootNode.childNode(withName: homeResouce.arrNodeName, recursively: true) else {
            return nil
        }

        arrNode.transform = SCNMatrix4MakeRotation(-GLKMathDegreesToRadians(30), 1, 0, 0)
        arrNode.scale = SCNVector3(0.00002, 0.00002, 0.00002)
        
        node.addChildNode(arrNode)
        return node
    }
    
    func makeFinnContainerNode() -> SCNNode? {
        let node: SCNNode = SCNNode()
        
        guard let finnScene = SCNScene(named: homeResouce.finnSceneName) else {
            return nil
        }
      
        guard let finnNode = finnScene.rootNode.childNode(withName: homeResouce.finnNodeName, recursively: true) else {
            return nil
        }
        
        finnNode.transform = SCNMatrix4MakeRotation(-GLKMathDegreesToRadians(20), 1, 0, 0)
        finnNode.scale = SCNVector3(0.0007, 0.0007, 0.0007)
        
        node.addChildNode(finnNode)
        
        return node
    }
}
