//
//  CardView.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class CardView: UIView {
    
    // MARK: - Properties
    var cardModel: CardModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TitleLabel - 居中显示，考虑边距
        
        titleLabel.sizeToFit()
        let width = titleLabel.frame.width
        let height = titleLabel.frame.height
        titleLabel.frame = CGRect(
            x: (frame.width - width) / 2,
            y: bounds.height - height - 20,
            width: width,
            height: height
        )
        
    }
    
    private func updateUI() {
        guard let model = cardModel else { return }
        
        titleLabel.text = model.title
        backgroundColor = model.backgroundColor
    }
    
}
