//
//  raytracing.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

@main
struct Raytracing {
    static func main() {
        //Image
        let aspectRatio = 16.0 / 9.0
        let imageWidth = 400
        
        //Calculate image height and ensure it is at least 1
        var imageHeight = Int(Double(imageWidth) / aspectRatio)
        imageHeight = (imageHeight < 1) ? 1 : imageHeight
        
        var world = HittableList()
        
        let materialGround = Lambertian(albedo: Color(0.8, 0.8, 0.0))
        let materialCenter = Lambertian(albedo: Color(0.1, 0.2, 0.5))
        let materialLeft = Dielectric(refractionIndex: 1.50)
        let materialBubble = Dielectric(refractionIndex: 1.00 / 1.50)
        let materialRight = Metal(albedo: Color(0.8, 0.6, 0.2), fuzz: 1.0)
        
        world.add(object: Sphere(center: Point3(0.0, -100.5, -1.0), radius: 100.0, mat: materialGround))
        world.add(object: Sphere(center: Point3(0.0, 0.0, -1.2), radius: 0.5, mat: materialCenter))
        world.add(object: Sphere(center: Point3(-1.0, 0.0, -1.0), radius: 0.5, mat: materialLeft))
        world.add(object: Sphere(center: Point3(-1.0, 0.0, -1.0), radius: 0.4, mat: materialBubble))
        world.add(object: Sphere(center: Point3(1.0, 0.0, -1.0), radius: 0.5, mat: materialRight))
        
        let camera = Camera(aspectRatio: 16.0/9.0,
                            imageWidth: 400,
                            samplesPerPixel: 100,
                            maxDepth: 50,
                            vfov: 20,
                            lookfrom: Point3(-2, 2, 1),
                            lookat: Point3(0, 0, -1),
                            vup: Vec3(0, 1, 0),
                            defocusAngle: 10.0,
                            focusDist: 3.4)
        camera.render(world: world)
    }
}

func degreesToRadians(degrees: Double) -> Double {
    degrees * Double.pi / 180.0
}
