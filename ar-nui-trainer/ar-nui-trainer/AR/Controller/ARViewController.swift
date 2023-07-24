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
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var previousBtnView: UIView!
    @IBOutlet weak var nextBtnView: UIView!
    
    var stage: Stage = .shortTap
    var swipeDirection: UISwipeGestureRecognizer.Direction = .right
    var isDescriptionViewPresented = false
    
    // 선택된 AR 캐릭터 관련 프로퍼티
    weak var arCharacterDelegate: ARCharacterDelegate?
    var arCharacter: ARCharacter!
    
    // UIExplorer 리소스 관련 프로퍼티
    var UIExplorer
    : UIExplorerResource = UIExplorerResource()
    var stageTitleList: [String] {
        return UIExplorer
            .stageTitles
    }
    
    // MARK: - View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        setARCharacter()

        UIExplorer.addNewGestureRecognizer(
            stage: stage,
            arCharacter: self.arCharacter,
            sceneView: self.sceneView,
            swipeDirection: self.swipeDirection
        )

        makeCornerRoundShape(targetView: titleView, cornerRadius: 20)
        makeCornerRoundShape(targetView: previousBtnView, cornerRadius: 20)
        makeCornerRoundShape(targetView: nextBtnView, cornerRadius: 20)
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
           return arCharacter.characterContainerNode
       }
       
       return nil
   }
    
    // MARK: - Move Stage IBAction Methods
    
    @IBAction func moveNextStage(_ sender: UIButton) {
        if (stage == .rotate) {
            moveBacktoHome(vc: self)
        } else {
            resetARCharacter()
            moveStage(isNext: true)

            updateGestureRecognizer()
            courseTitleLabel.text = stageTitleList[stage.rawValue]
        }
    }

    @IBAction func moveBackStage(_ sender: UIButton) {
        if (stage == .shortTap) {
            moveBacktoHome(vc: self)
        } else {
            resetARCharacter()
            moveStage(isNext: false)

            updateGestureRecognizer()
            courseTitleLabel.text = stageTitleList[stage.rawValue]
        }
    }
    
    // MARK: - Direction Button IBAction Methods
    
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
    
    // MARK: - Description View Gesture Recognizer Method
    
    @IBAction func descriptionViewTouched(_ sender: UITapGestureRecognizer) {
        self.descriptionView.isHidden = true
    }
    
    // MARK: - Feature Methods
    
    func setARCharacter() {
        guard let character = arCharacterDelegate?.selectedARCharacter() else {
            return moveBacktoHome(vc: self)
        }
        self.arCharacter = character
        self.arCharacter.setSceneView(sceneView: sceneView)
    }
    
    func updateGestureRecognizer() {
        UIExplorer.removeGestureRecognizer(sceneView: sceneView)
        UIExplorer.addNewGestureRecognizer(
            stage: stage,
            arCharacter: self.arCharacter,
            sceneView: self.sceneView,
            swipeDirection: self.swipeDirection
        )
    }
    
    func resetARCharacter() {
        if (stage == .swipe || stage == .rotate) {
            if (arCharacter is Finn) {
                let finnBodyNode = (arCharacter as! Finn).bodyNode
                arCharacter.resetARCharacterAngle(targetNode: finnBodyNode)
            } else {
                arCharacter.resetARCharacterAngle(targetNode: arCharacter.characterNode)
            }
        } else if (stage == .pinch) {
            arCharacter.resetARCharacterScale()
        }
    }
            
    func moveStage(isNext: Bool) {
        switch stage {
        case .shortTap:
            stage = .longTap
            break
        case .longTap:
            stage = isNext ? .swipe : .shortTap
            break
        case .swipe:
            stage = isNext ? .drag : .longTap
            break
        case .drag:
            stage = isNext ? .pinch : .swipe
            break
        case .pinch:
            stage = isNext ? .rotate : .drag
            break
        case .rotate:
            stage = .pinch
            break
        }
        
        directionBtnView.isHidden = (stage == .swipe) ? false : true
        setDescriptionView()
    }
    
    func setDescriptionView() {
        if (isDescriptionViewPresented == false && stage == .pinch) {
            descriptionView.isHidden = false
            descriptionLabel.text = "두 손가락 사용하기"
            isDescriptionViewPresented = true
        }
    }
}
