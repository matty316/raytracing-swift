//
//  sphere.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

struct Sphere: Hittable {
    let center: Point3
    let radius: Double
    let mat: Material
    
    func hit(r: Ray, t: Interval, rec: inout HitRecord?) -> Bool {
        let oc = center - r.origin
        let a = r.direction.lengthSquared
        let h = r.direction.dot(oc)
        let c = oc.lengthSquared - radius*radius
        
        let discriminant = h*h - a*c
        if discriminant < 0 {
            return false
        }
        
        let sqrtd = sqrt(discriminant)
        
        //Find the nearest root that lies in the acceptable range
        var root = (h - sqrtd) / a
        if !t.surrounds(root) {
            root = (h + sqrtd) / a
            if !t.surrounds(root) {
                return false
            }
        }
        
        rec = HitRecord(root: root, center: center, radius: radius, r: r, mat: mat)
        
        return true
    }
}
