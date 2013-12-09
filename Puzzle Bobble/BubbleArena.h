//
//  BubbleArena.h
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Bubble.h"

@interface BubbleArena : NSObject


- (void)initializeArenaModel;
- (void)initializeLevel;
- (void)initializeBubbleViewsInView:(UIView*)view;

- (Bubble*)getBubbleAtX:(int)j andY:(int)i;
- (NSArray*)calculateNearestPositionsAtRow:(int)row andCol:(int)col;
- (BOOL)checkCollisionWithActiveBubble:(Bubble*)bubble;

@end
