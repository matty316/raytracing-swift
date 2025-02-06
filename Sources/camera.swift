//
//  camera.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation

struct Camera {
    let aspectRatio: Double
    let imageWidth: Int
    let samplesPerPixel: Int
    let maxDepth: Int
    let vfov: Double
    let lookfrom: Point3
    let lookat: Point3
    let vup: Vec3
    let defocusAngle: Double
    let focusDist: Double
    private var imageHeight: Int
    private let pixelSamplesScale: Double
    private let center: Point3
    private let pixel00Loc: Point3
    private let pixelDeltaU: Vec3
    private let pixelDeltaV: Vec3
    private let u, v, w: Vec3
    private let defocusDiskU: Vec3
    private let defocusDiskV: Vec3
    
    init(aspectRatio: Double,
         imageWidth: Int,
         samplesPerPixel: Int,
         maxDepth: Int,
         vfov: Double,
         lookfrom: Point3,
         lookat: Point3,
         vup: Vec3,
         defocusAngle: Double,
         focusDist: Double) {
        self.aspectRatio = aspectRatio
        self.imageWidth = imageWidth
        self.samplesPerPixel = samplesPerPixel
        self.maxDepth = maxDepth
        self.vfov = vfov
        self.lookfrom = lookfrom
        self.lookat = lookat
        self.vup = vup
        self.defocusAngle = defocusAngle
        self.focusDist = focusDist
        
        self.imageHeight = Int(Double(self.imageWidth) / self.aspectRatio)
        self.imageHeight = (self.imageHeight < 1) ? 1 : self.imageHeight
        
        self.pixelSamplesScale = 1.0 / Double(samplesPerPixel)
        
        self.center = self.lookfrom
        
        //Determine viewport dimensions
        let theta = degreesToRadians(degrees: vfov)
        let h = tan(theta/2.0)
        let viewportHeight = 2.0 * h * self.focusDist
        let viewportWidth = viewportHeight * (Double(self.imageWidth)/Double(self.imageHeight))
        
        self.w = (self.lookfrom - self.lookat).unitVector
        self.u = vup.cross(self.w).unitVector
        self.v = self.w.cross(self.u)
        
        //Calculate the vectors across the horizontal and down the vertical edges
        let viewportU = viewportWidth * self.u
        let viewportV = viewportHeight * -self.v
        
        //Calculate the horizontal and vertical delta vectors from pixel to pixel
        self.pixelDeltaU = viewportU / Double(self.imageWidth)
        self.pixelDeltaV = viewportV / Double(self.imageHeight)

        //Calculate the location of the upper left pixel
        let viewportUpperLeft = center - (self.focusDist * self.w) - viewportU/2.0 - viewportV/2.0
        self.pixel00Loc = viewportUpperLeft + 0.5 * (self.pixelDeltaU + self.pixelDeltaV)
        
        let defocusRadius = self.focusDist * tan(degreesToRadians(degrees: defocusAngle / 2.0))
        self.defocusDiskU = self.u * defocusRadius
        self.defocusDiskV = self.v * defocusRadius
    }
    
    func render(world: Hittable) {
        print("P3\n\(imageWidth) \(imageHeight)\n255")
        
        for j in 0..<imageHeight {
            NSLog("\rScanlines remaining: \(imageHeight - j) ")
            for i in 0..<imageWidth {
                var pixelColor = Color(0.0, 0.0, 0.0)
                for _ in 0..<samplesPerPixel {
                    let r = getRay(i, j)
                    pixelColor += rayColor(r, maxDepth, world)
                }
                writeColor(pixelSamplesScale * pixelColor)
            }
        }
        NSLog("\rDone.                ")
    }
    
    private func rayColor(_ r: Ray, _ depth: Int, _ world: Hittable) -> Color {
        guard depth > 0 else {
            return Color(0.0, 0.0, 0.0)
        }
        var rec: HitRecord?
        
        if world.hit(r: r, t: Interval(min: 0.001, max: Double.infinity), rec: &rec) {
            guard let rec = rec else {
                return Color(0.0, 0.0, 0.0)
            }
            
            var scattered: Ray?
            var attenuation: Color?
            if rec.mat.scatter(rIn: r, rec: rec, attenuation: &attenuation, scattered: &scattered) {
                guard let attenuation = attenuation, let scattered = scattered else {
                    return Color(0.0, 0.0, 0.0)
                }
                return attenuation * rayColor(scattered, depth - 1, world)
            }
            return Color(0.0, 0.0, 0.0)
        }
        
        let unitDirection = r.direction.unitVector
        let a = 0.5*(unitDirection.y + 1.0)
        return (1.0-a)*Color(1.0, 1.0, 1.0) + a*Color(0.5, 0.7, 1.0)
    }
    
    private func getRay(_ i: Int, _ j: Int) -> Ray {
        // Construct a camera ray originating from the defocus disk and directed at a randomly
        // sampled point around the pixel location i, j.
        
        let offset = sampleSquare()
        let pixelSample = pixel00Loc + ((Double(i) + offset.x) * pixelDeltaU) + ((Double(j) + offset.y) * pixelDeltaV)
        
        let rayOrigin = (defocusAngle <= 0) ? center : defocusDiskSample()
        let rayDirection = pixelSample - rayOrigin
        
        return Ray(origin: rayOrigin, direction: rayDirection)
    }
    
    private func sampleSquare() -> Vec3 {
        // Returns the vector to a random point in the [-.5,-.5]-[+.5,+.5] unit square.
        return Vec3(Double.random(in: 0.0...1.0) - 0.5, Double.random(in: 0.0...1.0) - 0.5, 0.0)
    }
    
    private func defocusDiskSample() -> Point3 {
        let p = Vec3.randomInUnitDisk()
        return center + (p[0] * defocusDiskU) + (p[1] * defocusDiskV)
    }
}
