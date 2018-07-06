//
//  Array+BAdditions.swift
//  BArrayExtension
//
//  Created by Nguyen Trong Bang on 28/6/18.
//  Copyright © 2018 Bang Nguyen. All rights reserved.
//


extension RangeReplaceableCollection where Self: MutableCollection {
    
    private mutating func moveElement(sourceIndex: Int, targetIndex: Int) {
        setAt(i: targetIndex, val: self.getAt(i: sourceIndex))
    }
    
    private mutating func setAt(i: Int, val: Element) {
        let idx = index(self.startIndex, offsetBy: i)
        self[idx] = val
    }
    
    private func getAt(i: Int) -> Element {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    private mutating func _halfStablePartition(isSuffixElement: (Element) throws -> Bool) rethrows -> Index {
        guard var i = try index(where: isSuffixElement)
            else { return endIndex }
        
        var j = index(after: i)
        while j != endIndex {
            if try !isSuffixElement(self[j]) {
                self[i] = self[j] //swapAt(i, j)
                formIndex(after: &i)
            }
            formIndex(after: &j)
        }
        return i
    }
    
    // MARK: Slow methods, that were often used
    
    public mutating func slow_removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows {
        for i in (0..<self.count).reversed() {
            let idx = self.index(self.startIndex, offsetBy: i)
            if try shouldBeRemoved(self[idx]) {
                self.remove(at: idx)
            }
        }
    }
    
    // sortedIndexes: sorted ascending
    public mutating func slow_removeAt(sortedIndexes: [Int]) {
        for i in sortedIndexes.reversed() {
            let index = self.index(self.startIndex, offsetBy: i)
            self.remove(at: index)
        }
    }
    
    // MARK: Faster methods
    
    // O(n)
    public mutating func removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows {
        let suffixStart = try _halfStablePartition(isSuffixElement: shouldBeRemoved)
        removeSubrange(suffixStart...)
    }
    
    // O(n)
    // sortedIndexes: sorted ascending
    public mutating func removeAt(sortedIndexes: [Int]) {
        guard sortedIndexes.count > 0 else { return }
        let n = sortedIndexes.count
        
        var suffixStart = sortedIndexes[0]
        var index: Int = 0
        var nextIndex: Int = 0
        for i in 0..<(n - 1) {
            index = sortedIndexes[i]
            nextIndex = sortedIndexes[i+1]
            for j in (index + 1)..<nextIndex {
                self.moveElement(sourceIndex: j, targetIndex: suffixStart)
                suffixStart += 1
            }
        }
        index = nextIndex
        for j in (index + 1)..<self.count {
            self.moveElement(sourceIndex: j, targetIndex: suffixStart)
            suffixStart += 1
        }
        let startRemove = self.index(self.startIndex, offsetBy: suffixStart)
        self.removeSubrange(startRemove...)
    }
}
