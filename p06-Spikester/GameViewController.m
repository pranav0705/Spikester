//
//  GameViewController.m
//  p06-Spikester
//
//  Created by Tejas Nadkarni on 15/03/16.
//  Copyright © 2016 tkale1. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

UIDynamicAnimator* _animator;
UIGravityBehavior* _gravity;
UICollisionBehavior* _collision; //setting boundaries of falling
NSTimer *BirdMovement;
CGRect screenRect;
CGFloat screenWidth;
CGFloat screenHeight;
int flg = 0;
int BearFlight;
@implementation GameViewController
@synthesize bear;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //getting screen sizes
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    //setting the image
    //[bear setFrame:CGRectMake(screenWidth/2, screenHeight/2, 20, 20)];
    
//    CGPoint centerImageView = bear.center;
//    centerImageView.x = self.view.center.x;
//    bear.center = centerImageView;
    
    //setting bear image
    [bear setImage:[UIImage imageNamed:@"bearcat.png"]];
    
    //creating circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(screenWidth/2 - 50, screenHeight/2 - 50, 100, 100)] CGPath]];
    
    [[self.view layer] addSublayer:circleLayer];
    
    [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    
    //creating outer circle
    CAShapeLayer *circleLayer1 = [CAShapeLayer layer];
    [circleLayer1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(screenWidth/2 - 60, screenHeight/2 - 60, 120, 120)] CGPath]];
    
    [[self.view layer] addSublayer:circleLayer1];
    
    [circleLayer1 setStrokeColor:[[UIColor redColor] CGColor]];
    [circleLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    
    
    //timer
    BirdMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BirdMoving) userInfo:nil repeats:YES];
    
    
    
    /*  //animation for falling
     _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
     _gravity = [[UIGravityBehavior alloc] initWithItems:@[bear]];
     [_animator addBehavior:_gravity];
     
     //setting boundaries
     _collision = [[UICollisionBehavior alloc]
     initWithItems:@[bear]];
     _collision.translatesReferenceBoundsIntoBoundary = YES;
     [_animator addBehavior:_collision];  */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BirdMoving{
    
    //bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
    
    if ((bear.center.x - 50) < 10) {
        //  bear.center = CGPointMake(bear.center.x + 10, bear.center.y - BearFlight);
        flg = 1;
        NSLog(@"coords: %f",bear.center.x);
    }
    if ((bear.center.x + 50) >= screenWidth)
    {
        flg = 0;
        // bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
    }
    
    if(flg == 1)
    {
        bear.center = CGPointMake(bear.center.x + 10, bear.center.y - BearFlight);
    }
    else
    {
        bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
    }
    BearFlight = BearFlight - 5;
    
    /*  if (BearFlight < -15) {
     BearFlight = -15;
     } */
    
    
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BearFlight = 30;
    
}

@end
