//
//  ListeningView.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "ListeningView.h"

@interface ListeningView ()

@end

@implementation ListeningView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"test-art.jpg"]]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Leave Session" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMainMenu)]];
    [self.volumeSlider setValue:[[MPMusicPlayerController systemMusicPlayer] volume]];
    [self.songPositionSlider setMaximumValue:[player duration]];
    self.albumArtImage.image = artworkImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}
-(void)didSetPaused:(BOOL)isPaused
{
    if (isPaused)
    {
        if (playTimer)
        {
            [playTimer invalidate];
        }
        [player pause];
    }
    else
    {
        playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [player play];
    }
}
-(void)setPlayerTime:(int)time
{
    [player setCurrentTime:time];
}
-(void)beginPlayingAudio:(NSString *)path withSessionID:(int)ID
{
    sessionID = ID;
    [MacroAmpController sharedInstance].delegate=self;
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSLog(@"URL: %@", [fileURL absoluteString]);
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    if (asset != nil) {
        NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                               withKey:AVMetadataCommonKeyArtwork
                                                              keySpace:AVMetadataKeySpaceCommon];
            
            for (AVMetadataItem *item in artworks) {
                if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                    
                    // *** WE TEST THE IOS VERSION HERE ***
                    
                    if (TARGET_OS_IPHONE && NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
                        NSData *newImage = [item.value copyWithZone:nil];
                        artworkImage = [UIImage imageWithData:newImage];
                    }
                    else {
                        NSDictionary *dict = [item.value copyWithZone:nil];
                        if ([dict objectForKey:@"data"]) {
                            artworkImage = [UIImage imageWithData:[item dataValue]];
                        }
                    }
                }
                else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                    // This doesn't appear to get called for images set (ironically) in iTunes
                    artworkImage = [UIImage imageWithData:[item dataValue]];
                }
            }
            
            if (artworkImage != nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.albumArtImage.image = artworkImage;
                    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:artworkImage]];
                });
            }
            
        }];
    }
    self.songPositionSlider.value = 0.0;
    self.songPositionSlider.maximumValue = [player duration];
    masterTime = 0;
    [[MacroAmpController sharedInstance] checkPaused:sessionID];
}
- (void)updateTime:(NSTimer *)timer //Handles all time and slider position changes. Also handles automatic track skipping when a track has finished playing.
{
    if ([player isPlaying])
    {
        masterTime++;
    }
    if (self.volumeSlider.value!=[[MPMusicPlayerController systemMusicPlayer] volume])
    {
        self.volumeSlider.value=[[MPMusicPlayerController systemMusicPlayer]volume];
    }
    self.songPositionSlider.value = player.currentTime;
    if (![player isPlaying]&&(int)[player currentTime]==0&&masterTime>[player duration]-5)
    {
        //[self nextTrack:self];
    }
    [self updateTimeLabels];
}
-(void)updateTimeLabels //Handles the time labels (time remaining and current time) shown on the Player View.
{
    NSString *secondsToPrint;
    NSString *minutesToPrint;
    NSString *secondsRemainingToPrint;
    NSString *minutesRemainingToPrint;
    
    int time = 0;
    int timeRemaining = 0;
    
    time=(int)[player currentTime];
    timeRemaining=(int)[player duration]-[player currentTime];
    if (time%60<10)
    {
        secondsToPrint=[@"0"stringByAppendingString:[NSString stringWithFormat:@"%d", time%60]];
    }
    else
    {
        secondsToPrint=[NSString stringWithFormat:@"%d", time%60];
    }
    if (time/60<10)
    {
        minutesToPrint=[@"0"stringByAppendingString:[NSString stringWithFormat:@"%d", time/60]];
    }
    else
    {
        minutesToPrint=[NSString stringWithFormat:@"%d", time/60];
    }
    if (timeRemaining%60<10)
    {
        secondsRemainingToPrint=[@"0"stringByAppendingString:[NSString stringWithFormat:@"%d", timeRemaining%60]];
    }
    else
    {
        secondsRemainingToPrint=[NSString stringWithFormat:@"%d", timeRemaining%60];
    }
    if(timeRemaining/60<10)
    {
        minutesRemainingToPrint=[@"0"stringByAppendingString:[NSString stringWithFormat:@"%d", timeRemaining/60]];
    }
    else
    {
        minutesRemainingToPrint=[NSString stringWithFormat:@"%d", timeRemaining/60];
    }
    [self.elapsedTimeLabel setText:[[minutesToPrint stringByAppendingString:@":"]stringByAppendingString:secondsToPrint]];
    [self.remainingTimeLabel setText:[[minutesRemainingToPrint stringByAppendingString:@":"]stringByAppendingString:secondsRemainingToPrint]];
}
-(void)returnToMainMenu
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Leave Session" message:@"Are you sure you want to leave the session?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             //Handle session end
                             [playTimer invalidate];
                             [player pause];
                             [[MacroAmpController sharedInstance] endCheckLoop];
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
