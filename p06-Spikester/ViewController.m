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
@synthesize  sound,credit,shop;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"2.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    int startX=screenWidth/6;
    
    sound = [[UIView alloc] initWithFrame:CGRectMake((startX/2)+1, screenHeight-110, 70, 70)];
    [self.view addSubview:sound];
    [sound setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"abc.png"]]];

    shop = [[UIView alloc] initWithFrame:CGRectMake((startX*3)+1-(startX/2), screenHeight-110, 70, 70)];
    [self.view addSubview:shop];
    [shop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"abc.png"]]];
    
    credit = [[UIView alloc] initWithFrame:CGRectMake((startX*5)+1-(startX/2), screenHeight-110, 70, 70)];
    [self.view addSubview:credit];
    [credit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"abc.png"]]];
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
