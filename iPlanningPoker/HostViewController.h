//
//  HostViewController.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerServer.h"
#import "PlanningPokerDeck.h"

#import <UIKit/UIKit.h>

#define kSessionId @"iPlanningPoker"
#define kMaxClients 8

@protocol HostViewControllerDelegate;

@interface HostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PlanningPokerServerDelegate, PlanningPokerDeckDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *clientsTableView;
@property (strong, nonatomic) IBOutlet UIButton *startPlanningButton;

@property (strong, nonatomic) PlanningPokerServer *server;
@property (strong, nonatomic) PlanningPokerDeck *deck;
@property (weak, nonatomic) id<HostViewControllerDelegate> delegate;

@end

@protocol HostViewControllerDelegate <NSObject>

- (void)showDeckViewWithDeck:(PlanningPokerDeck *)deck;

@end
