//
//  hittable.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

struct HitRecord {
    let p: Point3
    let normal: Vec3
    let mat: Material
    let t: Double
    var frontFace: Bool
    
    init(root: Double, center: Point3, radius: Double, r: Ray, mat: Material) {
        self.t = root
        self.p = r.at(t: self.t)
        self.mat = mat
        let outwardNormal = (self.p - center) / radius
        self.frontFace = r.direction.dot(outwardNormal) < 0
        self.normal = frontFace ? outwardNormal : -outwardNormal
    }
}

protocol Hittable {
    func hit(r: Ray, t: Interval, rec: inout HitRecord?) -> Bool
}
