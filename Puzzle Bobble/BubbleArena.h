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
- (BOOL)checkCollisionWithActiveBubble:(Bubble*)bubble;
- (BubbleColor)getNextBubbleColor;

@end
