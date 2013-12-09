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

@property BOOL occupied;

- (id)initWithPosition:(CGPoint)pos;

@end
