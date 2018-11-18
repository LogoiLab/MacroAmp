//
//  InitialViewController.h
//  SongSync
//
//  Created by Collin Mistr on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuButton.h"
#import "AppNavigationController.h"
#import "JoinSessionView.h"
#import "SongSelectionView.h"
#import "PlayerView.h"
#import "MacroAmpController.h"

@interface InitialViewController : UIViewController <SongSelectionDelegate>
{
    AppNavigationController *createSessionNav;
    AppNavigationController *joinSessionNav;
    PlayerView *pv;
    SongSelectionView *ssv;
}


@property (strong, nonatomic) IBOutlet UIButton *createSessionButton;
@property (strong, nonatomic) IBOutlet UIButton *joinSessionButton;
- (IBAction)startNewSession:(id)sender;
- (IBAction)joinExistingSession:(id)sender;



@end
