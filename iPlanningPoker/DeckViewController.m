//
//  DeckViewController.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "DeckViewController.h"

@interface DeckViewController ()

@end

@implementation DeckViewController

NSArray *choosingCards;
NSArray *choosenCards;
NSArray *coffees;
NSArray *teamMemberNames;
NSArray *teamMemberValues;
NSMutableArray *membersPositions;
NSInteger sizeOfTeam;

ErrorReason DeckErrorReason;

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
    
    choosingCards = [NSArray arrayWithObjects:self.choosingCard1, self.choosingCard2, self.choosingCard3, self.choosingCard4, self.choosingCard5, self.choosingCard6, self.choosingCard7, self.choosingCard8, nil];
    
    choosenCards = [NSArray arrayWithObjects:self.choosenCard1, self.choosenCard2, self.choosenCard3, self.choosenCard4, self.choosenCard5, self.choosenCard6, self.choosenCard7, self.choosenCard8,nil];
    
    teamMemberNames = [NSArray arrayWithObjects:self.teamMemberLabel1, self.teamMemberLabel2, self.teamMemberLabel3, self.teamMemberLabel4, self.teamMemberLabel5, self.teamMemberLabel6, self.teamMemberLabel7, self.teamMemberLabel8, nil];
    
    teamMemberValues = [NSArray arrayWithObjects:self.teamMemberValue1, self.teamMemberValue2, self.teamMemberValue3, self.teamMemberValue4, self.teamMemberValue5, self.teamMemberValue6, self.teamMemberValue7, self.teamMemberValue8,nil];
    
    coffees = [NSArray arrayWithObjects:self.coffee1, self.coffee2, self.coffee3, self.coffee4, self.coffee5, self.coffee6, self.coffee7, self.coffee8, nil];
    
    sizeOfTeam = [self.deck.teamMembers count];
    
    membersPositions = [NSMutableArray array];
    
    [self.deck.teamMembers enumerateKeysAndObjectsUsingBlock:^(id key, TeamMember *obj, BOOL *stop) {
        [membersPositions addObject:obj];
    }];
    
    
    for(int i = 0; i < sizeOfTeam; i++) {
        UIImageView *choosingCard = [choosingCards objectAtIndex:i];
        UILabel *label = [teamMemberNames objectAtIndex:i];
        
        choosingCard.hidden = FALSE;
        label.hidden = FALSE;
        label.text = ((TeamMember *)[membersPositions objectAtIndex:i]).name;
    }
}

-(void)showAlertView {
    
    NSAssert(DeckErrorReason != ErrorReasonNoError, @"Wrong state!");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if(DeckErrorReason == ErrorReasonUserQuits) {
        title = NSLocalizedString(@"serverView.userQuit", nil);
        message = NSLocalizedString(@"serverView.userQuitText", nil);
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


- (void)showChoosableCards {
    for(int i = 0; i < sizeOfTeam; i++) {
        UIImageView *choosingCard = [choosingCards objectAtIndex:i];
        UIImageView *choosenCard = [choosenCards objectAtIndex:i];
        UIImageView *coffee = [coffees objectAtIndex:i];
        UILabel *value = [teamMemberValues objectAtIndex:i];
        
        choosingCard.hidden = FALSE;
        
        choosenCard.hidden = TRUE;
        coffee.hidden = TRUE;
        value.hidden = TRUE;
    }
}

- (void)showChoosenCards {
    for(int i = 0; i < sizeOfTeam; i++) {
        UIImageView *choosingCard = [choosingCards objectAtIndex:i];
        UIImageView *choosenCard = [choosenCards objectAtIndex:i];
        UIImageView *coffee = [coffees objectAtIndex:i];
        UILabel *value = [teamMemberValues objectAtIndex:i];
        
        choosingCard.hidden = TRUE;
        
        choosenCard.hidden = FALSE;
        
        NSString *cardValue =((TeamMember *)[membersPositions objectAtIndex:i]).cardValue;
        
        if ([cardValue  isEqual: @"coffee"]) {
            coffee.hidden = FALSE;
        } else {
            value.text = ((TeamMember *)[membersPositions objectAtIndex:i]).cardValue;
            value.hidden = FALSE;
        }
    }
}

#pragma mark - Buttons

- (IBAction)pressedExitButton:(id)sender {
    
    [self.deck stopPlanningWithReason:ErrorReasonUserQuits];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedNextRoundButton:(id)sender {
    NSLog(@"play new round");
    
    [self showChoosableCards];
    [self.deck playNewRound];
    
}

#pragma mark - PlanningPokerDeckDelegate methods

- (void)disconnectedTeamMember:(TeamMember *)teamMeamber {
    NSLog(@"disconnected team member with peerid %@", teamMeamber.peerID);
}

- (void)displayChoosenCards {
    
    [self showChoosenCards];
}

- (void)stopPlanning:(PlanningPokerDeck *)cards withReason:(ErrorReason)errorReasonDelegate; {
 
    DeckErrorReason = errorReasonDelegate;
    
    [self showAlertView];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
