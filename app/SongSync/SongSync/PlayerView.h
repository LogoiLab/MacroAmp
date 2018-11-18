//
//  PlayerView.h
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongSelectionView.h"
#include "AppNavigationController.h"

@interface PlayerView : UIViewController
{
    SongSelectionView *ssv;
    AppNavigationController *songSelectionNav;
}
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImage;
@property (strong, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *songPositionSlider;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

@end
