//
//  ClientViewController.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14 on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "ClientViewController.h"

@interface ClientViewController ()

@end

@implementation ClientViewController

ErrorReason clientErrorReason;

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
    
    if (self.client == nil)
	{
        self.client = [[PlanningPokerClient alloc] init];
        self.client.delegate = self;
        
		self.clientNameTextField.placeholder = [[UIDevice currentDevice] name];
        
        clientErrorReason = ErrorReasonNoError;
	}
}

-(void)showAlertView {
    
    NSAssert(clientErrorReason != ErrorReasonNoError, @"Wrong state!");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if(clientErrorReason == ErrorReasonServerQuits || clientErrorReason == ErrorReasonConnectionDropped) {
        title = NSLocalizedString(@"clientView.disconnected", nil);
        message = NSLocalizedString(@"clientView.disconnectedText", nil);
    } else if(clientErrorReason == ErrorReasonNoNetworkCapabilities) {
        title = NSLocalizedString(@"clientView.noNetwork", nil);
        message = NSLocalizedString(@"clientView.dnoNetworkText", nil);
    }
    
    if(title && message) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"buttons.ok", nil)
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return FALSE;
}

#pragma mark - Buttons
- (IBAction)pressedCancelButton:(id)sender {
    NSLog(@"Cancel button pressed");
    
    clientErrorReason = ErrorReasonUserQuits;
    
	[self.client disconnectFromServer];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedStartConnectingButton:(id)sender {
    NSLog(@"Connecting button pressed");
    
    if (self.client == nil)
	{
        self.client = [[PlanningPokerClient alloc] init];
        self.client.delegate = self;
        
        clientErrorReason = ErrorReasonNoError;
	}
    
    [self.client startLookingForServersWithSessionId:kSessionId andName:self.clientNameTextField.text];
    
    self.clientNameTextField.enabled = FALSE;
    self.startConnectingButton.enabled = FALSE;
    self.searchingServerLabel.text = NSLocalizedString(@"clientView.searchingServer", nil);
    self.searchingServerLabel.hidden = FALSE;
    self.searchingServerActivityIndicatorView.hidden = FALSE;
}

#pragma mark - PlanningPokerClient delegate

- (void)planningPokerClient:(PlanningPokerClient *)client serverBecameAvailable:(NSString *)peerId {
    
    NSString *serverName = [self.client.session displayNameForPeer:peerId];
    
    self.searchingServerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"clientView.serverFound", nil), serverName];
    
    //Connect to server
    [self.client connectToServerWithPeerId:peerId];
}

- (void)planningPokerClient:(PlanningPokerClient *)client serverBecameUnavailable:(NSString *)peerId {
    self.searchingServerLabel.text = NSLocalizedString(@"clientView.searchingServer", nil);
}

- (void)planningPokerClient:(PlanningPokerClient *)client disconnectedFromServer:(NSString *)peerdId {
    self.client.delegate = nil;
    self.client = nil;
    
    [self showAlertView];

    self.clientNameTextField.enabled = TRUE;
    self.searchingServerLabel.text = nil;
    self.startConnectingButton.enabled = TRUE;
    self.searchingServerActivityIndicatorView.hidden = TRUE;
}

- (void)planningPokerClient:(PlanningPokerClient *)client withErrorReason:(ErrorReason)errorReasonFromDelegate {
    clientErrorReason = errorReasonFromDelegate;
}

- (void)didConnectToServer {
    
    self.cards = [[PlanningPokerCards alloc] init];
    self.cards.delegate = self;
    self.cards.serverPeerId = self.client.serverPeerId;
    
    [self.cards joinPlanningWithSession:self.client.session];
}

#pragma mark - PlanningPokerCardsDelegate methods

- (void)leavePlanning:(PlanningPokerCards *)cards withReason:(ErrorReason)errorReasonDelegate {
    clientErrorReason = errorReasonDelegate;
    
    [self showAlertView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)connectionEstablished {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.delegate showCardsViewWithCards:self.cards];
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
