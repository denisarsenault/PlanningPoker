//
//  CardsViewController.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "CardsViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController

ErrorReason CardsErrorReason;
UIButton *selectedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Button

//- (IBAction)pressedSendValueButton:(id)sender {
//    
//    NSLog(@"send value %@", self.cardValue.text);
//    
//    [self.cards sendCardValueToServer:self.cardValue.text];
//    
//}

//- (IBAction)pressedExitButton:(id)sender {
//    
//    [self.cards leavePlanningWithReason:ErrorReasonUserQuits];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (IBAction)pressedButton0:(id)sender {
    [self sendValue:@"0" FromButton:sender];
}

- (IBAction)pressedButton05:(id)sender {
    [self sendValue:@"0.5" FromButton:sender];
}

- (IBAction)pressedButton1:(id)sender {
    [self sendValue:@"1" FromButton:sender];
}

- (IBAction)pressedButton2:(id)sender {
    [self sendValue:@"2" FromButton:sender];
}

- (IBAction)pressedButton3:(id)sender {
    [self sendValue:@"3" FromButton:sender];
}

- (IBAction)pressedButton5:(id)sender {
    [self sendValue:@"5" FromButton:sender];
}

- (IBAction)pressedButton8:(id)sender {
    [self sendValue:@"8" FromButton:sender];
}

- (IBAction)pressedButton13:(id)sender {
    [self sendValue:@"13" FromButton:sender];
}

- (IBAction)pressedButton20:(id)sender {
    [self sendValue:@"20" FromButton:sender];
}

- (IBAction)pressedButton40:(id)sender {
    [self sendValue:@"40" FromButton:sender];
}

- (IBAction)pressedButton100:(id)sender {
    [self sendValue:@"100" FromButton:sender];
}

- (IBAction)pressedButtonQuestion:(id)sender {
    [self sendValue:@"?" FromButton:sender];
}

- (IBAction)pressedButtonCoffee:(id)sender {
    [self sendValue:@"coffee" FromButton:sender];
}

- (void)sendValue:(NSString *)value FromButton:(UIButton *)button {
    
    //remove old selected status
    if(selectedButton) {
        [selectedButton setSelected:FALSE];
    }
    
    [button setSelected:YES];
    
    [self.cards sendCardValueToServer:value];
    
    selectedButton = button;
}

#pragma mark - View logic

-(void)showAlertView {
    
    NSAssert(CardsErrorReason != ErrorReasonNoError, @"Wrong state!");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if(CardsErrorReason == ErrorReasonServerQuits || CardsErrorReason == ErrorReasonConnectionDropped) {
        title = NSLocalizedString(@"clientView.disconnected", nil);
        message = NSLocalizedString(@"clientView.disconnectedText", nil);
    }
    
    if(title && message) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"buttons.ok", nil)
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return FALSE;
}

#pragma marks - PlanningPokerCards delegates

- (void)leavePlanning:(PlanningPokerCards *)cards withReason:(ErrorReason)errorReasonFromDelegate {
    CardsErrorReason = errorReasonFromDelegate;
    [self showAlertView];
}


- (void)disableUI {
    
    self.button0.enabled = FALSE;
    self.button05.enabled = FALSE;
    self.button1.enabled = FALSE;
    self.button2.enabled = FALSE;
    self.button3.enabled = FALSE;
    self.button5.enabled = FALSE;
    self.button8.enabled = FALSE;
    self.button13.enabled = FALSE;
    self.button20.enabled = FALSE;
    self.button40.enabled = FALSE;
    self.button100.enabled = FALSE;
    self.buttonQuestion.enabled = FALSE;
    self.buttonCoffee.enabled = FALSE;
}

- (void)enableUI {
    
    self.button0.enabled = TRUE;
    self.button05.enabled = TRUE;
    self.button1.enabled = TRUE;
    self.button2.enabled = TRUE;
    self.button3.enabled = TRUE;
    self.button5.enabled = TRUE;
    self.button8.enabled = TRUE;
    self.button13.enabled = TRUE;
    self.button20.enabled = TRUE;
    self.button40.enabled = TRUE;
    self.button100.enabled = TRUE;
    self.buttonQuestion.enabled = TRUE;
    self.buttonCoffee.enabled = TRUE;
    
    [selectedButton setSelected:FALSE];
    selectedButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
