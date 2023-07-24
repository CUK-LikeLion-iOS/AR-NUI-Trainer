//
//  ARCharacterDelegate.swift
//  ar-nui-trainer
//
//  Created by Jinyoung Yoo on 2023/07/19.
//

import Foundation

protocol ARCharacterDelegate: AnyObject {
    func selectedARCharacter() -> ARCharacter?
}
