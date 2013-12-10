//
//  Queue.m
//  Puzzle Bobble
//
//  Created by YangShun on 10/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "Queue.h"

@implementation Queue {
    NSMutableArray *items;
}

- (id)init {
    
    self = [super init];
    if (self) {
        items = [NSMutableArray array];
    }
    return self;
}


// adds an object to the back of the queue
- (void)enqueue:(id)object {
    [items addObject:object];
}

// removes an object from the front of the queue and returns it
// returns nil if queue is empty
- (id)dequeue {
    if (![self isEmpty]) {
        id object = [items objectAtIndex:0];
        [items removeObjectAtIndex:0];
        return object;
    } else {
        return nil;
    }
}

// returns the objects at the front of the queue
// returns nil if queue is empty
- (id)examine {
    if (![self isEmpty]) {
        return [items objectAtIndex:0];
    } else {
        return nil;
    }
}

// returns YES if the queue is empty
- (BOOL)isEmpty {
    return [self length] == 0;
}

// returns the number of objects in the queue
- (int)length {
    return items.count;
}


@end
