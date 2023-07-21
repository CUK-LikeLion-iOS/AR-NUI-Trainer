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
    func selectedArr() -> Arr? {
        if (self.characterNum == 0) {
            guard let containerNode: SCNNode = makeArrContainerNode() else {
                return nil
            }
            return Arr(arrContainerNode: containerNode, arrNodeName: homeResouce.arrNodeName)
        }
        return nil
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
}
