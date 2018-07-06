//
//  NSArray+BAdditions.m
//  BArrayExtension
//
//  Created by Nguyen Trong Bang on 28/6/18.
//  Copyright © 2018 Bang Nguyen. All rights reserved.
//

#import "NSArray+BAdditions.h"

typedef id ElementType;

@implementation NSMutableArray(BAdditions)

// Move all elements that should be remove to the end of the array

- (NSInteger)shuffleDown:(FilterBlock)predicate {
    NSInteger n = self.count;
    NSInteger i;
    for (i = 0; i < n; ++i) {
        if (predicate(self[i])) {
            break;
        }
    }
    NSInteger j = i + 1;
    for (; j < n; ++j) {
        if (!predicate(self[j])) {
            self[i] = self[j];
            ++i;
        }
    }
    return i;
}

- (void)removeAll:(FilterBlock)predicate {
    NSInteger startIndex = [self shuffleDown:predicate];
    [self removeObjectsInRange:NSMakeRange(startIndex, self.count - startIndex)];
}

- (void)slow_removeAll:(FilterBlock)predicate {
    NSInteger n = self.count;
    for (NSInteger i = n - 1; i >= 0; --i) {
        if (predicate(self[i])) {
            [self removeObjectAtIndex:i];
        }
    }
}

@end
