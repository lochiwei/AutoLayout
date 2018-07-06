// Auto Layout

/*
 - http://www.appcoda.com/auto-layout-programmatically/
 - https://www.raywenderlich.com/110393/auto-layout-visual-format-language-tutorial
 
 使用 Auto Layout 前，必須先設定：
 1. translatesAutoresizingMaskIntoConstraints = false
 2. 使用 addSubview() 將 subview 加到 view hierarchy
 
 REQUIRES:
 - extension UIView
 
 TODO: ToDo List
 (v) add generic type alias (Anchor_Constant<T>, ...)
 (.) rename anchors (topAnchor -> top, ...)
 ( ) check if all anchors are renamed
 ( ) add return value (NSLayoutConstraint) for all "=>" functions
 
 HISTORY:
 2018 >
 - 03.20: v 0.1
 - 03.22: renamed anchors (topAnchor -> top, ...)
 - 03.25: moved autolayout-related code from extesion_UIView
 - 03.26: moved centerAtSuperview() here.
 */

import UIKit

// MARK: - UIView

extension UIView {
    
    // view.usesAutoLayout = true
    public var usesAutolayout: Bool {
        get { return !translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = !newValue }
    }
    
    // view.centerAtSuperview()
    public func centerAtSuperview(size:CGSize? = nil) {
        
        guard let sup = superview else { return  }
        
        usesAutolayout = true
        self.centerX => sup.centerX
        self.centerY => sup.centerY
        
        if let size = size {
            self.width => size.width
            self.height => size.height
        }
        
    }
}

// MARK: - Array of UIView

extension Array where Element == UIView {
    // [v1, v2, v3].usesAutolayout()
    public func usesAutolayout(_ bool: Bool = true) {
        self.forEach { $0.usesAutolayout = bool }
    }
}

// MARK: - Margins / Safe Area

extension UIView {
    public var margins: UILayoutGuide { return layoutMarginsGuide }
    public var safeArea: UILayoutGuide { return safeAreaLayoutGuide }
}

// MARK: - Guides Anchors

extension UILayoutGuide {
    // x axis
    public var centerX: NSLayoutXAxisAnchor { return centerXAnchor }
    public var leading: NSLayoutXAxisAnchor { return leadingAnchor }
    public var trailing: NSLayoutXAxisAnchor { return trailingAnchor }
    // y axis
    public var centerY: NSLayoutYAxisAnchor { return centerYAnchor }
    public var top: NSLayoutYAxisAnchor { return topAnchor }
    public var bottom: NSLayoutYAxisAnchor { return bottomAnchor }
    // dimension
    public var width: NSLayoutDimension { return widthAnchor }
    public var height: NSLayoutDimension { return heightAnchor }
}

// MARK: - View Anchors

extension UIView {
    // Y Axis
    public var top: NSLayoutYAxisAnchor { return topAnchor }
    public var bottom: NSLayoutYAxisAnchor { return bottomAnchor }
    public var centerY: NSLayoutYAxisAnchor { return centerYAnchor }
    public var firstBaseline: NSLayoutYAxisAnchor { return firstBaselineAnchor }
    // X Axis
    public var leading: NSLayoutXAxisAnchor { return leadingAnchor }
    public var trailing: NSLayoutXAxisAnchor { return trailingAnchor }
    public var centerX: NSLayoutXAxisAnchor { return centerXAnchor }
    // Dimension
    public var width: NSLayoutDimension { return widthAnchor }
    public var height: NSLayoutDimension { return heightAnchor }
}


// MARK: - Type Aliases
public typealias Anchor_Constant<T:AnyObject> = (NSLayoutAnchor<T>, CGFloat)
public typealias Multiplier_Anchor<T:AnyObject> = (CGFloat, NSLayoutAnchor<T>)
public typealias Multiplier_Anchor_Constant<T:AnyObject> = (CGFloat, NSLayoutAnchor<T>, CGFloat)


// MARK: - a.anchor = m * b.anchor + c

// 1. m * anchor -> (m, anchor)
// 2. (m, anchor) + c -> (m, anchor, c)
// 3. a.anchor => (m, anchor, c)

// 1.
public func * <T>(m:CGFloat, a:NSLayoutAnchor<T>) -> Multiplier_Anchor<T> {
    return (m, a)
}

public func * <T>(a:NSLayoutAnchor<T>, m:CGFloat) -> Multiplier_Anchor<T> {
    return m * a
}

