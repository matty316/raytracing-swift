//
//  ray.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

struct Ray {
    let origin: Point3
    let direction: Vec3
    
    func at(t: Double) -> Point3 {
        origin + t * direction
    }
}
