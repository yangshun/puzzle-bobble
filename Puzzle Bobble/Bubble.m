//
//  Bubble.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

@synthesize color;

- (id)initWithPosition:(CGPoint)pos row:(int)row col:(int)col {
    self = [self initWithPosition:pos];
    if (self) {
        self.row = row;
        self.col = col;
    }
    return self;
}

- (id)initWithPosition:(CGPoint)pos {
    self = [super initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER, BUBBLE_DIAMETER)];
    if (self) {
        // Initialization code
        self.center = pos;
        self.occupied = NO;
        self.layer.cornerRadius = BUBBLE_DIAMETER/2;
    }
    return self;
}

- (void)setColor:(BubbleColor)c {
    color = c;
    switch (c) {
        case Red:
            self.backgroundColor = [UIColor redColor];
            break;
        case Blue:
            self.backgroundColor = [UIColor blueColor];
            break;
        case Green:
            self.backgroundColor = [UIColor greenColor];
            break;
        case Yellow:
            self.backgroundColor = [UIColor yellowColor];
            break;
        default:
            self.backgroundColor = [UIColor blackColor];
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
