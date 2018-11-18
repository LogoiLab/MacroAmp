//
//  PlayerView.h
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SongSelectionView.h"
#import "AppNavigationController.h"
#import "MacroAmpController.h"


@interface PlayerView : UIViewController <SongSelectionDelegate, MacroAmpControllerDelegate>
{
    SongSelectionView *ssv;
    AppNavigationController *songSelectionNav;
    int sessionID;
    AVAudioPlayer *player;
    int masterTime;
    NSTimer *playTimer;
}
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImage;
@property (strong, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *songPositionSlider;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

-(void)setSessionID:(int)ID;
- (IBAction)sliderValueChanged:(UISlider *)sender;
-(void)didSelectAudioFile:(NSString *)path;
- (IBAction)playPause:(id)sender;

@end
