//
//  ViewController.m
//  Puzzle Bobble
//
//  Created by YangShun on 9/12/13.
//  Copyright (c) 2013 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "BubbleArena.h"
#import "Bubble.h"

@interface ViewController () {

    NSTimer *timer;
    Bubble *activeBubble;
    CGPoint activeBubbleVelocity;
    UITapGestureRecognizer *tapRecognizer;
    BubbleArena *arena;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    arena = [[BubbleArena alloc] init];
    [arena initializeArenaModel];
    [arena initializeLevel];
    [arena initializeBubbleViewsInView:self.view];

    tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:self action:@selector(shootBubble:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];

}

- (void)shootBubble:(UITapGestureRecognizer *)recognizer {
    
    CGPoint dest = [recognizer locationInView:self.view];
    CGPoint start = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - BUBBLE_DIAMETER/2);
    
    activeBubbleVelocity = CGPointMake(-1*(dest.x - start.x)/(dest.y - start.y), -1);
    
    activeBubble = [[Bubble alloc] initWithPosition:start];
    activeBubble.color = Blue;
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
    if (activeBubble.center.x > SCREEN_WIDTH || activeBubble.center.x < 0) {
        activeBubbleVelocity.x *= -1;
    }
    
    if ([arena checkCollisionWithActiveBubble:activeBubble]) {
        [timer invalidate];
        tapRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
