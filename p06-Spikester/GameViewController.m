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

CAShapeLayer *circleLayer;
int checkSide = 0; //RIGHT side is 0 and LEFT side is 1


@implementation GameViewController
@synthesize bear,score,trophy;
@synthesize upspikes, downspikes, leftspikes, rightspikes;
@synthesize timer;


- (void) jumpSoundPlay
{
    AudioServicesPlaySystemSound(jumpSound);
}

- (void) wallTouchSoundPlay
{
    AudioServicesPlaySystemSound(walltouchSound);
}

- (void) gameOverSoundPlay
{
    AudioServicesPlaySystemSound(gameoverSound);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    
	
    NSURL *jumpUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jump" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)jumpUrl,&jumpSound);
    NSURL *touchUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"touch" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)touchUrl,&walltouchSound);
    NSURL *gameOverUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameover" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)gameOverUrl,&gameoverSound);
    
    upspikes = [NSMutableArray array];
    downspikes = [NSMutableArray array];
    leftspikes = [NSMutableArray array];
    rightspikes = [NSMutableArray array];

    //Add tropy random generation
	[self addTrophy];
	
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
    
    [circleLayer setStrokeColor:[[UIColor blackColor] CGColor]];
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
    //NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[downspikes objectAtIndex:j];
        if (CGRectIntersectsRect(bear.frame, x.frame))
        {
            
           // [bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
            [BirdMovement invalidate];
            [collison invalidate];
            [self rotateImage];
        }
    }
    
    //upside
    NSUInteger arraySize3 = [upspikes count];
  //  NSLog(@"count :- %lu",(unsigned long)arraySize);
    for(int j=0; j<arraySize3; j++){
        //for(UIImageView *image in downspikes) {
        UIImageView *x =[upspikes objectAtIndex:j];
        if (CGRectIntersectsRect(bear.frame, x.frame))
        {
            //[bear setFrame:CGRectMake(bear.center.x - 23, bear.center.y - 35, 50, 50)];
            [BirdMovement invalidate];
            [collison invalidate];
            [self rotateImage];
        }
    }
    
    
    //right side
    NSUInteger arraySize1 = [rightspikes count];
  //  NSLog(@"count :- %lu",(unsigned long)arraySize);
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
            [self rotateImage];
            }
        }
    }
    
    
    //left side
    NSUInteger arraySize2 = [leftspikes count];
    //NSLog(@"count :- %lu",(unsigned long)arraySize);
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
                [self rotateImage];
            }
        }
    }
    
    if (CGRectIntersectsRect(bear.frame, trophy.frame))
    {
        trophy.hidden=true;
        [self addTrophy];
    }
    
}

-(void)addTrophy{


    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //random trophy generation for bearcat
    int xValue = (arc4random() % (int) screenWidth);
    int yValue = (arc4random() % (int) screenHeight);

		
		trophy = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue, 25, 25)];
		trophy.image = [UIImage imageNamed:@"fish.png"];

		//add the view to the main view
		[self.view addSubview:trophy];
	
}


-(void)BirdMoving{
    
	//LEFT AND RIGHT WALL ON TOUCH
    if ((bear.center.x - 40) < 10) {
        flg = 1;
        scr_counter++;
        
        //animation for text changing
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = 0.75;
        [lbl1.layer addAnimation:animation forKey:@"kCATransitionFade"];
        
        //This will fade:
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat1.gif"]];
        
       
        
        [self randomSpikes];
        [self wallTouchSoundPlay];
    }
    if ((bear.center.x + 40) >= screenWidth)
    {
        flg = 0;
        //bear.center = CGPointMake(bear.center.x - 10, bear.center.y - BearFlight);
        scr_counter++;
        //animation for text changing
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = 0.75;
        [lbl1.layer addAnimation:animation forKey:@"kCATransitionFade"];
        
        // This will fade:
        [lbl1 setText:[NSString stringWithFormat:@"%d",scr_counter]];
        [bear setImage:[UIImage imageNamed:@"bearcat.gif"]];
        [self randomSpikes];
        //play touch wall sound
        [self wallTouchSoundPlay];
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

// SPIKES GENERATION FOR UP DOWN LEFT AND RIGHT
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
    
    
    //hiding left/right side spikes
    for(int k=0; k<11; k++)
    {
        
        //hiding right side spikes
        UILabel *x =[rightspikes objectAtIndex:k];
        x.hidden = YES;
        //hiding left side spikes
        x =[leftspikes objectAtIndex:k];
        x.hidden = YES;
    }
}

-(void)randomSpikes
{
    int max=11,min=0;
    
    if(checkSide == 0)
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
        checkSide = 1;
        
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
        checkSide = 0;
    }
}

// HIDE SPIKES WITH ANIMATION
- (void)hideSpikesAnimate:(UIImageView *)imageView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [imageView.layer addAnimation:transition forKey:nil];
    imageView.hidden = YES;
}

// SHOW SPIKES WITH ANIMATION
- (void)showSpikesAnimate:(UIImageView *)imageView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [imageView.layer addAnimation:transition forKey:nil];
    imageView.hidden = NO;
}

//code to rotate image on game over
-(void)rotateImage{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.50]; // Set how long your animation goes for
    [UIView setAnimationRepeatCount:10000];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    bear.transform = CGAffineTransformMakeRotation(360); // if angle is in radians
    
    // if you want to use degrees instead of radians add the following above your @implementation
    // #define degreesToRadians(x)(x * M_PI / 180)
    // and change the above code to: player.transform = CGAffineTransformMakeRotation(degreesToRadians(angle));
    
    [UIView commitAnimations];
    
    [self gameOverSoundPlay];
    
    // The rotation code above will rotate your object to the angle and not rotate beyond that.
    // If you want to rotate the object again but continue from the current angle, use this instead:
    // player.transform = CGAffineTransformRotate(player.transform, degreesToRadians(angle));
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //play jump sound on touch
    [self jumpSoundPlay];
    
    BearFlight = 20;
}
@end
