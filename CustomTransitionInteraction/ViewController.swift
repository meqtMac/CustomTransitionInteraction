//
//  ViewController.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let cards = CardModel.sampleCards
    var selectedCardFrame: CGRect = .zero
    var selectedCardView: UIView?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "App Store"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "发现精彩应用"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - 屏幕方向控制
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        // 添加子视图到主视图
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
    }
    
    private func layoutViews() {
        let safeArea = view.safeAreaInsets
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        let margin: CGFloat = 20
        
        // 标题标签
        titleLabel.frame = CGRect(
            x: margin,
            y: safeArea.top + 20,
            width: viewWidth - margin * 2,
            height: 40
        )
        
        // 副标题标签
        subtitleLabel.frame = CGRect(
            x: margin,
            y: titleLabel.frame.maxY + 5,
            width: viewWidth - margin * 2,
            height: 25
        )
        
        // CollectionView
        collectionView.frame = CGRect(
            x: 0,
            y: subtitleLabel.frame.maxY + 10,
            width: viewWidth,
            height: viewHeight - subtitleLabel.frame.maxY - 10 - safeArea.bottom
        )
    }
    
    // MARK: - Card Transition Methods
    private func presentCardViewController(with card: CardModel, from cell: CardCollectionViewCell) {
        let cardVC = CardViewController()
        cardVC.cardModel = card
        
        // 获取卡片在屏幕中的位置
        let cardView = cell.getCardView()
        let cardFrame = cardView.convert(cardView.bounds, to: nil)
        cardVC.sourceCardFrame = cardFrame
        cardVC.sourceCardView = cardView
        
        // 设置转场代理
        cardVC.modalPresentationStyle = .custom
        cardVC.transitioningDelegate = self
        
        // 保存选中的卡片信息用于转场动画
        selectedCardFrame = cardFrame
        selectedCardView = cardView
        
        present(cardVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        cell.cardModel = cards[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.presentCardViewController(with: self.cards[indexPath.item], from: cell)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40 // 左右各20的边距
        let height = width * (9.0 / 16.0) // 16:9 宽高比
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentAnimator(sourceFrame: selectedCardFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissAnimator(destinationFrame: selectedCardFrame)
    }
}

