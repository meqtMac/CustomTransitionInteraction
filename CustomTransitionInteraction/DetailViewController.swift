//
//  DetailViewController.swift
//  CustomTransitionInteraction
//
//  Created by jiangYi on 2025/8/19.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "详情页面"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "这是一个完全使用代码创建的详情页面。\n\n所有的 UI 元素都通过手动计算 frame 进行布局，提供了更好的版本控制和团队协作体验。\n\n你可以通过不同的方式返回到主页面。"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("关闭页面", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回上一页", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
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
        view.backgroundColor = .systemBackground.withAlphaComponent(0.95)
        title = "详情"
        
        // 设置导航栏
        if navigationController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(closeButtonTapped)
            )
        }
        
        // 添加子视图
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(dismissButton)
        containerView.addSubview(backButton)
    }
    
    private func layoutViews() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        let margin: CGFloat = 20
        let containerPadding: CGFloat = 30
        let buttonHeight: CGFloat = 50
        let spacing: CGFloat = 24
        
        // 容器视图尺寸计算
        let containerWidth = viewWidth - margin * 2
        let containerHeight: CGFloat = 400
        
        // 容器视图居中
        containerView.frame = CGRect(
            x: (viewWidth - containerWidth) / 2,
            y: (viewHeight - containerHeight) / 2,
            width: containerWidth,
            height: containerHeight
        )
        
        // 标题标签
        let titleHeight: CGFloat = 30
        titleLabel.frame = CGRect(
            x: containerPadding,
            y: containerPadding,
            width: containerWidth - containerPadding * 2,
            height: titleHeight
        )
        
        // 内容标签
        let contentHeight: CGFloat = 120
        contentLabel.frame = CGRect(
            x: containerPadding,
            y: titleLabel.frame.maxY + spacing,
            width: containerWidth - containerPadding * 2,
            height: contentHeight
        )
        
        // 关闭按钮
        dismissButton.frame = CGRect(
            x: containerPadding,
            y: contentLabel.frame.maxY + spacing,
            width: containerWidth - containerPadding * 2,
            height: buttonHeight
        )
        
        // 返回按钮
        backButton.frame = CGRect(
            x: containerPadding,
            y: dismissButton.frame.maxY + spacing,
            width: containerWidth - containerPadding * 2,
            height: buttonHeight
        )
    }
    
    private func setupActions() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func closeButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}