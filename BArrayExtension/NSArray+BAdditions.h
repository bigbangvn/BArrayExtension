//
//  NSArray+BAdditions.h
//  BArrayExtension
//
//  Created by Nguyen Trong Bang on 28/6/18.
//  Copyright © 2018 Bang Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^FilterBlock)(id);

@interface NSMutableArray<ElementType>(BAdditions)

- (void)removeAll:(FilterBlock)predicate;
- (void)slow_removeAll:(FilterBlock)predicate;

@end
