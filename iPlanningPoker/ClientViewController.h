//
//  ClientViewController.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerClient.h"
#import "CardsViewController.h"
#import "PlanningPokerCards.h"

#import <UIKit/UIKit.h>

#define kSessionId @"iPlanningPoker"

@protocol ClientViewControllerDelegate;

@interface ClientViewController : UIViewController<UITextFieldDelegate, PlanningPokerClientDelegate, PlanningPokerCardsDelegate>

@property (strong, nonatomic) IBOutlet UITextField *clientNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *startConnectingButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *searchingServerActivityIndicatorView;
@property (strong, nonatomic) IBOutlet UILabel *searchingServerLabel;

@property (strong, nonatomic) PlanningPokerClient *client;
@property (weak, nonatomic) id <ClientViewControllerDelegate> delegate;
@property (strong, nonatomic) PlanningPokerCards *cards;

@end

@protocol ClientViewControllerDelegate <NSObject>

- (void)showCardsViewWithCards:(PlanningPokerCards *)cards;

@end
