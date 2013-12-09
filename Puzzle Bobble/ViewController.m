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
#define SCREEN_WIDTH 768.f
#define SCREEN_HEIGHT 1024.f
#define BUBBLE_DIAMETER SCREEN_WIDTH/NUMBER_OF_BUBBLES_IN_ROW

@interface ViewController () {
    NSMutableArray *bubblesArray;
    NSTimer *timer;
    Bubble *activeBubble;
    CGPoint activeBubbleVelocity;
    UITapGestureRecognizer *tapRecognizer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    bubblesArray = [NSMutableArray array];
    [self initializeBubbles];
    tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(shootBubble:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)initializeBubbles {
    
    CGFloat rowOffset = BUBBLE_DIAMETER * sin(M_PI/3);

    for (int j = 0; j < 4; j++) {
        for (int i = 0; i < NUMBER_OF_BUBBLES_IN_ROW; i++) {
            Bubble *bubble = [[Bubble alloc] initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER, BUBBLE_DIAMETER)];
            bubble.backgroundColor = [UIColor redColor];
            bubble.layer.cornerRadius = BUBBLE_DIAMETER/2;
            [self.view addSubview:bubble];
            [bubblesArray addObject:bubble];
            if (j % 2 == 0) {
                bubble.center = CGPointMake(i * BUBBLE_DIAMETER + BUBBLE_DIAMETER/2,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
            } else {
                // odd rows have 1 less bubble
                bubble.center = CGPointMake((i+1) * BUBBLE_DIAMETER,
                                            j * rowOffset + BUBBLE_DIAMETER/2);
                if (i == NUMBER_OF_BUBBLES_IN_ROW - 2) { break; }
            }
        }
    }
}

- (void)shootBubble:(UITapGestureRecognizer *)recognizer {
    
    CGPoint dest = [recognizer locationInView:self.view];
    CGPoint start = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - BUBBLE_DIAMETER/2);
    
    activeBubbleVelocity = CGPointMake(-1*(dest.x - start.x)/(dest.y - start.y), -1);
    
    activeBubble = [[Bubble alloc] initWithFrame:CGRectMake(0, 0, BUBBLE_DIAMETER, BUBBLE_DIAMETER)];
    activeBubble.center = start;
    activeBubble.backgroundColor = [UIColor blueColor];
    activeBubble.layer.cornerRadius = BUBBLE_DIAMETER/2;
    [self.view addSubview:activeBubble];
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001f
                                    target:self
                                  selector:@selector(moveActiveBubble)
                                  userInfo:nil
                                   repeats:YES];
    tapRecognizer.enabled = NO;
}

- (void)moveActiveBubble {

    activeBubble.center = CGPointMake(activeBubbleVelocity.x + activeBubble.center.x,
                                      activeBubbleVelocity.y + activeBubble.center.y);
    for (Bubble *b in bubblesArray) {
        CGFloat dist = sqrtf(powf(activeBubble.center.x - b.center.x, 2) + powf(activeBubble.center.y - b.center.y, 2));
        if (dist < BUBBLE_DIAMETER) {
            [timer invalidate];
            [bubblesArray addObject:activeBubble];
            tapRecognizer.enabled = YES;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
