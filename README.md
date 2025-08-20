# CustomTransitionInteraction

一个学习自定义转场动画和交互手势的 iOS 演示项目，尝试实现类似 App Store 的卡片交互效果。

## 项目概述

这个项目是一个学习实践，探索如何在 iOS 应用中实现自定义转场动画和手势交互，主要包括：

- 🎨 **卡片布局展示**
- 🔄 **基础转场动画**
- 👆 **简单手势交互**
- 📱 **纯代码 UI 练习**
- 🎯 **16:9 卡片比例尝试**

## 主要功能

### 1. 首页卡片展示
- 展示多个卡片，每个卡片采用 16:9 宽高比
- 点击卡片时有缩放动画效果

### 2. 自定义转场动画
- **Present 动画**: 尝试实现卡片缩小后放大的效果
- **Dismiss 动画**: 使用线性动画返回原始位置
- **模糊背景**: 添加简单的模糊背景效果
- **位置对齐**: 尝试在转场过程中保持卡片位置对齐

### 3. 手势交互练习
- **左侧边缘滑动**: 实现从屏幕左侧滑动返回
- **顶部下拉**: 添加从页面顶部下拉返回功能
- **实时反馈**: 在手势过程中提供视觉反馈
- **阈值触发**: 设置滑动距离阈值来触发返回

### 4. 详情页实现
- **统一视图组件**: 尝试复用相同的卡片视图类
- **内容展示**: 添加可滚动的内容区域
- **手势处理**: 学习处理滚动和返回手势的冲突
- **交互优化**: 在特定情况下调整滚动行为

## 技术特点

### 架构设计
- **纯代码实现**: 不使用 Storyboard，完全通过代码创建 UI
- **手动布局**: 使用 `layoutSubviews` 和 frame 计算进行布局
- **统一组件**: 首页和详情页使用相同的 `CardView` 类
- **仅支持竖屏**: 应用锁定为竖屏方向

### 核心组件

- **`CardView`**: 统一的卡片视图组件，确保首页和详情页视觉一致
- **`CardTransitionAnimator`**: 自定义转场动画的核心实现
- **`CardViewController`**: 支持多种手势交互的详情页控制器

### 手势处理机制
通过 `UIGestureRecognizerDelegate` 实现精确的手势优先级控制和冲突解决。

> 💡 **查看详细实现**: 请参考源码中的具体实现和注释

## 项目结构

```
CustomTransitionInteraction/
├── AppDelegate.swift              # 应用委托
├── SceneDelegate.swift            # 场景委托
├── ViewController.swift           # 首页控制器
├── CardViewController.swift       # 详情页控制器
├── CardView.swift                 # 统一卡片视图
├── CardCollectionViewCell.swift   # 卡片集合视图单元格
├── CardModel.swift                # 卡片数据模型
├── CardTransitionAnimator.swift   # 转场动画实现
└── Info.plist                     # 应用配置
```

## 运行要求

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## 安装和运行

1. 克隆项目到本地
```bash
git clone [repository-url]
cd CustomTransitionInteraction
```

2. 使用 Xcode 打开项目
```bash
open CustomTransitionInteraction.xcodeproj
```

3. 选择目标设备或模拟器，点击运行

## 使用说明

### 基本操作
1. **浏览卡片**: 在首页上下滚动查看不同的卡片
2. **进入详情**: 点击任意卡片进入详情页
3. **查看内容**: 在详情页中滚动查看完整内容
4. **返回首页**: 使用以下任一方式返回：
   - 从屏幕左侧向右滑动
   - 从页面顶部向下滑动

### 高级交互
- **快速返回**: 滑动超过 100 像素自动触发返回
- **取消返回**: 滑动距离不够时会自动回弹
- **实时反馈**: 滑动过程中观察页面缩放效果

## UIKit 转场动画原理详解

### 转场动画系统架构

UIKit 的转场动画基于以下核心协议和类：

```swift
// 核心协议
UIViewControllerAnimatedTransitioning    // 定义动画行为
UIViewControllerTransitioningDelegate    // 提供动画器
UIViewControllerContextTransitioning     // 转场上下文

// 关键方法
func transitionDuration(using:) -> TimeInterval
func animateTransition(using:)
```

### Present 转场动画原理

#### 工作流程
1. **触发转场**: 调用 `present(_:animated:completion:)`
2. **获取动画器**: 系统调用 `animationController(forPresented:presenting:source:)`
3. **创建容器**: 系统创建转场容器视图
4. **执行动画**: 调用动画器的 `animateTransition(using:)` 方法

