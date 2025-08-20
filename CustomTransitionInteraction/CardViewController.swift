//
//  CardViewController.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Properties
    var cardModel: CardModel!
    var sourceCardFrame: CGRect = .zero
    var sourceCardView: UIView?
    
    // MARK: - UI Components
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let headerCardView: CardView = {
        let view = CardView()
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    // MARK: - Gesture Properties
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var topPanGestureRecognizer: UIPanGestureRecognizer!
    private var isInteractiveTransition = false
    //    private var currentGestureType: GestureType = .none
    private var isDraggingToExit = false
    
    private enum GestureType {
        case none
        case edgeSwipe
        case topSwipe
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        view.layer.masksToBounds = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 将 headerCardView 添加到 contentView 内部
        contentView.addSubview(headerCardView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(detailTextView)
        
        // 设置 scrollView 委托
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // 初始化时设置 contentOffset 为 0
        scrollView.contentOffset = CGPoint.zero
    }
    
    private func setupGestures() {
        // 顶部向下滑动手势 - 中等优先级
        topPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        topPanGestureRecognizer.maximumNumberOfTouches = 1
        topPanGestureRecognizer.delegate = self
        
        // 左侧边缘滑动手势 - 最高优先级
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        edgePanGestureRecognizer.edges = .left
        edgePanGestureRecognizer.delegate = self
        
        
        topPanGestureRecognizer.require(toFail: edgePanGestureRecognizer)
        scrollView.panGestureRecognizer.require(toFail: edgePanGestureRecognizer)
        
        view.addGestureRecognizer(topPanGestureRecognizer)
        view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    private func layoutViews() {
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        let margin: CGFloat = 20
        
        // 使用 16:9 宽高比计算 headerCardView 的高度
        let headerHeight: CGFloat = viewWidth * (9.0 / 16.0)
        
        // ScrollView - 现在撑满整个屏幕
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewWidth,
            height: viewHeight
        )
        
        // ContentView - 包含所有内容
        let contentHeight: CGFloat = headerHeight + 1000 // headerView + 足够的内容高度
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewWidth,
            height: contentHeight
        )
        
        scrollView.contentSize = contentView.bounds.size
        
        // HeaderCardView - 在 contentView 的顶部，使用 16:9 宽高比
        headerCardView.frame = CGRect(
            x: 0,
            y: 0,
            width: viewWidth,
            height: headerHeight
        )
        headerCardView.setNeedsLayout()
        headerCardView.layoutIfNeeded()
        
        // ContentLabel - 在 headerCardView 下方
        contentLabel.frame = CGRect(
            x: margin,
            y: headerHeight + 30,
            width: viewWidth - margin * 2,
            height: 60
        )
        
        // DetailTextView - 在 contentLabel 下方
        detailTextView.frame = CGRect(
            x: margin,
            y: contentLabel.frame.maxY + 20,
            width: viewWidth - margin * 2,
            height: 600
        )
    }
    
    private func updateUI() {
        guard let model = cardModel else { return }
        
        headerCardView.cardModel = model
        contentLabel.text = model.content
        
        // 添加详细内容
        let detailText = """
        这是 \(model.title) 的详细介绍页面。
        
        在这个页面中，你可以：
        • 查看详细的内容信息
        • 滚动浏览更多内容
        • 使用手势返回上一页
        
        手势操作说明：
        • 从屏幕左侧向右滑动可以返回
        • 从上往下滑动也可以返回
        • 滑动时页面会有缩放效果
        • 滑动到一定程度会自动返回
        
        注意：页面中的 ScrollView 不会与返回手势冲突，系统会智能识别你的操作意图。
        
        这里是更多的内容文本，用于演示滚动效果。你可以继续向下滚动查看更多内容。
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        
        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        
        Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
        """
        
        detailTextView.text = detailText
    }
    
    // MARK: - Gesture Handling
    @objc private func handleEdgePanGesture(_ gesture: UIPanGestureRecognizer) {
        let isScreenEdgePan = gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !isDraggingToExit
        
        // Don't do anything when it's not in the drag down mode
        if canStartDragDownToDismissPan { return }
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .began:
            break
            
        case .changed:
            // 左侧边缘滑动超过100像素直接dismiss
            let progress = calculateProgress(translation: translation)
            
            if progress >= 1 {
                dismissWithAnimation()
                return
            }
            
            handleInteractiveTransition(translation: translation)
            
        case .ended, .cancelled:
            finishInteractiveTransition(translation: translation, velocity: velocity)
            resetGestureState()
            
        default:
            break
        }
    }
    
    private func resetGestureState() {
        isInteractiveTransition = false
        isDraggingToExit = false
        scrollView.isScrollEnabled = true // 重新启用滚动
    }
    
    
    private func handleInteractiveTransition(translation: CGPoint) {
        let progress = calculateProgress(translation: translation)
        let scale = max(0.7, 1.0 - progress * 0.3)
        
        let bounds = view.superview?.bounds ?? view.bounds
        let x = bounds.width * ( 1 - scale ) / 2
        let y = bounds.height * ( 1 - scale ) / 2
        view.frame = CGRect(x: x, y: y, width: bounds.width * scale, height: bounds.height * scale)
        
        //        view.transform = CGAffineTransform(scaleX: scale, y: scale)
        viewWillLayoutSubviews()
        viewDidLayoutSubviews()
        
        // 当缩放到一定比例时自动触发 dismiss
        if scale <= 0.8 {
            dismissWithAnimation()
            isInteractiveTransition = false
        }
    }
    
    private func calculateProgress(translation: CGPoint) -> CGFloat {
        let maxDistance: CGFloat = 150
        let distance = max(abs(translation.x), abs(translation.y))
        return min(distance / maxDistance, 1.0)
    }
    
    private func finishInteractiveTransition(translation: CGPoint, velocity: CGPoint) {
        // 检查滑动距离是否超过阈值
        let shouldDismissByDistance = abs(translation.x) > 100 || abs(translation.y) > 100
        
        // 检查滑动速度是否足够快
        let shouldDismissByVelocity = abs(velocity.x) > 500 || abs(velocity.y) > 500
        
        // 检查缩放进度是否足够
        let progress = calculateProgress(translation: translation)
        let shouldDismissByProgress = progress > 0.3
        
        if shouldDismissByDistance || shouldDismissByVelocity || shouldDismissByProgress {
            dismissWithAnimation()
        } else {
            cancelInteractiveTransition()
        }
    }
    
    private func dismissWithAnimation() {
        // 使用自定义的交互式返回动画
        
        self.dismiss(animated: true)
    }
    
    private func cancelInteractiveTransition() {
        UIView.animate(withDuration: 0.3) {
            let bounds = self.view.superview?.bounds ?? self.view.bounds
            self.view.frame = bounds
            self.viewWillLayoutSubviews()
            self.viewDidLayoutSubviews()
            
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CardViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

// MARK: - UIScrollViewDelegate
extension CardViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 如果正在下拉退出，不处理滚动
        if isDraggingToExit || (scrollView.isTracking && scrollView.contentOffset.y < 0) {
            isDraggingToExit = true
            scrollView.contentOffset = .zero
        }
        scrollView.showsVerticalScrollIndicator = !isDraggingToExit
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }
    
}

