//
//  vec3Tests.swift
//  raytracing-swift
//
//  Created by matty on 2/5/25.
//

import Foundation
import Testing
@testable import raytracing_swift

struct vec3Tests {
    @Test func testVec() {
        let testVec = Vec3(1.0, 2.0, 3.0)
        
        #expect(testVec.x == 1.0)
        #expect(testVec.y == 2.0)
        #expect(testVec.z == 3.0)
    }
    
    @Test func testAddVec() {
        let testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(4.0, 7.0, 5.0)
        
        #expect(testVec1 + testVec2 == exp)
    }
    
    @Test func testAddVecInPlace() {
        var testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(4.0, 7.0, 5.0)
        
        testVec1 += testVec2
        
        #expect(testVec1 == exp)
    }
    
    @Test func testSubVec() {
        let testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(-2.0, -3.0, 1.0)
        
        #expect(testVec1 - testVec2 == exp)
    }
    
    @Test func testMulVec() {
        let testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(3.0, 10.0, 6.0)
        
        #expect(testVec1 * testVec2 == exp)
    }
    
    @Test func testMulVecByScaler() {
        let testVec = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(6.0, 10.0, 4.0)
        
        #expect(testVec * 2.0 == exp)
        #expect(2.0 * testVec == exp)
    }
    
    @Test func testMulVecInPlace() {
        var testVec = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(6.0, 10.0, 4.0)
        
        testVec *= 2.0
        
        #expect(testVec == exp)
    }
    
    @Test func testDivVecByScaler() {
        let testVec = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(1.5, 2.5, 1.0)
        
        #expect(testVec / 2.0 == exp)
    }
    
    @Test func testDivVecInPlace() {
        var testVec = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(1.5, 2.5, 1.0)
        
        testVec /= 2.0
        
        #expect(testVec == exp)
    }
    
    @Test func testNegateVec() {
        let testVec = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(-3.0, -5.0, -2.0)
                
        #expect(-testVec == exp)
    }
    
    @Test func testLength() {
        let testVec = Vec3(2.0, 3.0, 4.0)
        let exp = 29.0
        let sqrtExp = sqrt(29.0)
        
        #expect(testVec.lengthSquared == exp)
        #expect(testVec.length == sqrtExp)
    }
    
    @Test func testDot() {
        let testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = 19.0
        
        #expect(testVec1.dot(testVec2) == exp)
    }
    
    @Test func testCross() {
        let testVec1 = Vec3(1.0, 2.0, 3.0)
        let testVec2 = Vec3(3.0, 5.0, 2.0)
        
        let exp = Vec3(-11.0, 7, -1)
        
        #expect(testVec1.cross(testVec2) == exp)
    }
    
    @Test func testVecSubscript() {
        let testVec = Vec3(1.0, 2.0, 3.0)
        
        #expect(testVec[0] == 1.0)
        #expect(testVec[1] == 2.0)
        #expect(testVec[2] == 3.0)
    }
    
    @Test func testUnitVector() {
        let testVec = Vec3(1.0, 2.0, 3.0)
        let exp = Vec3(1.0/sqrt(14.0), 2.0/sqrt(14.0), 3.0/sqrt(14.0))
        
        #expect(testVec.unitVector == exp)
    }
}
