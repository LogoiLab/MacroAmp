//
//  ListeningView.h
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ListeningView : UIViewController
{
    int masterTime;
    AVAudioPlayer *player;
    NSTimer *playTimer;
}
@property (strong, nonatomic) IBOutlet UISlider *songPositionSlider;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
-(void)beginPlayingAudio:(NSString *)path;

@end
