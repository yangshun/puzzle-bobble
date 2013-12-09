//
//  BubbleArena.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "BubbleArena.h"

@implementation BubbleArena {

    Bubble* bubblesGrid[NUMBER_OF_ROWS][NUMBER_OF_BUBBLES_IN_ROW];
    CGPoint bubblesLocation[NUMBER_OF_ROWS][NUMBER_OF_BUBBLES_IN_ROW];
}

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initializeArenaModel {
    
    CGFloat rowOffset = BUBBLE_DIAMETER * sin(M_PI/3);

    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            CGPoint position;
            if (j % 2 == 0) {
                position = CGPointMake(i * BUBBLE_DIAMETER + BUBBLE_DIAMETER/2,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
            } else {
                // odd rows have 1 less bubble
                position = CGPointMake((i+1) * BUBBLE_DIAMETER,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
                if (i == NUMBER_OF_BUBBLES_IN_ROW - 1) { break; }
            }
            Bubble *b = [[Bubble alloc] initWithPosition:position];
            bubblesGrid[j][i] = b;
        }
    }
}

- (void)initializeLevel {
    // code to read from file here
    
    // hardcoded level 1
    for (int j = 0; j < 4; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            if (j % 2 == 1 && i == NUMBER_OF_BUBBLES_IN_ROW - 1) {
                continue;
            }
            bubblesGrid[j][i].backgroundColor = [UIColor redColor];
            bubblesGrid[j][i].occupied = YES;
        }
    }
}

- (void)initializeBubbleViewsInView:(UIView*)view {
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            if (bubblesGrid[j][i].occupied) {
                [view addSubview:bubblesGrid[j][i]];
            }
        }
    }
}

- (BOOL)checkCollisionWithActiveBubble:(Bubble *)activeBubble {
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (b.occupied) {
                CGFloat dist = sqrtf(powf(activeBubble.center.x - b.center.x, 2) +
                                     powf(activeBubble.center.y - b.center.y, 2));
                if (dist < BUBBLE_DIAMETER) {
                    NSLog(@"%d %d", j, i);
                    [self attachBubbleAtNearestAvailablePositionOfCollisionPoint:activeBubble];
                    return YES;
                    break;
                }
            }
        }
    }
    
    
    return NO;
}

- (NSArray*)attachBubbleAtNearestAvailablePositionOfCollisionPoint:(Bubble*)bubble {
    CGFloat minDist = INFINITY;
    int minJ, minI;
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (!b.occupied) {
                CGFloat dist = sqrtf(powf(bubble.center.x - b.center.x, 2) +
                                     powf(bubble.center.y - b.center.y, 2));
                if (dist < minDist) {
                    minDist = dist;
                    minI = i;
                    minJ = j;
                }
            }
        }
    }
    
    NSLog(@"%d %d", minJ, minI);
    bubble.center = bubblesGrid[minJ][minI].center;
    bubblesGrid[minJ][minI] = bubble;
    bubblesGrid[minJ][minI].occupied = YES;
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:minI], [NSNumber numberWithInt:minJ], nil];
}


@end
