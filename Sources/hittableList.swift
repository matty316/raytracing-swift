//
//  hittableList.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

struct HittableList: Hittable {
    var objects = [Hittable]()
    
    mutating func clear() {
        objects.removeAll()
    }
    
    mutating func add(object: Hittable) {
        objects.append(object)
    }
    
    func hit(r: Ray, t: Interval, rec: inout HitRecord?) -> Bool {
        var tempRec: HitRecord? = nil
        var hitAnything = false
        var closestSoFar = t.max
        
        for object in objects {
            if object.hit(r: r, t: Interval(min: t.min, max: closestSoFar), rec: &tempRec) {
                guard let tempRec = tempRec else {
                    continue
                }
                hitAnything = true
                closestSoFar = tempRec.t
                rec = tempRec
            }
        }
        return hitAnything
    }
}
