//
//  ViewController.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/19.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet var sceneView: ARSCNView!
    
    weak var arCharacterDelegate: ARCharacterDelegate?
    var arCharacter: Int {
        guard let character = arCharacterDelegate?.selectedCharacter() else { return 0 }
        return character
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "Explore Ticket", bundle: Bundle.main) else {
            return
        }
        
        configuration.trackingImages = trackingImage
        configuration.maximumNumberOfTrackedImages = 1

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func moveBackStage(_ sender: UIButton) {
        moveBacktoHome(vc: self)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        if imageAnchor.referenceImage.name == "card1" {
            let charcterNode = self.arCharacter == 0 ? makeArrhuNode()! : makeDogNode()!
            let settingFinishedCharacterNode = setARCharacter(charcterNode: charcterNode)

            return settingFinishedCharacterNode
        }
        
        return nil
    }
    
    // MARK: - UIResponde Override Methods
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let currentLocation = touch.location(in: sceneView)
        let previousLocation = touch.previousLocation(in: sceneView)
        let rotationAngleX = (currentLocation.x - previousLocation.x) * 0.01
        let rotationAngleY = (currentLocation.y - previousLocation.y) * 0.01

        if (self.arCharacter == 0) {
            makeArrRotate(rotationAngleX: rotationAngleX, rotationAngleY: rotationAngleY)
        } else {
            makeDogRotate(rotationAngleX: rotationAngleX, rotationAngleY: rotationAngleY)
        }
    }

    // MARK: - Feature Methods
    
    func makeArrhuNode() -> [SCNNode]? {
        guard let arrScene = SCNScene(named: "art.scnassets/Arr/Arr.scn") else {
            return nil
        }
        guard let arrNode = arrScene.rootNode.childNode(withName: "Arr", recursively: true) else {
            print("Here")
            return nil
        }
        
        return [arrNode]
    }
    
    func makeDogNode() -> [SCNNode]? {
        guard let dogScene = SCNScene(named: "art.scnassets/Dog/Dog.scn") else {
            return nil
        }
        if let dogNode = dogScene.rootNode.childNode(withName: "Dog", recursively: true) {
            if let neckRopeNode = dogScene.rootNode.childNode(withName: "NeckRope", recursively: true) {
                return [dogNode, neckRopeNode]
            }
        }
        
        return nil
    }
    
    func setARCharacter(charcterNode: [SCNNode]) -> SCNNode {
        let node = SCNNode()
        
        for idx in 0..<charcterNode.count {
            if (arCharacter == 0) {
                charcterNode[idx].transform = SCNMatrix4MakeRotation(-GLKMathDegreesToRadians(20), 1, 0, 0)
                charcterNode[idx].scale = SCNVector3(0.00002, 0.00002, 0.00002)
            } else {
                charcterNode[idx].transform = SCNMatrix4MakeRotation(GLKMathDegreesToRadians(70), 1, 0, 0)
                charcterNode[idx].scale = SCNVector3(0.01, 0.01, 0.01)
            }
            node.addChildNode(charcterNode[idx])
        }
        
        return node
    }

    func makeArrRotate(rotationAngleX: CGFloat, rotationAngleY: CGFloat) {
        
        guard let arrNode = sceneView.scene.rootNode.childNode(withName: "Arr", recursively: true) else {
            return
        }

        let yRotation = SCNAction.rotateBy(x: 0, y: rotationAngleX, z: 0, duration: 0)
        let xRotation = SCNAction.rotateBy(x: rotationAngleY, y: 0, z: 0, duration: 0)

        arrNode.runAction(yRotation)
        arrNode.runAction(xRotation)
    }
    
    func makeDogRotate(rotationAngleX: CGFloat, rotationAngleY: CGFloat) {
        guard let dogNode = sceneView.scene.rootNode.childNode(withName: "Dog", recursively: true) else {
            return
        }
        guard let neckRopeNode = sceneView.scene.rootNode.childNode(withName: "NeckRope", recursively: true) else {
            return
        }
        
        let yRotation = SCNAction.rotateBy(x: 0, y: rotationAngleX, z: 0, duration: 0)
        let xRotation = SCNAction.rotateBy(x: rotationAngleY, y: 0, z: 0, duration: 0)

        dogNode.runAction(yRotation)
        neckRopeNode.runAction(yRotation)
        dogNode.runAction(xRotation)
        neckRopeNode.runAction(xRotation)
    }
}
