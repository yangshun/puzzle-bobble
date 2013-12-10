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
}

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initializeArenaModel {
    
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            if (j % 2 == 1 && i == NUMBER_OF_COLS - 1) {
                continue;
            } else {
                [self initializeEmptyBubbleAtRow:j Col:i];
            }
        }
    }
}

- (void)initializeEmptyBubbleAtRow:(int)row Col:(int)col {
    
    CGFloat rowOffset = BUBBLE_DIAMETER * sin(M_PI/3);
    CGPoint position;
    if (row % 2 == 0) {
        position = CGPointMake(col * BUBBLE_DIAMETER + BUBBLE_DIAMETER/2,
                               row * rowOffset + BUBBLE_DIAMETER/2);
    } else {
        // odd rows have 1 less bubble
        position = CGPointMake((col+1) * BUBBLE_DIAMETER,
                               row * rowOffset + BUBBLE_DIAMETER/2);
    }
    Bubble *b = [[Bubble alloc] initWithPosition:position
                                             row:row
                                             col:col];
    bubblesGrid[row][col] = b;
}

- (void)initializeLevel {
    // code to read from file here
    
    // hardcoded level 1
    for (int j = 0; j < 4; j++) {
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
    BOOL collision = NO;
    
    // Check for collision with other bubbles
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (b.occupied) {
                CGFloat dist = sqrtf(powf(activeBubble.center.x - b.center.x, 2) +
                                     powf(activeBubble.center.y - b.center.y, 2));
                if (dist < BUBBLE_DIAMETER) {
                    collision = YES;
                }
            }
        }
    }
    
    // Check for collision with top wall
    if (activeBubble.center.y < BUBBLE_DIAMETER/2) {
        collision = YES;
    }
    
    if (collision) {
        Bubble *bubble = [self attachBubbleAtNearestAvailablePositionOfCollisionPoint:activeBubble];
        [self handleCollisionOfActiveBubble:bubble];
    }
    
    return collision;
}

- (void)handleCollisionOfActiveBubble:(Bubble*)bubble {

    NSSet *adjacentColoredBubbles = [self getAdjacentBubblesOfBubble:bubble andSameColor:YES];
    if (adjacentColoredBubbles.count >= 3) {
        [self removeBubbles:adjacentColoredBubbles withBurstAnimation:YES];
    }
    
    NSMutableSet *bubblesAttachedToTop = [NSMutableSet new];
    for (int i = 0; i < NUMBER_OF_COLS; i++) {
        Bubble *b = bubblesGrid[0][i];
        if (b.occupied) {
            NSSet *adjacentBubbles = [self getAdjacentBubblesOfBubble:b andSameColor:NO];
            [bubblesAttachedToTop unionSet:adjacentBubbles];
        }
    }
    
    NSMutableSet *allOccupiedBubbles = [NSMutableSet new];
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (b.occupied) {
                [allOccupiedBubbles addObject:b];
            }
        }
    }
    
    [allOccupiedBubbles minusSet:bubblesAttachedToTop];

    [self removeBubbles:allOccupiedBubbles withBurstAnimation:NO];
}

- (void)removeBubbles:(NSSet*)bubbles withBurstAnimation:(BOOL)burst {
    for (Bubble *b in bubbles) {
        if (burst) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 b.alpha = 0.0f;
                                 b.transform = CGAffineTransformMakeScale(1.5, 1.5);
                             }
                             completion:^(BOOL finished){
                                 [b removeFromSuperview];
                             }];
        } else {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 b.center = CGPointMake(b.center.x, b.center.y + SCREEN_HEIGHT);
                             }
                             completion:^(BOOL finished){
                                 [b removeFromSuperview];
                             }];
        }
        [self initializeEmptyBubbleAtRow:b.row Col:b.col];
    }
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
    bubble.row = minJ;
    bubble.col = minI;
    bubblesGrid[minJ][minI].occupied = YES;

    return bubble;
}

- (NSSet*)getAdjacentBubblesOfBubble:(Bubble*)bubble andSameColor:(BOOL)same {
    
    // modified breadth-first search
    Queue *q = [Queue new];
    NSMutableSet *V = [NSMutableSet new];
    [q enqueue:bubble];
    [V addObject:bubble];
    
    while (![q isEmpty]) {
        Bubble *t = [q dequeue];
  
        NSArray *adj = [self filterOccupiedBubbles: [self getAdjacentBubbles:t]];
        if (same) {
            adj = [self filterBubbles:adj ofColor:bubble.color];
        }

        for (Bubble *b in adj) {
            if (![V containsObject:b]) {
                [V addObject:b];
                [q enqueue:b];
            }
        }
        
    }
    return V;
    
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
    } else if (row%2 == 1 && row < NUMBER_OF_ROWS-1) {
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
    NSMutableArray *occupiedBubbles = [NSMutableArray new];
    for (Bubble *b in bubbles) {
        if (b.occupied) {
            [occupiedBubbles addObject:b];
        }
    }
    return [NSArray arrayWithArray:occupiedBubbles];
}

- (NSArray*)filterBubbles:(NSArray*)bubbles
                  ofColor:(BubbleColor)color {
    NSMutableArray *sameColorBubbles = [NSMutableArray new];
    for (Bubble *b in bubbles) {
        if (b.color == color) {
            [sameColorBubbles addObject:b];
        }
    }
    return [NSArray arrayWithArray:sameColorBubbles];
}


- (BubbleColor)getNextBubbleColor {
    NSMutableSet *availableColorSet = [NSMutableSet new];
    for (int j = 0; j < NUMBER_OF_ROWS; j++) {
        for (int i = 0; i < NUMBER_OF_COLS; i++) {
            Bubble *b = bubblesGrid[j][i];
            if (b.occupied) {
                [availableColorSet addObject:[NSNumber numberWithInt:b.color]];
            }
        }
    }
    NSArray *availableColorArray = [availableColorSet allObjects];

    int length = availableColorArray.count;
    if (length > 0) {
        return ((NSNumber*)availableColorArray[arc4random()%length]).intValue;
    } else {
        // defaults to red
        return Red;
    }
}

@end
