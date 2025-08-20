//
//  CardCollectionViewCell.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CardCollectionViewCell"
    
    var cardModel: CardModel? {
        didSet {
            cardView.cardModel = cardModel
        }
    }
    
    // MARK: - UI Components
    private let cardView: CardView = {
        let view = CardView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(cardView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.frame = bounds
    }
    
    // MARK: - Animation
    func animatePress() {
    }
    
    // MARK: - Public Methods
    func getCardView() -> CardView {
        return cardView
    }
}
