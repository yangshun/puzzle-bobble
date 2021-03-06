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
    CGPoint activeBubbleStartPosition;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    arena = [[BubbleArena alloc] initWithView:self.view];
    [arena prepareLevel];

    tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:self action:@selector(shootBubble:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    
    activeBubbleStartPosition = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - BUBBLE_DIAMETER/2);
    [self prepareBubbleToBeFired];

}

- (void)prepareBubbleToBeFired {
    [activeBubble removeFromSuperview];
    activeBubble = [[Bubble alloc] initWithPosition:activeBubbleStartPosition];
    activeBubble.color = [arena getNextBubbleColor];
    activeBubble.layer.cornerRadius = BUBBLE_DIAMETER/2;
    [self.view addSubview:activeBubble];

}

- (void)shootBubble:(UITapGestureRecognizer *)recognizer {
    
    CGPoint dest = [recognizer locationInView:self.view];
    
    activeBubbleVelocity = CGPointMake(-1*(dest.x - activeBubbleStartPosition.x)/
                                       (dest.y - activeBubbleStartPosition.y),
                                       -1);
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.005f
                                    target:self
                                  selector:@selector(moveActiveBubble)
                                  userInfo:nil
                                   repeats:YES];
    tapRecognizer.enabled = NO;
}

- (void)moveActiveBubble {

    activeBubble.center = CGPointMake(10 * activeBubbleVelocity.x + activeBubble.center.x,
                                      10 * activeBubbleVelocity.y + activeBubble.center.y);
    if (activeBubble.center.x > SCREEN_WIDTH - BUBBLE_DIAMETER/2 || activeBubble.center.x < BUBBLE_DIAMETER/2) {
        activeBubbleVelocity.x *= -1;
    }
    
    if ([arena checkCollisionWithActiveBubble:activeBubble]) {
        activeBubble = nil;
        [timer invalidate];
        tapRecognizer.enabled = YES;
        [self prepareBubbleToBeFired];
    }
}


- (IBAction)resetGame:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Level"
                                                    message:@"Are you sure you want to reset the level?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Reset Level"] && buttonIndex == 1) {
        [arena resetLevel];
        [self prepareBubbleToBeFired];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
