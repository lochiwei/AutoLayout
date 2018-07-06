// protocol Vector

/*
 TODO: Todo List
 ( ) more general vectors allowing variable length of elements
 
 History:
 - 2018.03.23: version 1.0
 */

import UIKit
import SceneKit

// MARK: - protocol Field
public protocol Field {
    static var zero:Self { get } // element 0
    //static var one:Self { get }  // element 1
    static func + (a:Self, b:Self) -> Self
    static func - (a:Self, b:Self) -> Self
    static func * (a:Self, b:Self) -> Self
    static func / (a:Self, b:Self) -> Self
}

// MARK: - extension Field

extension Field {
    // additive inverse
    public static prefix func - (a:Self) -> Self {
        return Self.zero - a
    }
}

// MARK: - Vector (protocol)
public protocol Vector {
    associatedtype Scalar:Field
    static func + (u:Self, v:Self) -> Self   // vector addition
    static prefix func - (u:Self) -> Self    // additive inverse
    static func * (a:Scalar, v:Self) -> Self // scalar multiplication
}

// MARK: - extension Vector

extension Vector {
    public static func - (u:Self, v:Self) -> Self { return u + (-v) }
    public static func * (v:Self, a:Scalar) -> Self { return a * v }
    public static func += (u:inout Self, v:Self) { u = u + v }
    public static func -= (u:inout Self, v:Self) { u = u - v }
    public static func *= (u:inout Self, a:Scalar) { u = u * a }
}

// MARK: - Vector2D (inherited protocol)

public protocol Vector2D: Vector, ExpressibleByArrayLiteral {
    var x: Scalar { get set }
    var y: Scalar { get set }
    init(x:Scalar, y:Scalar)
}

// MARK: - extension Vector2D

extension Vector2D {
    // default operations
    public static func + (u:Self, v:Self) -> Self {
        return Self(x: u.x + v.x, y: u.y + v.y)
    }
    public static prefix func - (p:Self) -> Self {
        return Self(x: -p.x, y: -p.y)
    }
    public static func * (a:Scalar, p:Self) -> Self {
        return Self(x: a * p.x, y: a * p.y)
    }
    // default initializers
    public init(arrayLiteral elements: Scalar...) {
        assert(elements.count >= 2, "Vector2D needs at least 2 numbers.")
        self = Self(x: elements[0], y: elements[1])
    }
    public init<V:Vector2D>(_ v:V) where V.Scalar == Scalar {
        self = Self.init(x: v.x, y: v.y)
    }
}

// 讓不同型別的二維向量可以相加
// U + V -> U
public func + <U:Vector2D, V:Vector2D>(u:U, v:V) -> U where U.Scalar == V.Scalar {
    return u + U.init(v)
}

// MARK: - Vector3D (inherited protocol)

public protocol Vector3D: Vector, ExpressibleByArrayLiteral {
    var x: Scalar { get set }
    var y: Scalar { get set }
    var z: Scalar { get set }
    init(x:Scalar, y:Scalar, z:Scalar)
}

// MARK: - extension Vector2D

extension Vector3D {
    // default operations
    public static func + (u:Self, v:Self) -> Self {
        return Self(x: u.x + v.x, y: u.y + v.y, z: u.z + v.z)
    }
    public static prefix func - (p:Self) -> Self {
        return Self(x: -p.x, y: -p.y, z: -p.z)
    }
    public static func * (a:Scalar, p:Self) -> Self {
        return Self(x: a * p.x, y: a * p.y, z: a * p.z)
    }
    // default initializers
    public init(arrayLiteral elements: Scalar...) {
        assert(elements.count >= 3, "Vector3D needs at least 3 numbers.")
        self = Self(x: elements[0], y: elements[1], z: elements[2])
    }
    public init<V:Vector3D>(_ v:V) where V.Scalar == Scalar {
        self = Self.init(x: v.x, y: v.y, z: v.z)
    }
}

// 讓不同型別的 3D 向量可以相加
// U + V -> U
public func + <U:Vector3D, V:Vector3D>(u:U, v:V) -> U where U.Scalar == V.Scalar {
    return u + U.init(v)
}

// MARK: - Fields (Field conforming types)

// CGFloat as vector scalars
extension CGFloat: Field {
    public static let zero: CGFloat = 0
}

// Float as vector scalars
extension Float: Field {
    public static let zero: Float = 0
}

// MARK: -  2D Vectors (Vector2D conforming types)

// CGPoint as Vector2D
extension CGPoint:Vector2D {
    public typealias Scalar = CGFloat
}

// CGVector as Vector2D
extension CGVector: Vector2D {
    
    public typealias Scalar = CGFloat
    
    public var x: CGFloat {
        get { return dx }
        set(newX) { dx = newX }
    }
    
    public var y: CGFloat {
        get { return dy }
        set(newY) { dy = newY }
    }
    
    public init(x: Scalar, y: Scalar) {
        self.init()
        dx = x
        dy = y
    }
}

// CGSize as Vector2D
extension CGSize: Vector2D {
    
    public typealias Scalar = CGFloat
    
    public var x: CGFloat {
        get { return width }
        set(newX) { width = newX }
    }
    
    public var y: CGFloat {
        get { return height }
        set(newY) { height = newY }
    }
    
    public init(x: Scalar, y: Scalar) {
        self.init()
        width = x
        height = y
    }
}

// MARK: -  3D Vectors (Vector3D conforming types)

// SCNVector3 as Vector3D
extension SCNVector3: Vector3D {
    public typealias Scalar = Float // scalar field
}

// MARK: - 4D Vectors ?

// extensions - CGRect
extension CGRect: ExpressibleByArrayLiteral {
    
    // rect = [10, 10, 40, 30]
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count >= 4, "CGRect needs: x, y, width, height.")
        self.init(x: elements[0], y: elements[1], width: elements[2], height: elements[3])
    }
    
    // get: rect.center
    // set: rect.center = [10, 20]
    public var center: CGPoint {
        get { return [midX, midY] }
        set (newCenter) { origin += newCenter - center }
    }
    
}

