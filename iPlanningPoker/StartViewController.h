//
//  ViewController.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "HostViewController.h"
#import "ClientViewController.h"
#import "CardsViewController.h"
#import "PlanningPokerCards.h"
#import "DeckViewController.h"

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController<ClientViewControllerDelegate, CardsViewControllerDelegate, HostViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *setupNewRoundButton;

@end
