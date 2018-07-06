# BArrayExtension
Utils functions for array in swift/objc

Remove multiple items in an array efficiently:

// sortedIndexes: sorted ascending

public mutating func removeAt(sortedIndexes: [Int])

public mutating func removeAll(where shouldBeRemoved: (Element) throws -> Bool)