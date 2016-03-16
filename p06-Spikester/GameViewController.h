//
//  GameViewController.h
//  p06-Spikester
//
//  Created by Tejas Nadkarni on 15/03/16.
//  Copyright © 2016 tkale1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Spikes.h"


@interface GameViewController : UIViewController
{
    SystemSoundID jumpSound;
    SystemSoundID walltouchSound;
    SystemSoundID gameoverSound;
}
@property (strong, nonatomic) IBOutlet UIImageView *bear;
@property (strong, nonatomic) IBOutlet UIImageView *trophy;
@property (strong, nonatomic) IBOutlet UIView *score;
@property (nonatomic, strong) NSMutableArray * upspikes;
@property (nonatomic, strong) NSMutableArray * downspikes;
@property (nonatomic, strong) NSMutableArray * leftspikes;
@property (nonatomic, strong) NSMutableArray * rightspikes;


@property (nonatomic, strong) NSTimer *timer;
@end


