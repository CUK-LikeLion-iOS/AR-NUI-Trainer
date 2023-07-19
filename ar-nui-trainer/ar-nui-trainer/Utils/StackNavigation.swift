//
//  StackNavigation.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/19.
//

import UIKit


func moveToARVC(homeVC: UIViewController) {
    let storyboard = UIStoryboard(name: "AR", bundle: nil)

    guard let nextVC = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController else {
        return
    }
    
    nextVC.arCharacterDelegate = homeVC as! HomeViewController
    
    homeVC.navigationController?.pushViewController(nextVC, animated: true)
}

func moveBacktoHome(vc: UIViewController) {
    vc.navigationController?.popToRootViewController(animated: true)
}
