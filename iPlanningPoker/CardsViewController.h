//
//  CardsViewController.h
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "PlanningPokerCards.h"

#import <UIKit/UIKit.h>

@protocol CardsViewControllerDelegate;

@interface CardsViewController : UIViewController<UITextFieldDelegate, PlanningPokerCardsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button05;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button13;
@property (weak, nonatomic) IBOutlet UIButton *button20;
@property (weak, nonatomic) IBOutlet UIButton *button40;
@property (weak, nonatomic) IBOutlet UIButton *button100;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuestion;
@property (weak, nonatomic) IBOutlet UIButton *buttonCoffee;

@property (strong, nonatomic) PlanningPokerCards *cards;

@end

@protocol CardsViewControllerDelegate <NSObject>


@end
