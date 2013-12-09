//
//  ViewController.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "Bubble.h"

#define NUMBER_OF_BUBBLES_IN_ROW 8

@interface ViewController () {
    NSMutableArray *bubblesArray;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    bubblesArray = [NSMutableArray array];
    [self initializeBubbles];
}

- (void)initializeBubbles {
    
    CGFloat bubbleDiameter = self.view.frame.size.width/NUMBER_OF_BUBBLES_IN_ROW;
    CGFloat rowOffset = bubbleDiameter * sin(M_PI/3);

    for (int j = 0; j < 7; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            Bubble *bubble = [[Bubble alloc] initWithFrame:CGRectMake(0, 0, bubbleDiameter, bubbleDiameter)];
            bubble.backgroundColor = [UIColor redColor];
            bubble.layer.cornerRadius = bubbleDiameter/2;
            [self.view addSubview:bubble];
            [bubblesArray addObject:bubble];
            if (j % 2 == 0) {
                bubble.center = CGPointMake(i * bubbleDiameter + bubbleDiameter/2,
                                            j * rowOffset + bubbleDiameter/2);
            } else {
                // odd rows have 1 less bubble
                bubble.center = CGPointMake((i+1) * bubbleDiameter,
                                            j * rowOffset + bubbleDiameter/2);
                if (i == NUMBER_OF_BUBBLES_IN_ROW - 2) { break; }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
