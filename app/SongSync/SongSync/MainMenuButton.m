//
//  MainMenuButton.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "MainMenuButton.h"

@implementation MainMenuButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor clearColor];
    
    [[self layer] setCornerRadius:4.0f];
    
    [[self layer] setMasksToBounds:YES];
    self.layer.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:186.0/255.0 blue:0/255.0 alpha:1.0f].CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:59.0/255.0 green:186.0/255.0 blue:0/255.0 alpha:1.0f] forState:UIControlStateSelected];
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:74.0/255.0 green:233.0/255.0 blue:0/255.0 alpha:1.0f];
    } else {
        self.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:201.0/255.0 blue:29.0/255.0 alpha:1.0f];
    }
}

@end
