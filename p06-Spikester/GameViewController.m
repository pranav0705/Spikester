//
//  GameViewController.m
//  p06-Spikester
//
//  Created by Tejas Nadkarni on 15/03/16.
//  Copyright © 2016 tkale1. All rights reserved.
//

#import "GameViewController.h"
#import "Spikes.h"

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
	
	[self generatingSpikes];
    //getting screen sizes
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    //setting the image
    //[bear setFrame:CGRectMake(screenWidth/2, screenHeight/2, 20, 20)];
	
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BirdMoving{
    
    //bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
    
    if ((bear.center.x - 40) < 10) {
        //  bear.center = CGPointMake(bear.center.x + 10, bear.center.y - BearFlight);
        flg = 1;
        NSLog(@"coords: %f",bear.center.x);
        scr_counter++;
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat1.png"]];
    }
    if ((bear.center.x + 40) >= screenWidth)
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

- (void) generatingSpikes {
	CGRect screenBound = [[UIScreen mainScreen] bounds];
	CGSize screenSize = screenBound.size;
	CGFloat screenWidth = screenSize.width;
	CGFloat screenHeight = screenSize.height;
	
	int widthspikes = screenWidth/8;
	
	//DOWN SPIKES
	int x=0;
	int y=screenHeight - widthspikes;
	// Do any additional setup after loading the view.
	for(int i =0;i < 8; i++)
	{
		//You need to specify the frame of the view
		UIView *spikeView = [[UIView alloc] initWithFrame:CGRectMake(x, y, widthspikes, widthspikes)];
		
		UIImage *spikeImage = [UIImage imageNamed:@"spike.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:spikeImage];
		
		//specify the frame of the imageView in the superview , here it will fill the superview
		imageView.frame = spikeView.bounds;
		
		// add the imageview to the superview
		[spikeView addSubview:imageView];
		
		//add the view to the main view
		
		[self.view addSubview:spikeView];
		
		x += widthspikes + 2;
	}
	
	//UP SPIKES
	x = 0; y =0;
	//int spikesnum = screenWidth/8;
	// Do any additional setup after loading the view.
	for(int i =0;i < 8; i++)
	{
		//You need to specify the frame of the view
		UIView *spikeView = [[UIView alloc] initWithFrame:CGRectMake(x, y, widthspikes, widthspikes)];
		
		UIImage *spikeImage = [UIImage imageNamed:@"spike.png"];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:spikeImage];
		
		imageView.transform = CGAffineTransformMakeRotation(3.14);
		
		//specify the frame of the imageView in the superview , here it will fill the superview
		imageView.frame = spikeView.bounds;
		
		// add the imageview to the superview
		[spikeView addSubview:imageView];
		
		//add the view to the main view
		
		[self.view addSubview:spikeView];
		
		x += widthspikes + 2;
	}
	
	//LEFT SPIKES
	x = 0; y =0;
	int x1 = screenHeight/widthspikes;
	for(int i =0;i < x1; i++)
	{
		int hlength = (screenHeight - 3*(widthspikes));
		if(y >= hlength)
		{
			break;
		}
		
		//You need to specify the frame of the view
		UIView *spikeView = [[UIView alloc] initWithFrame:CGRectMake(x-10, (y + widthspikes + 20), widthspikes, widthspikes)];
		
		UIImage *spikeImage = [UIImage imageNamed:@"spike.png"];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:spikeImage];
		
		imageView.transform = CGAffineTransformMakeRotation(3.14/2);
		
		//specify the frame of the imageView in the superview , here it will fill the superview
		imageView.frame = spikeView.bounds;
		
		// add the imageview to the superview
		[spikeView addSubview:imageView];
		
		//add the view to the main view
		
		[self.view addSubview:spikeView];
		
		y += widthspikes + 3;
	}
	
	//RIGHT SPIKES
	x = screenWidth; y =0;
	for(int i =0;i < x1; i++)
	{
		int hlength = (screenHeight - 3*(widthspikes));
		if(y >= hlength)
		{
			break;
		}
		
		//You need to specify the frame of the view
		UIView *spikeView = [[UIView alloc] initWithFrame:CGRectMake((x - widthspikes + 10), (y + widthspikes + 20), widthspikes, widthspikes)];
		
		UIImage *spikeImage = [UIImage imageNamed:@"spike.png"];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:spikeImage];
		
		imageView.transform = CGAffineTransformMakeRotation(3.14 * 3/2);
		
		//specify the frame of the imageView in the superview , here it will fill the superview
		imageView.frame = spikeView.bounds;
		
		// add the imageview to the superview
		[spikeView addSubview:imageView];
		
		//add the view to the main view
		
		[self.view addSubview:spikeView];
		
		y += widthspikes + 3;
	}
	
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BearFlight = 30;
}
@end
