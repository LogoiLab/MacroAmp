//
//  SongSelectionView.h
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SongSelectionDelegate <NSObject>
@optional

-(void)didSelectAudioFile:(NSString *)path;

@end

@interface SongSelectionView : UITableViewController
{
    NSString *audioFilesPath;
    NSArray *availableFiles;
}
@property (nonatomic, strong) id <SongSelectionDelegate> delegate;

@property (strong) UIBlurEffect *blur;
@property (strong) UIVisualEffectView *blurView;

@end
