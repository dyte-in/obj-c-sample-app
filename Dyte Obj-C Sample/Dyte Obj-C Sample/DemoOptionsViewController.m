//
//  DemoOptionsViewController.m
//  DemoOptionsViewController
//
//  Created by Akshay Bhalotia on 17/11/21.
//

#import "DemoOptionsViewController.h"
#import "TabViewController.h"

@interface DemoOptionsViewController ()

@end

@implementation DemoOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)groupCallAction:(id)sender {
    //  pass the appropriate sender to the segue
    //  so that it is available to the next controller
    [self performSegueWithIdentifier:@"segueToJoinScreen" sender:@(GroupCall)];
}

- (IBAction)webinarAction:(id)sender {
    [self performSegueWithIdentifier:@"segueToJoinScreen" sender:@(Webinar)];
}

- (IBAction)customControlsAction:(id)sender {
    [self performSegueWithIdentifier:@"segueToJoinScreen" sender:@(CustomControls)];
}

- (IBAction)dynamicSwitchingAction:(id)sender {
    [self performSegueWithIdentifier:@"segueToJoinScreen" sender:@(DynamicSwitching)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //  set the demo type for the next controller
    if([[segue destinationViewController] isKindOfClass:[TabViewController class]]) {
        ((TabViewController *)[segue destinationViewController]).demoType = (DemoOptions)[(NSNumber *)sender intValue];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
