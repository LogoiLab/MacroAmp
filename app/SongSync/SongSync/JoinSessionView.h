//
//  JoinSessionView.h
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitEntryField.h"
#include "PlayerView.h"
#include "LoadingView.h"

@interface JoinSessionView : UIViewController <UITextFieldDelegate>
{
    NSString *sessionCode;
    PlayerView *pv;
    LoadingView *lv;
}
@property (strong, nonatomic) IBOutlet DigitEntryField *digit1;
@property (strong, nonatomic) IBOutlet DigitEntryField *digit2;
@property (strong, nonatomic) IBOutlet DigitEntryField *digit3;
@property (strong, nonatomic) IBOutlet DigitEntryField *digit4;
@property (strong, nonatomic) IBOutlet DigitEntryField *digit5;
@property (strong, nonatomic) IBOutlet DigitEntryField *digit6;

@end
