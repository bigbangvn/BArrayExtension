//
//  main.swift
//  TBSwiftDataStructure
//
//  Created by Nguyen Trong Bang on 22/6/18.
//  Copyright © 2018 Bang Nguyen. All rights reserved.
//

import Foundation

let N: Int = 100000

print("Hello, World! N = \(N)")

// Removing element in array will be much slower with Value type as Structure
class MyElement {
    let index: Int
    let j: Int64 = 0
    let k: Int64 = 0
    
    init(_ index: Int) {
        self.index = index
    }
}

func isOdd(_ val: Int) -> Bool {
    return val & 0x1 == 0x1
}

func verifyResult(arr: [MyElement]) {
    assert(arr.count == N/2)
    for element in arr {
        assert(!isOdd(element.index))
    }
}

func objc_verifyResult(arr: NSArray) {
    assert(arr.count == N/2)
    for i in 0..<arr.count {
        if let e = arr[i] as? MyElement {
            assert(!isOdd(e.index))
        } else {
            assertionFailure()
        }
    }
}

// MARK: Test case

func testRemoveWhere() {
    var a = [MyElement]()
    for i: Int in 0..<N {
        a.append(MyElement(i))
    }
    
    var b = a
    assert(b.count == N)
    var startTime = CFAbsoluteTimeGetCurrent()
    b.slow_removeAll(where: { isOdd($0.index) })
    var endTime = CFAbsoluteTimeGetCurrent()
    print("Slow remove-where: \(endTime - startTime) s")
    verifyResult(arr: b)
    
    b = a
    assert(b.count == N)
    startTime = CFAbsoluteTimeGetCurrent()
    b.removeAll(where: { isOdd($0.index) })
    endTime = CFAbsoluteTimeGetCurrent()
    print("Fast remove-where: \(endTime - startTime) s")
    verifyResult(arr: b)
    
    // Use filter, it should be fast but need alloc new memory
    b = a
    assert(b.count == N)
    startTime = CFAbsoluteTimeGetCurrent()
    let c = b.filter({ !isOdd($0.index) })
    endTime = CFAbsoluteTimeGetCurrent()
    print("Use filter: \(endTime - startTime) s")
    verifyResult(arr: c)
}

// Test With Objective C Array
func objc_testSlowRemove() {
    let arr = NSMutableArray(capacity: N)
    for i in 0..<N {
        arr.add(MyElement(i))
    }
    let startTime = CFAbsoluteTimeGetCurrent()
    arr.slow_removeAll { (e) -> Bool in
        if let e = e as? MyElement {
            return isOdd(e.index)
        } else {
            assertionFailure()
        }
        return false
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("ObjC. Slow remove-where: \(endTime - startTime) s")
    
    objc_verifyResult(arr: arr)
}

func objc_testFastRemove() {
    let arr = NSMutableArray(capacity: N)
    for i in 0..<N {
        arr.add(MyElement(i))
    }
    let startTime = CFAbsoluteTimeGetCurrent()
    arr.removeAll { (e) -> Bool in
        if let e = e as? MyElement {
            return isOdd(e.index)
        } else {
            assertionFailure()
        }
        return false
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("ObjC. Fast remove-where: \(endTime - startTime) s")
    
    objc_verifyResult(arr: arr)
}

func testRemoveMultipleIndexes() {
    var a = [MyElement]()
    var indexesToRemove = [Int]()
    for i: Int in 0..<N {
        a.append(MyElement(i))
        if isOdd(i) {
            indexesToRemove.append(i)
        }
    }
    
    var b = a
    assert(b.count == N)
    var startTime = CFAbsoluteTimeGetCurrent()
    b.slow_removeAt(sortedIndexes: indexesToRemove)
    var endTime = CFAbsoluteTimeGetCurrent()
    print("Slow remove at indexes: \(endTime - startTime) s")
    verifyResult(arr: b)
    
    b = a
    assert(b.count == N)
    startTime = CFAbsoluteTimeGetCurrent()
    b.removeAt(sortedIndexes: indexesToRemove)
    endTime = CFAbsoluteTimeGetCurrent()
    print("Fast remove at indexes: \(endTime - startTime) s")
    verifyResult(arr: b)
}

print("SWIFT: ")
testRemoveWhere()
testRemoveMultipleIndexes()

print("OBJC: ")
objc_testSlowRemove()
objc_testFastRemove()

