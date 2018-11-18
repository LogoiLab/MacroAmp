//
//  JoinSessionView.m
//  SongSync
//
//  Created by User on 11/17/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "JoinSessionView.h"

@interface JoinSessionView ()

@end

@implementation JoinSessionView

- (void)viewDidLoad {
    [super viewDidLoad];
    sessionCode = @"";
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"green-pattern.jpg"]]];
    [self.navigationItem setTitle:@"Join Session"];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModal)]];
    [_digit1 setBackgroundColor:[UIColor whiteColor]];
    [_digit2 setBackgroundColor:[UIColor whiteColor]];
    [_digit3 setBackgroundColor:[UIColor whiteColor]];
    [_digit4 setBackgroundColor:[UIColor whiteColor]];
    [_digit5 setBackgroundColor:[UIColor whiteColor]];
    [_digit6 setBackgroundColor:[UIColor whiteColor]];
    [_digit1 setDelegate:self];
    [_digit2 setDelegate:self];
    [_digit3 setDelegate:self];
    [_digit4 setDelegate:self];
    [_digit5 setDelegate:self];
    [_digit6 setDelegate:self];
    [_digit1 becomeFirstResponder];
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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int currentTag = (int)textField.tag;
    
    if(string.length==0 && range.length==1)
    {
        textField.text = @"";
        UITextField *newTextField = (UITextField *) [textField.superview viewWithTag:(currentTag-1)];
        [newTextField becomeFirstResponder];
        sessionCode = [sessionCode substringToIndex:currentTag-1];
        return NO;
    }
    else{
        sessionCode = [sessionCode stringByAppendingString:string];
    }
    
    if((textField.text.length + string.length) >= 1)
    {
        if(currentTag == 6)
        {
            [self connectToSession];
            if(textField.text.length<1)
                return YES;
            else
                return NO;
        }
        
        
        UITextField *newTextField = (UITextField *) [textField.superview viewWithTag:(currentTag+1)];
        if(newTextField.text.length==0)
            [newTextField becomeFirstResponder];
        if(textField.text.length==0)
        {
            textField.text = [textField.text stringByAppendingString:string];
            return NO;
        }
        else
        {
            if(currentTag+1 == 6)
            {
                if(newTextField.text.length>=1)
                    return NO;
            }
            else
                if(newTextField.text.length>=1)
                    return NO;
            return YES;
        }
        
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_digit1 setText:@""];
    [_digit2 setText:@""];
    [_digit3 setText:@""];
    [_digit4 setText:@""];
    [_digit5 setText:@""];
    [_digit6 setText:@""];
    [_digit1 becomeFirstResponder];
}
-(void)connectToSession
{
    [self performSelector:@selector(showLoadingView) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(dismissLoadingView) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(pushListeningView) withObject:nil afterDelay:2.1];
}
-(void)pushListeningView
{
    if (!listeningView)
    {
        listeningView = [[ListeningView alloc] init];
    }
    [[self navigationController] pushViewController:listeningView animated:YES];
    
}
-(void)showLoadingView
{
    if (!lv)
    {
        lv = [[LoadingView alloc] init];
    }
    [self presentViewController:lv animated:YES completion:nil];
}
-(void)dismissLoadingView
{
    [lv dismissViewControllerAnimated:YES completion:nil];
}
@end
