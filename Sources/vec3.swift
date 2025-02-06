//
//  Vec3.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

typealias Point3 = Vec3

struct Vec3: Equatable {
    var e: [Double]
    var x: Double { e[0] }
    var y: Double { e[1] }
    var z: Double { e[2] }
    
    var lengthSquared: Double {
        e[0] * e[0] + e[1] * e[1] + e[2] * e[2]
    }
    
    var length: Double {
        sqrt(lengthSquared)
    }
    
    var unitVector: Vec3 {
        self / length
    }
    
    init(_ e0: Double = 0.0, _ e1: Double = 0.0, _ e2: Double = 0.0) {
        self.e = [e0, e1, e2]
    }
    
    subscript(index: Int) -> Double {
        e[index]
    }
    
    func dot(_ other: Vec3) -> Double {
        e[0] * other.e[0] + e[1] * other.e[1] + e[2] * other.e[2]
    }
    
    func cross(_ other: Vec3) -> Vec3 {
        Vec3(e[1] * other.e[2] - e[2] * other.e[1],
             e[2] * other.e[0] - e[0] * other.e[2],
             e[0] * other.e[1] - e[1] * other.e[0])
    }
    
    func nearZero() -> Bool {
        let s = 1e-8
        return (abs(e[0]) < s) && (abs(e[1]) < s) && (abs(e[2]) < s)
    }
    
    func reflect(normal: Vec3) -> Vec3 {
        self - 2.0 * self.dot(normal) * normal
    }
    
    func refract(normal: Vec3, etaiOverEtat: Double) -> Vec3 {
        let cosTheta = min(-self.dot(normal), 1.0)
        let rOutPerp = etaiOverEtat * (self + cosTheta * normal)
        let rOutParallel = -sqrt(abs(1.0 - rOutPerp.lengthSquared)) * normal
        return rOutPerp + rOutParallel
    }
    
    static func randomUnitVector() -> Vec3 {
        while true {
            let p = Vec3.random(min: -1.0, max: 1.0)
            let lensq = p.lengthSquared
            if 1e-160 < lensq && lensq <= 1.0 {
                return p / sqrt(lensq)
            }
        }
    }
    
    static func randomOnHemisphere(normal: Vec3) -> Vec3 {
        let onUnitSphere = randomUnitVector()
        if onUnitSphere.dot(normal) > 0.0 {
            return onUnitSphere
        } else {
            return -onUnitSphere
        }
    }
    
    static func randomInUnitDisk() -> Vec3 {
        while true {
            let p = Vec3(Double.random(in: -1...1), Double.random(in: -1...1), 0)
            if p.lengthSquared < 1 {
                return p
            }
        }
    }
    
    static func random() -> Vec3 {
        Vec3(Double.random(in: 0...1.0), Double.random(in: 0...1.0), Double.random(in: 0...1.0))
    }
    
    static func random(min: Double, max: Double) -> Vec3 {
        Vec3(Double.random(in: min...max), Double.random(in: min...max), Double.random(in: min...max))
    }
}

prefix func -(rhs: Vec3) -> Vec3 {
    Vec3(-rhs.e[0], -rhs.e[1], -rhs.e[2])
}

func +=(lhs: inout Vec3, rhs: Vec3) {
    lhs = Vec3(lhs.e[0] + rhs.e[0], lhs.e[1] + rhs.e[1], lhs.e[2] + rhs.e[2])
}

func *=(lhs: inout Vec3, rhs: Double) {
    lhs = Vec3(lhs.e[0] * rhs, lhs.e[1] * rhs, lhs.e[2] * rhs)
}

func /=(lhs: inout Vec3, rhs: Double) {
    lhs *= 1.0/rhs
}

func +(lhs: Vec3, rhs: Vec3) -> Vec3 {
    Vec3(lhs.e[0] + rhs.e[0], lhs.e[1] + rhs.e[1], lhs.e[2] + rhs.e[2])
}

func -(lhs: Vec3, rhs: Vec3) -> Vec3 {
    Vec3(lhs.e[0] - rhs.e[0], lhs.e[1] - rhs.e[1], lhs.e[2] - rhs.e[2])
}

func *(lhs: Vec3, rhs: Vec3) -> Vec3 {
    Vec3(lhs.e[0] * rhs.e[0], lhs.e[1] * rhs.e[1], lhs.e[2] * rhs.e[2])
}

func *(lhs: Double, rhs: Vec3) -> Vec3 {
    Vec3(lhs * rhs.e[0], lhs * rhs.e[1], lhs * rhs.e[2])
}

func *(lhs: Vec3, rhs: Double) -> Vec3 {
    rhs * lhs
}

func /(lhs: Vec3, rhs: Double) -> Vec3 {
    (1.0/rhs) * lhs
}
