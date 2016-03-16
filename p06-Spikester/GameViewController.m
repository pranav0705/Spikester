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
NSTimer *BirdMovement,*collison;
CGRect screenRect;
CGFloat screenWidth;
UILabel *lbl1;
CGFloat screenHeight;
int flg = 0,scr_counter = 0;
int BearFlight;

int checkSide = 0; //RIGHT side is 0 and LEFT side is 1


@implementation GameViewController
@synthesize bear,score,bearcatview;
@synthesize upspikes, downspikes, leftspikes, rightspikes;
@synthesize timer;
CAShapeLayer *circleLayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
    upspikes = [NSMutableArray array];
    downspikes = [NSMutableArray array];
    leftspikes = [NSMutableArray array];
    rightspikes = [NSMutableArray array];
    
	[self generatingSpikes];
    //getting screen sizes
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    //setting the image
    //[bear setFrame:CGRectMake(screenWidth/2, screenHeight/2, 20, 20)];
	
    //setting bear image
    //self.bearcatview = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2,screenHeight/2,50,50)];
    //self.bearcatview.backgroundColor = [UIColor blueColor];
    
    bear = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, screenHeight/2, 50, 50)];
    bear.image=[UIImage imageNamed:@"bearcat.gif"];
    [self.view addSubview: bear];

    //[bear setImage:[UIImage imageNamed:@"bearcat.gif"]];
	
    //score
    self.score = [[UIView alloc] initWithFrame:CGRectMake(10,20,100,100)];
    self.score.alpha = 0.5;
    self.score.layer.cornerRadius = 50;
    self.score.backgroundColor = [UIColor blueColor];
	
    //creating circle
    circleLayer = [CAShapeLayer layer];
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
    BirdMovement = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(BirdMoving) userInfo:nil repeats:YES];
    
    collison = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(Coll) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Coll{
    //code for intersection
    NSUInteger arraySize = [downspikes count];
    NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[downspikes objectAtIndex:j];
        if (CGRectIntersectsRect(bear.frame, x.frame))
        {
            [bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
            [BirdMovement invalidate];
            [collison invalidate];
        }
    }
    
    //upside
    NSUInteger arraySize3 = [upspikes count];
    NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize3; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[upspikes objectAtIndex:j];
        if (CGRectIntersectsRect(bear.frame, x.frame))
        {
            //[bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
            [BirdMovement invalidate];
            [collison invalidate];
        }
    }
    
    
    //right side
    NSUInteger arraySize1 = [rightspikes count];
    NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize1; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[rightspikes objectAtIndex:j];
        
        if(x.hidden == NO)
        {
        if (CGRectIntersectsRect(bear.frame, x.frame))
            
        {
                //[bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
                [BirdMovement invalidate];
                [collison invalidate];
            }
        }
    }
    
    
    //left side
    NSUInteger arraySize2 = [leftspikes count];
    NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize2; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[leftspikes objectAtIndex:j];
        
        if(x.hidden == NO)
        {
            if (CGRectIntersectsRect(bear.frame, x.frame))
                
            {
                //[bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
                [BirdMovement invalidate];
                [collison invalidate];
            }
        }
    }
    
}

-(void)BirdMoving{
    
    
    //HIDE LEFT AND RIGHT SPIKES
    
    //bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
    
    if ((bear.center.x - 40) < 10) {
        //  bear.center = CGPointMake(bear.center.x + 10, bear.center.y - BearFlight);
        flg = 1;
        NSLog(@"coords: %f",bear.center.x);
        scr_counter++;
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat1.gif"]];
        
       
        
        [self randomSpikes];
    }
    if ((bear.center.x + 40) >= screenWidth)
    {
        flg = 0;
        // bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
        scr_counter++;
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat.gif"]];
        [self randomSpikes];
        
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
        
        //add spikes to array
        [downspikes addObject:spikeView];
		
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
        
         //add spikes to array
        [upspikes addObject:spikeView];
		
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
        
        //add spikes to array
        [leftspikes addObject:spikeView];
        
        //[imageView release];
		
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
        
        //add spikes to array
        [rightspikes addObject:spikeView];
		
		y += widthspikes + 3;
	}
    
    
    //hiding left side spikes
    for(int k=0; k<11; k++)
    {
        
        //hiding right side spikes
        
        UILabel *x =[rightspikes objectAtIndex:k];
        x.hidden = YES;
        x =[leftspikes objectAtIndex:k];
        x.hidden = YES;
    }
    
    
 //   timer = [NSTimer scheduledTimerWithTimeInterval:2	target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
    
 
    
}

//-(void)timerEvent:(id)sender

-(void)randomSpikes
{
    int max=11,min=0;
    
    if(checkSide == 1)
    {
        //show right side spikes
        for (int i=0;i< 3; i++)
        {
            int randNum = rand() % (max - min) + min; //create the random number.
            for(int k=0; k<11; k++)
            {
                if(randNum == k)
                {
                    UIImageView *x =[rightspikes objectAtIndex:k];
                    //x.hidden = NO;
                    [self showSpikesAnimate:x];
                }
            }
        }
        
        //HIDE LEFT SPIKES
        for(int k=0; k<11; k++)
        {
            UIImageView *x =[leftspikes objectAtIndex:k];
            
            //x.hidden = YES;
            [self hideSpikesAnimate:x];
        }
        checkSide = 0;
        
    }else{
        //show left side spikes
        for (int i=0;i< 3; i++)
        {
            int randNum = rand() % (max - min) + min; //create the random number.
            for(int k=0; k<11; k++)
            {
                if(randNum == k)
                {
                    UIImageView *x =[leftspikes objectAtIndex:k];
                    //x.hidden = NO;
                    [self showSpikesAnimate:x];
                }
            }
        }
        
        //HIDE RIGHT SPIKES
        for(int k=0; k<11; k++)
        {
            UIImageView *x =[rightspikes objectAtIndex:k];
            
            //x.hidden = YES;
            [self hideSpikesAnimate:x];
        }
        checkSide = 1;
        
    }

}

- (void)hideSpikesAnimate:(UIImageView *)imageView
{
    imageView.alpha = 1.0f;
    // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        imageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        imageView.hidden = YES;
    }];
}

- (void)showSpikesAnimate:(UIImageView *)imageView
{
    imageView.alpha = 1.0f;
    // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        imageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        imageView.hidden = NO;
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BearFlight = 20;
}
@end
