//
//  HostViewController.m
//  iPlanningPoker
//
//  Created by Denis Arsenault on 03/11/14
//  Copyright (c) mybrightzone All rights reserved.
//

#import "HostViewController.h"

@interface HostViewController ()

@end

@implementation HostViewController

ErrorReason errorReason;

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
    
    if (self.server == nil)
	{
		self.server = [[PlanningPokerServer alloc] init];
        self.server.delegate = self;
        self.server.maxClients = kMaxClients;
        [self.server startBroadcastingForSessionId:kSessionId];
        
        //Disable start button as no client is connected
        self.startPlanningButton.enabled = FALSE;
	}
    
    //add observer to check when the app comes back from the background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cameBackFromBackground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)cameBackFromBackground:(NSNotification *)notification {
    [self.server endBroadcasting];
    
    self.server = [[PlanningPokerServer alloc] init];
    self.server.delegate = self;
    self.server.maxClients = kMaxClients;
    [self.server startBroadcastingForSessionId:kSessionId];
}

-(void)showAlertView {
    
    NSAssert(errorReason != ErrorReasonNoError, @"Wrong state!");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if(errorReason == ErrorReasonNoNetworkCapabilities) {
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

#pragma mark - Buttons

- (IBAction)pressedCancelButton:(id)sender {
    NSLog(@"pressedCancelButton");
    
    errorReason = ErrorReasonUserQuits;
    
    [self.server endBroadcasting];
    
    //remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedStartPlanningButton:(id)sender {
    NSLog(@"pressedStartPlanningButton");
    
    [self.startPlanningButton setTitle:NSLocalizedString(@"buttons.connectingClients", nil) forState:UIControlStateNormal];
    
    [self.server stopAcceptingNewConnections];
    
    self.startPlanningButton.enabled = FALSE;
    
    self.deck = [[PlanningPokerDeck alloc] init];
    self.deck.delegate = self;

    [self.deck startPlanningWithSession:self.server.session clients:self.server.connectedClients];
}

#pragma mark - PlanningPokerServer delegates

- (void)planningPokerServer:(PlanningPokerServer *)server connectedToClient:(NSString *)peerId {
    [self.clientsTableView reloadData];
    
    //enable button if at least one client is connected
    if([server.connectedClients count] > 0) {
        self.startPlanningButton.enabled = TRUE;
    }
}

- (void)planningPokerServer:(PlanningPokerServer *)server disconnetedFromClient:(NSString *)peerId {
    [self.clientsTableView reloadData];
    
    //disable button if no more clients are connected
    if([server.connectedClients count] == 0) {
        self.startPlanningButton.enabled = FALSE;
        [self.startPlanningButton setTitle:NSLocalizedString(@"buttons.startPlanning", nil) forState:UIControlStateNormal];
    }
}

- (void)planningPokerServerEndedBroadcasting:(PlanningPokerServer *)server {
    
    self.server.delegate = nil;
    self.server = nil;
    
    [self.clientsTableView reloadData];
    
    [self showAlertView];
}

- (void)planningPokerServer:(PlanningPokerServer *)server withErrorReason:(ErrorReason)errorReasonFromDelegate {
    errorReason = errorReasonFromDelegate;
}

#pragma mark - PlanningPokerCardsDelegate methods

- (void)connectionEstablished {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.delegate showDeckViewWithDeck:self.deck];

    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.server) {
        return [self.server.connectedClients count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *peerId = [self.server.connectedClients objectAtIndex:indexPath.row];
    NSString *serverName = [self.server.session displayNameForPeer:peerId];
    
    cell.textLabel.text = serverName;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
