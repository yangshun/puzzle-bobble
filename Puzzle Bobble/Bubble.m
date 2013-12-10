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
            self.image = [UIImage imageNamed:@"bubble-red"];
            break;
        case Blue:
            self.image = [UIImage imageNamed:@"bubble-blue"];
            break;
        case Green:
            self.image = [UIImage imageNamed:@"bubble-green"];
            break;
        case Orange:
            self.image = [UIImage imageNamed:@"bubble-orange"];
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
