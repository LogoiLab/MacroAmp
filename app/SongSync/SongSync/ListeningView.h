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
#import "MacroAmpController.h"

@interface ListeningView : UIViewController <MacroAmpControllerDelegate>
{
    int masterTime;
    AVAudioPlayer *player;
    NSTimer *playTimer;
    UIImage *artworkImage;
    int sessionID;
}
@property (strong, nonatomic) IBOutlet UISlider *songPositionSlider;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImage;
-(void)beginPlayingAudio:(NSString *)path withSessionID:(int)ID;


@end
