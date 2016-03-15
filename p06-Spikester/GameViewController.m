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
UILabel *lbl1;
CGFloat screenHeight;
int flg = 0,scr_counter = 0;
int BearFlight;
@implementation GameViewController
@synthesize bear,score;

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
    
    
    //score
    self.score = [[UIView alloc] initWithFrame:CGRectMake(10,20,100,100)];
    self.score.alpha = 0.5;
    self.score.layer.cornerRadius = 50;
    self.score.backgroundColor = [UIColor blueColor];
    
    
    
    //creating circle
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(screenWidth/2 - 50, screenHeight/2 - 50, 100, 100)] CGPath]];
    
    [[self.view layer] addSublayer:circleLayer];
    
    [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    
   
    
    
    //setting score
    lbl1 = [[UILabel alloc] init];
    [lbl1 setFrame:CGRectMake(screenWidth/2 - 40,screenHeight/2 - 40,80,80)];
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.textColor=[UIColor blackColor];
    lbl1.userInteractionEnabled=YES;
    lbl1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl1];
    lbl1.text= @"0";
    
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
        scr_counter++;
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat1.png"]];
    }
    if ((bear.center.x + 50) >= screenWidth)
    {
        flg = 0;
        // bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
        scr_counter++;
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat.png"]];
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
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BearFlight = 30;
}

@end
