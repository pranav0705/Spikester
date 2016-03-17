//
//  ViewController.m
//  p06-Spikester
//
//  Created by Tanmay Kale on 3/14/16.
//  Copyright © 2016 tkale1. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController
@synthesize bear;
bool muteOn;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Adding background image to the main screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //Fetching the size(Height, Width) of the Screen
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //adding bearcat image to the center of the main screen
    bear = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-25, screenHeight/2-25, 100, 100)];
    bear.image=[UIImage imageNamed:@"bearcatfront.png"];
    [self.view addSubview: bear];
    [self bearcatAnimation];
    
}

- (void)bearcatAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.4;
    animation.repeatCount = 1000;
    animation.fromValue = [NSValue valueWithCGPoint:bear.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(bear.center.x, bear.center.y-30)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    [bear.layer addAnimation:animation forKey:@"position"];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
