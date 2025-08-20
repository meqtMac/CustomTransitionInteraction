//
//  CardModel.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

struct CardModel {
    let id: Int
    let title: String
    let backgroundColor: UIColor
    let content: String
    
    static let sampleCards: [CardModel] = [
        CardModel(id: 1, title: "今日推荐", backgroundColor: .systemBlue, content: "发现最新最热门的应用和游戏"),
        CardModel(id: 2, title: "游戏专区", backgroundColor: .systemGreen, content: "精选游戏，带来无限乐趣"),
        CardModel(id: 3, title: "生产力工具", backgroundColor: .systemOrange, content: "提升工作效率的必备应用"),
        CardModel(id: 4, title: "摄影与视频", backgroundColor: .systemPurple, content: "记录美好时光的创意工具"),
        CardModel(id: 5, title: "健康健身", backgroundColor: .systemRed, content: "保持健康生活方式的好帮手"),
        CardModel(id: 6, title: "教育学习", backgroundColor: .systemTeal, content: "知识改变命运，学习成就未来")
    ]
}