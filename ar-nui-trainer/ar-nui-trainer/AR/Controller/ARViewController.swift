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
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var directionBtnView: UIView!
    @IBOutlet weak var directionLabel: UILabel!

    var stageNumber = 0
    var swipeDirection: UISwipeGestureRecognizer.Direction = .right
    
    // 선택된 AR 캐릭터 관련 프로퍼티
    weak var arCharacterDelegate: ARCharacterDelegate?
    var arCharacter: Arr!
    
    // UIExplorer 리소스 관련 프로퍼티
    var UIExplorer
    : UIExplorerResource = UIExplorerResource()
    var stageTitleList: [String] {
        return UIExplorer
            .stageTitles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        setARCharacter()

        UIExplorer.addNewGestureRecognizer(
            stageNumber: 0,
            arCharacter: self.arCharacter,
            sceneView: self.sceneView,
            swipeDirection: self.swipeDirection
        )

        makeCornerRoundShape(targetView: titleView, cornerRadius: 20)
        makeCornerRoundShape(targetView: directionBtnView, cornerRadius: 50)
        directionBtnView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "Explore Ticket", bundle: Bundle.main) else {
            return
        }
        
        configuration.trackingImages = trackingImage
        configuration.maximumNumberOfTrackedImages = 1

        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
   
   func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       guard let imageAnchor = anchor as? ARImageAnchor else {
           return nil
       }
       
       if imageAnchor.referenceImage.name == "card1" {
           return arCharacter.arrContainerNode
       }
       
       return nil
   }
    
    // MARK: - IBAction Methods
    
    @IBAction func moveNextStageNumber(_ sender: UIButton) {
        if (self.stageNumber == stageTitleList.count - 1) {
            moveBacktoHome(vc: self)
        } else {
            
            self.stageNumber += 1

            // 스와이프 스테이지면 방향 버튼 뷰가 보여야함
            directionBtnView.isHidden = self.stageNumber == 2 ? false : true
            updateGestureRecognizer()
            courseTitleLabel.text = stageTitleList[stageNumber]
        }
    }

    @IBAction func moveBackStageNumber(_ sender: UIButton) {
        if (self.stageNumber == 0) {
            moveBacktoHome(vc: self)
        } else {
            self.stageNumber -= 1

            directionBtnView.isHidden = self.stageNumber == 2 ? false : true
            updateGestureRecognizer()
            courseTitleLabel.text = stageTitleList[stageNumber]
        }
    }
    
    @IBAction func leftBtnPressed(_ sender: UIButton) {
        self.swipeDirection = .left
        self.directionLabel.text = "왼쪽"
        updateGestureRecognizer()
    }
    
    @IBAction func rightBtnPressed(_ sender: UIButton) {
        self.swipeDirection = .right
        self.directionLabel.text = "오른쪽"
        updateGestureRecognizer()
    }
    
    @IBAction func upBtnPressed(_ sender: UIButton) {
        self.swipeDirection = .up
        self.directionLabel.text = "위"
        updateGestureRecognizer()
    }
    
    @IBAction func downBtnPressed(_ sender: UIButton) {
        self.swipeDirection = .down
        self.directionLabel.text = "아래"
        updateGestureRecognizer()
    }

    // MARK: - Feature Methods
    
    func setARCharacter() {
        guard let character = arCharacterDelegate?.selectedArr() else {
            return moveBacktoHome(vc: self)
        }
        self.arCharacter = character
        self.arCharacter.setSceneView(sceneView: sceneView)
    }
    
    func updateGestureRecognizer() {
        UIExplorer.removeGestureRecognizer(sceneView: sceneView)
        UIExplorer.addNewGestureRecognizer(
            stageNumber: self.stageNumber,
            arCharacter: self.arCharacter,
            sceneView: self.sceneView,
            swipeDirection: self.swipeDirection
        )

        // 스와이프 스테이지(2)일 떄는 캐릭터가 정면을 바라보지 않을 수 있으니 전후 단계로 이동할 때 정면을 바라보게 세팅
        if (stageNumber == 1 || stageNumber == 3) {
            let action = SCNAction.rotateTo(x: CGFloat(arCharacter.eulerAngleOfArrNoe.x), y: CGFloat(arCharacter.eulerAngleOfArrNoe.y), z: CGFloat(arCharacter.eulerAngleOfArrNoe.z), duration: 0.2)
            arCharacter.arrNode.runAction(action)
        }
    }
}