// 2.
public func + <T>(mb:Multiplier_Anchor<T>, c:CGFloat) -> Multiplier_Anchor_Constant<T> {
    return (mb.0, mb.1, c)
}

public func + <T>(c:CGFloat, mb:Multiplier_Anchor<T>) -> Multiplier_Anchor_Constant<T> {
    return mb + c
}

// 3.
public func => <T>(a:NSLayoutAnchor<T>, b:Multiplier_Anchor_Constant<T>) {
    
    guard
        let a = a as? NSLayoutDimension,
        let anchor = b.1 as? NSLayoutDimension
        else {
            print("[AutoLayout.swift] layout anchor is not an NSLayoutDimension.")
            return
    }
    
    a.constraint(equalTo: anchor, multiplier: b.0, constant: b.2).isActive = true
}

public func => <T>(a:NSLayoutAnchor<T>, b:Multiplier_Anchor<T>) {
    a => b.0 * b.1 + 0.0
}

// MARK: - a.anchor = b.anchor +/- c

// 1. anchor + c -> (anchor, c)
//    c + anchor -> anchor + c
//    anchor - c -> (anchor, -c)
//
// 2. a.anchor = b.anchor +/- c

// 1.
public func + <T>(a:NSLayoutAnchor<T>, c:CGFloat) -> Anchor_Constant<T> {
    return (a, c)
}

public func + <T>(c:CGFloat, a:NSLayoutAnchor<T>) -> Anchor_Constant<T> {
    return a + c
}

// anchor - c
public func - <T>(a:NSLayoutAnchor<T>, c:CGFloat) -> Anchor_Constant<T> {
    return (a, -c)
}

// 2.
// custom operator (⭐️ 非常重要：必須宣告才能用)
infix operator => : AssignmentPrecedence

// a.anchor => b.anchor +/- c
public func => <T>(a:NSLayoutAnchor<T>, b:Anchor_Constant<T>) {
    // ⭐️ 非常重要：constraint 要設 isActive = true 才會真正啟用！
    a.constraint(equalTo: b.0, constant: b.1).isActive = true
}

// MARK: - a.anchor >= b.anchor + c

public func >= <T>(a:NSLayoutAnchor<T>, b:Anchor_Constant<T>) {
    a.constraint(greaterThanOrEqualTo: b.0, constant: b.1).isActive = true
}

// MARK: - a.anchor = b.anchor
public func => <T>(a:NSLayoutAnchor<T>, b:NSLayoutAnchor<T>) {
    a.constraint(equalTo: b).isActive = true
}

// MARK: - a.anchor >= b.anchor
public func >= <T>(a:NSLayoutAnchor<T>, b:NSLayoutAnchor<T>) {
    a.constraint(greaterThanOrEqualTo: b).isActive = true
}

// NSLayoutDimension

// MARK: - a.anchor = c

public func => (a:NSLayoutDimension, c:CGFloat) {
    a.constraint(equalToConstant: c).isActive = true
}

// MARK: - NSLayoutConstraint

/// v1.leading = v2.leading * 1 + 50
/// autoLayout(v1, .leading, .equal, v2, .leading, 1, 50)
public func autolayout(
    _ item1: Any, _ attr1: NSLayoutAttribute,
    _ relation: NSLayoutRelation,
    _ item2: Any?, _ attr2: NSLayoutAttribute,
    _ multiplier: CGFloat, _ constant: CGFloat
    ) {
    
    if let v = item1 as? UIView { v.usesAutolayout = true } // extension UIView
    
    NSLayoutConstraint(
        item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier, constant: constant
        ).isActive = true  // activate contraint
}

/// v1.height = 200
/// autolayout(v1, .height, .equal, 200)
public func autolayout(_ item: Any, _ attr: NSLayoutAttribute, _ relation: NSLayoutRelation, _ constant: CGFloat) {
    autolayout(item, attr, relation, nil, .notAnAttribute, 0, constant)
}

// MARK: - Visual Format Language

/// 注意：如果使用 options，"H:", "V:" 不要同時混用
public func autolayout(
    _ formats: [String],
    views: [String: UIView],
    metrics: [String:Any]? = nil,
    options: NSLayoutFormatOptions = []
    ) {
    
    for (_, v) in views {
        // ⭐️ 非常重要，沒這行 Auto Layout 就會失效！
        v.usesAutolayout = true
    }
    
    var constraints = [NSLayoutConstraint]()
    formats.forEach { (format) in
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: format, options: options, metrics: metrics, views: views
        )
    }
    NSLayoutConstraint.activate(constraints)
}
