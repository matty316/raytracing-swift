//
//  interval.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

struct Interval {
    let min, max: Double
    
    static let empty = Interval(min: Double.infinity, max: -Double.infinity)
    static let universe = Interval(min: -Double.infinity, max: Double.infinity)
    
    init() {
        self.min = Double.infinity
        self.max = -Double.infinity
    }
    
    init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
    
    var size: Double {
        max - min
    }
    
    func contains(_ x: Double) -> Bool {
        min <= x && x <= max
    }
    
    func surrounds(_ x: Double) -> Bool {
        min < x && x < max
    }
    
    func clamp(_ x: Double) -> Double  {
        if x < min { return min }
        if x > max { return max }
        return x
    }
}
