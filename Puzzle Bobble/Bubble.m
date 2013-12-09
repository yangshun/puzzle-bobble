//
//  Bubble.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

- (id)initWithPosition:(CGPoint)pos {
    self = [super initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER, BUBBLE_DIAMETER)];
    if (self) {
        // Initialization code
        self.center = pos;
        self.occupied = false;
        self.layer.cornerRadius = BUBBLE_DIAMETER/2;
    }
    return self;
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
