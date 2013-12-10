//
//  Constants.h
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#ifndef Puzzle_Bobble_Constants_h
#define Puzzle_Bobble_Constants_h


#define NUMBER_OF_ROWS 12
#define NUMBER_OF_BUBBLES_IN_ROW 8
#define SCREEN_WIDTH 768.f
#define SCREEN_HEIGHT 1024.f
#define BUBBLE_DIAMETER SCREEN_WIDTH/NUMBER_OF_BUBBLES_IN_ROW

typedef enum BubbleColor {
    Red = 0,
    Blue = 1,
    Green = 2,
    Yellow = 3,
} BubbleColor;

#endif
