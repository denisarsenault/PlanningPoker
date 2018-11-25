//
//  ViewController.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Buttons

- (IBAction)pressedSetupNewRoundButtonPhone:(id)sender {
    NSLog(@"pressedSetupNewRoundButton iPhone");
    
    ClientViewController *clientViewController = [[ClientViewController alloc] initWithNibName:@"ClientViewController_iPhone" bundle:nil];
    clientViewController.delegate = self;
    
    [self presentViewController:clientViewController animated:YES completion:nil];
}

- (IBAction)pressedSetupNewRoundButtonPad:(id)sender {
    NSLog(@"pressedSetupNewRoundButton iPad");
    
    HostViewController *hostViewController = [[HostViewController alloc] initWithNibName:@"HostViewController_iPad" bundle:nil];
    hostViewController.delegate = self;
    
    [self presentViewController:hostViewController animated:YES completion:nil];
}

#pragma mark - ClientViewControllerDelegate methods

- (void)showCardsViewWithCards:(PlanningPokerCards *)cards {
    
    CardsViewController *cardsViewController = [[CardsViewController alloc] init];
    cardsViewController.cards = cards;
    cardsViewController.cards.delegate = cardsViewController;
    
    [self presentViewController:cardsViewController animated:YES completion:nil];
}

#pragma mark - HostViewControllerDelegate method

- (void)showDeckViewWithDeck:(PlanningPokerDeck *)deck {
    DeckViewController *deckViewController = [[DeckViewController alloc] init];
    deckViewController.deck = deck;
    deckViewController.deck.delegate = deckViewController;
    
    [self presentViewController:deckViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
