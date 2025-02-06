//
//  material.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

protocol Material {
    func scatter(rIn: Ray, rec: HitRecord, attenuation: inout Color?, scattered: inout Ray?) -> Bool
}

struct Lambertian: Material {
    let albedo: Color
    
    func scatter(rIn: Ray, rec: HitRecord, attenuation: inout Color?, scattered: inout Ray?) -> Bool {
        var scatterDirection = rec.normal + Vec3.randomUnitVector()
        
        //catch degen scatter direction
        if scatterDirection.nearZero() {
            scatterDirection = rec.normal
        }
        
        scattered = Ray(origin: rec.p, direction: scatterDirection)
        attenuation = albedo
        return true
    }
}

struct Metal: Material {
    let albedo: Color
    let fuzz: Double
    
    func scatter(rIn: Ray, rec: HitRecord, attenuation: inout Color?, scattered: inout Ray?) -> Bool {
        var reflected = rIn.direction.reflect(normal: rec.normal)
        reflected = reflected.unitVector + (fuzz * Vec3.randomUnitVector())
        scattered = Ray(origin: rec.p, direction: reflected)
        attenuation = albedo
        if let scattered = scattered {
            return scattered.direction.dot(rec.normal) > 0
        } else {
            return true //should never get here
        }
    }
}

struct Dielectric: Material {
    let refractionIndex: Double
    
    func scatter(rIn: Ray, rec: HitRecord, attenuation: inout Color?, scattered: inout Ray?) -> Bool {
        attenuation = Color(1.0, 1.0, 1.0)
        let ri = rec.frontFace ? (1.0/refractionIndex) : refractionIndex
        
        let unitDirection = rIn.direction.unitVector
        let cosTheta = min(-unitDirection.dot(rec.normal), 1.0)
        let sinTheta = sqrt(1.0 - cosTheta*cosTheta)
        
        let cannotRefract = ri * sinTheta > 1.0
        let direction: Vec3
        
        if cannotRefract || Self.reflectance(cosine: cosTheta, refractionIndex: ri) > Double.random(in: 0.0...1.0) {
            direction = unitDirection.reflect(normal: rec.normal)
        } else {
            direction = unitDirection.refract(normal: rec.normal, etaiOverEtat: ri)
        }
        
        scattered = Ray(origin: rec.p, direction: direction)
        return true
    }
    
    static func reflectance(cosine: Double, refractionIndex: Double) -> Double {
        //Schlick's approximation
        var r0 = (1.0 - refractionIndex) / (1.0 + refractionIndex)
        r0 = r0 * r0
        return r0 + (1.0 - r0) * pow((1.0 - cosine), 5.0)
    }
}
