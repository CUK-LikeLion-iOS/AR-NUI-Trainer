//
//  HomeViewController.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/19.
//

import UIKit

class HomeViewController: UIViewController, ARCharacterDelegate {
    
    var characterNum: Int = 0

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
    func selectedCharacter() -> Int {
        return characterNum
    }
}
