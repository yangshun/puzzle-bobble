//
//  Queue.h
//  Puzzle Bobble
//
//  Created by YangShun on 10/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

// adds an object to the back of the queue
- (void)enqueue:(id)object;

// removes an object from the front of the queue and returns it
- (id)dequeue;

// returns the objects at the front of the queue
- (id)examine;

// returns YES if the queue is empty
- (BOOL)isEmpty;

// returns the number of objects in the queue
- (int)length;

@end
