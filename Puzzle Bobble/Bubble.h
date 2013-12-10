//
//  Bubble.h
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface Bubble : UIImageView

@property (nonatomic, assign) BOOL occupied;
@property (nonatomic, assign) BubbleColor color;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int col;
@property (nonatomic, assign) BOOL visited;

- (id)initWithPosition:(CGPoint)pos;


@end
