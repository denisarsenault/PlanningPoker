//
//  DeckViewController.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerDeck.h"
#import "TeamMember.h"

#import <UIKit/UIKit.h>

@interface DeckViewController : UIViewController<PlanningPokerDeckDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard1;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard2;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard3;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard4;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard5;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard6;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard7;
@property (weak, nonatomic) IBOutlet UIImageView *choosingCard8;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel1;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel2;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel3;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel4;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel5;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel6;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel7;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberLabel8;

@property (weak, nonatomic) IBOutlet UIImageView *choosenCard1;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard2;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard3;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard4;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard5;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard6;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard7;
@property (weak, nonatomic) IBOutlet UIImageView *choosenCard8;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue1;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue2;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue3;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue4;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue5;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue6;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue7;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberValue8;

@property (weak, nonatomic) IBOutlet UIButton *nextRoundButton;

@property (weak, nonatomic) IBOutlet UIImageView *coffee1;
@property (weak, nonatomic) IBOutlet UIImageView *coffee2;
@property (weak, nonatomic) IBOutlet UIImageView *coffee3;
@property (weak, nonatomic) IBOutlet UIImageView *coffee4;
@property (weak, nonatomic) IBOutlet UIImageView *coffee5;
@property (weak, nonatomic) IBOutlet UIImageView *coffee6;
@property (weak, nonatomic) IBOutlet UIImageView *coffee7;
@property (weak, nonatomic) IBOutlet UIImageView *coffee8;

@property (strong,nonatomic) PlanningPokerDeck *deck;

@end
