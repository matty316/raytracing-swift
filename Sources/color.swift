//
//  color.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

typealias Color = Vec3

func linearToGamma(_ linearComponent: Double) -> Double {
    if linearComponent > 0.0 {
        return sqrt(linearComponent)
    }
    return 0.0
}

func writeColor(_ c: Color) {
    var r = c.x
    var g = c.y
    var b = c.z
    
    r = linearToGamma(r)
    g = linearToGamma(g)
    b = linearToGamma(b)
    
    let intensity = Interval(min: 0.0000, max: 0.999)
    
    let rbyte = Int(256 * intensity.clamp(r))
    let gbyte = Int(256 * intensity.clamp(g))
    let bbyte = Int(256 * intensity.clamp(b))
    
    print("\(rbyte) \(gbyte) \(bbyte)")
}