#### 核心实现步骤
1. **获取转场上下文** - 容器视图、目标控制器、最终位置
2. **添加模糊背景** - 创建视觉层次感
3. **创建临时动画视图** - 避免直接操作控制器视图
4. **执行关键帧动画** - 分两阶段：缩小→放大到最终位置
5. **清理和完成转场** - 移除临时视图，通知系统完成

> 💡 **查看完整实现**: 请参考 `CardTransitionAnimator.swift` 中的 `CardPresentAnimator.animateTransition(using:)` 方法

#### 具体实现位置
**文件**: `CustomTransitionInteraction/CardTransitionAnimator.swift`
**类**: `CardPresentAnimator`
**方法**: `animateTransition(using:)` (第 18-65 行)

### Dismiss 转场动画原理

#### 工作流程
1. **触发返回**: 调用 `dismiss(animated:completion:)` 或手势触发
2. **获取动画器**: 系统调用 `animationController(forDismissed:)`
3. **反向动画**: 从当前状态动画回到原始卡片位置
4. **完成转场**: 移除视图并完成转场

#### 核心实现步骤
1. **获取源视图控制器** - 当前显示的详情页
2. **创建临时动画视图** - 复制当前视图状态
3. **隐藏原始视图** - 避免视觉冲突
4. **执行线性动画** - 匀速回到首页卡片位置
5. **清理和完成转场** - 移除视图，完成转场

> 💡 **查看完整实现**: 请参考 `CardTransitionAnimator.swift` 中的 `CardDismissAnimator.animateTransition(using:)` 方法

#### 具体实现位置
**文件**: `CustomTransitionInteraction/CardTransitionAnimator.swift`
**类**: `CardDismissAnimator`
**方法**: `animateTransition(using:)` (第 69-95 行)

### 交互式转场动画

#### 手势驱动的转场
- **开始阶段**: 检测手势并标记交互开始
- **变化阶段**: 实时计算缩放和透明度，超过阈值自动触发返回
- **结束阶段**: 根据滑动距离、速度和进度决定完成或取消转场

> 💡 **查看完整实现**: 请参考 `CardViewController.swift` 中的手势处理方法

#### 具体实现位置
**文件**: `CustomTransitionInteraction/CardViewController.swift`
**方法**: 
- `handleEdgePanGesture(_:)` (第 180-205 行)
- `handleTopPanGesture(_:)` (第 207-235 行)
- `handleInteractiveTransition(translation:)` (第 245-258 行)

### 转场代理设置

#### 代理配置
通过实现 `UIViewControllerTransitioningDelegate` 协议，为 Present 和 Dismiss 操作提供相应的动画器。

> 💡 **查看完整实现**: 请参考 `ViewController.swift` 中的 `UIViewControllerTransitioningDelegate` 扩展

#### 具体实现位置
**文件**: `CustomTransitionInteraction/ViewController.swift`
**扩展**: `UIViewControllerTransitioningDelegate` (第 140-148 行)

### 关键技术点

1. **容器视图管理**: 所有动画都在 `containerView` 中进行
2. **临时视图技巧**: 使用临时视图避免直接操作控制器视图
3. **关键帧动画**: 分阶段执行复杂动画效果
4. **线性动画**: Dismiss 使用 `.curveLinear` 获得均匀速度
5. **转场上下文**: 通过 `transitionContext` 获取转场信息和控制转场完成

## 学习要点

1. **转场对齐练习**: 尝试使用统一的 `CardView` 类实现位置对齐
2. **手势交互探索**: 学习手势优先级控制和冲突处理
3. **响应式布局**: 练习 16:9 比例在不同屏幕的适配
4. **纯代码实现**: 探索手动布局的基本方法
5. **UIKit 转场学习**: 了解 UIKit 转场动画系统的基本用法

## 学习参考

这个项目可以作为学习以下 iOS 开发技术的参考：

- 了解 `UIViewControllerAnimatedTransitioning` 转场动画的基本用法
- 学习 `UIGestureRecognizer` 手势处理的基础知识
- 练习纯代码 UI 开发和手动布局
- 探索组件复用的简单方法

## 说明

这是一个学习练习项目，代码仅供参考，可能存在不足之处，欢迎指正和改进建议。

## 许可证

MIT License
