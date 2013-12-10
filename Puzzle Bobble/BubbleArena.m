//
//  BubbleArena.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "BubbleArena.h"
#import "Queue.h"

@implementation BubbleArena {

    Bubble* bubblesGrid[NUMBER_OF_ROWS][NUMBER_OF_COLS];
    CGPoint bubblesLocation[NUMBER_OF_ROWS][NUMBER_OF_COLS];
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
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            CGPoint position;
            if (j % 2 == 0) {
                position = CGPointMake(i * BUBBLE_DIAMETER + BUBBLE_DIAMETER/2,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
            } else {
                // odd rows have 1 less bubble
                position = CGPointMake((i+1) * BUBBLE_DIAMETER,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
                if (i == NUMBER_OF_COLS - 1) { break; }
            }
            Bubble *b = [[Bubble alloc] initWithPosition:position];
            b.row = j;
            b.col = i;
            bubblesGrid[j][i] = b;
        }
    }
}

- (void)initializeLevel {
    // code to read from file here
    
    // hardcoded level 1
    for (int j = 0; j < 8; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            if (j % 2 == 1 && i == NUMBER_OF_COLS - 1) {
                continue;
            }
            bubblesGrid[j][i].occupied = YES;
            bubblesGrid[j][i].color = arc4random() % 4;
        }
    }
}

- (void)initializeBubbleViewsInView:(UIView*)view {
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            if (bubblesGrid[j][i].occupied) {
                [view addSubview:bubblesGrid[j][i]];
            }
        }
    }
}

- (BOOL)checkCollisionWithActiveBubble:(Bubble *)activeBubble {
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (b.occupied) {
                CGFloat dist = sqrtf(powf(activeBubble.center.x - b.center.x, 2) +
                                     powf(activeBubble.center.y - b.center.y, 2));
                if (dist < BUBBLE_DIAMETER) {

                    Bubble *bubble = [self attachBubbleAtNearestAvailablePositionOfCollisionPoint:activeBubble];
                    return YES;
                    break;
                }
            }
        }
    }
    return NO;
}

- (Bubble*)attachBubbleAtNearestAvailablePositionOfCollisionPoint:(Bubble*)bubble {
    CGFloat minDist = INFINITY;
    int minJ, minI;
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
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
    
    bubble.center = bubblesGrid[minJ][minI].center;
    bubblesGrid[minJ][minI] = bubble;
    bubblesGrid[minJ][minI].occupied = YES;
    return bubble;
}

- (NSArray*)getAdjacentBubbles:(Bubble*)bubble {
    int row = bubble.row;
    int col = bubble.col;
    
    NSMutableArray *adjacentBubbles = [NSMutableArray new];
    
//     Top Left - @.@ - Top Right
//        Left - @.@.@ - Right
//  Bottom Left - @.@ - Bottom Right
    
    // Left Bubble
    if (col > 0) {
        Bubble *leftBubble = bubblesGrid[row][col-1];
        [adjacentBubbles addObject:leftBubble];
    }
    
    // Right Bubble
    if ((row%2 == 0 && col < NUMBER_OF_COLS-1) || // even row, non-last bubble in row
        (row%2 == 1 && col < NUMBER_OF_COLS-2)) { // odd row, one less bubble in row, and non-last bubble
        Bubble *rightBubble = bubblesGrid[row][col+1];
        [adjacentBubbles addObject:rightBubble];
    }
    
    // Top Left Bubble
    if (row%2 == 0 && row > 0 && col > 0) {
        Bubble *topLeftBubble = bubblesGrid[row-1][col-1];
        [adjacentBubbles addObject:topLeftBubble];
    } else if (row%2 == 1) {
        Bubble *topLeftBubble = bubblesGrid[row-1][col];
        [adjacentBubbles addObject:topLeftBubble];
    }
    
    // Bottom Left Bubble
    if (row%2 == 0 && row < NUMBER_OF_ROWS-1 && col > 0) {
        Bubble *bottomLeftBubble = bubblesGrid[row+1][col-1];
        [adjacentBubbles addObject:bottomLeftBubble];
    } else if (row%2 == 1 && row < NUMBER_OF_ROWS - 1) {
        Bubble *bottomLeftBubble = bubblesGrid[row+1][col];
        [adjacentBubbles addObject:bottomLeftBubble];
    }
    
    // Top Right Bubble
    if (row%2 == 0 && row > 0 && col < NUMBER_OF_COLS-1) {
        Bubble *topRightBubble = bubblesGrid[row-1][col];
        [adjacentBubbles addObject:topRightBubble];
    } else if (row%2 == 1 && col < NUMBER_OF_COLS-1) {
        Bubble *topRightBubble = bubblesGrid[row-1][col+1];
        [adjacentBubbles addObject:topRightBubble];
    }
    
    // Bottom Right Bubble
    if (row%2 == 0 && row < NUMBER_OF_ROWS-1 && col < NUMBER_OF_COLS-1) {
        Bubble *bottomRightBubble = bubblesGrid[row+1][col];
        [adjacentBubbles addObject:bottomRightBubble];
    } else if (row%2 == 1 && row < NUMBER_OF_ROWS-1 && col < NUMBER_OF_COLS-1) {
        Bubble *bottomRightBubble = bubblesGrid[row+1][col+1];
        [adjacentBubbles addObject:bottomRightBubble];
    }
    
    return [NSArray arrayWithArray:adjacentBubbles];
}

- (NSArray*)filterOccupiedBubbles:(NSArray*)bubbles {
    NSMutableArray *occupiedBubbles;
    for (Bubble *b in bubbles) {
        if (b.occupied) {
            [occupiedBubbles addObject:b];
        }
    }
    return [NSArray arrayWithArray:occupiedBubbles];
}

- (NSArray*)filterBubbles:(NSArray*)bubbles
                  ofColor:(BubbleColor)color {
    NSMutableArray *sameColorBubbles;
    for (Bubble *b in bubbles) {
        if (b.color == color) {
            [sameColorBubbles addObject:b];
        }
    }
    return [NSArray arrayWithArray:sameColorBubbles];
}



@end
