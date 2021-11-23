//
//  JoinMeetingViewController.m
//  JoinMeetingViewController
//
//  Created by Akshay Bhalotia on 17/11/21.
//

#import "JoinMeetingViewController.h"
#import "TabViewController.h"

@import AFNetworking;
@import DyteSdk;

@interface JoinMeetingViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DyteMeetingViewDelegate>

//  Outlets for view components
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation JoinMeetingViewController

NSArray *meetings;
NSArray *searchedMeetings;
BOOL isSearching;

AFHTTPSessionManager *joinManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loadingView.hidden = YES;
    
    //  Add "pull to refresh" to the meeting list
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl.tintColor = [UIColor systemIndigoColor];
    [self.tableView.refreshControl addTarget:self action:@selector(getMeetingList) forControlEvents:UIControlEventValueChanged];
    
    joinManager = [AFHTTPSessionManager manager];
    [joinManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [joinManager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    meetings = @[];
    searchedMeetings = @[];
    isSearching = NO;
    
    //  Get list of all meetings
    [self getMeetingList];
}

//  Get the list of all meetings available to join under this organization.
//  Depending on your use case, this logic could also be built on the backend,
//  so feel free to ignore this part.
- (void)getMeetingList {
    [self.activityIndicator startAnimating];
    self.loadingView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    
    //  API calls to Dyte should NEVER be made from the frontend.
    //  API calls should be made from your own backend,
    //  and the app should connect to your backend to do operations like get all meetings.
    //  A sample implementation of the backend can be found at: https://github.com/dyte-in/backend-sample-app.
    //  The below request is being made to a hosted instance of the above sample backend,
    //  so treat it as if it were your own backend and not Dyte.
    [joinManager GET:@"https://dyte-sample.herokuapp.com/meetings" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        meetings = ((NSDictionary *)responseObject)[@"data"][@"meetings"];
        
        dispatch_async(dispatch_get_main_queue(), (^{
            [self.activityIndicator stopAnimating];
            self.loadingView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            //  Display meeting list in table view
            [self.tableView reloadData];
            [self.tableView.refreshControl endRefreshing];
        }));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"caught error");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.loadingView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Some error occurred, please try again later" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            alert.view.tintColor = [UIColor systemIndigoColor];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

//  Get participant's name as input.
//  Depending on your use case, this logic could also be built on the backend,
//  so feel free to ignore this part.
- (void)getParticipantInfoForMeeting:(NSDictionary *)meeting {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Name" message:@"Let us know your name to join the meeting" preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = [UIColor systemIndigoColor];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Steve Jobs";
        textField.tintColor = [UIColor systemIndigoColor];
    }];
    //  Option to join the meeting as a host
    [alert addAction:[UIAlertAction actionWithTitle:@"Join as Host" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nullable action) {
        info[@"name"] = alert.textFields.firstObject.text;
        info[@"preset"] = @(Host);
        
        //  Pass meeting details and participant details for adding the participant to the meeting
        [self addParticipant:info toMeetingWithID:meeting[@"id"] andRoomName:meeting[@"roomName"]];
    }]];
    //  Option to join the meeting as a participant
    [alert addAction:[UIAlertAction actionWithTitle:@"Join as Participant" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nullable action) {
        info[@"name"] = alert.textFields.firstObject.text;
        info[@"preset"] = @(Participant);
        
        //  Pass meeting details and participant details for adding the participant to the meeting
        [self addParticipant:info toMeetingWithID:meeting[@"id"] andRoomName:meeting[@"roomName"]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//  Add participant to the meeting.
//  Depending on your use case, this logic could also be built on the backend,
//  so feel free to ignore this part.
- (void)addParticipant:(NSDictionary *)participantData toMeetingWithID:(NSString *)meeting andRoomName:(NSString *)roomName {
    
    //  Parameters to add the participant to the meeting
    NSMutableDictionary *participantDetails = [NSMutableDictionary dictionaryWithDictionary:@{}];
    participantDetails[@"meetingId"] = meeting;
    participantDetails[@"clientSpecificId"] = [[NSUUID UUID] UUIDString];
    participantDetails[@"userDetails"] = @{@"name": participantData[@"name"]};
    
    DemoOptions demoType = ((TabViewController *)self.tabBarController).demoType;
    
    //  Select the appropriate role or preset based on the type of demo.
    //  You would have your own roles, and presets.
    //  You would also write your own logic based on use cases to select the relevant one.
    //  Depending on your use case, this logic could also be built on the backend,
    //  so feel free to ignore this part.
    switch (demoType) {
        case Webinar:
            switch ((PresetType)[participantData[@"preset"] intValue]) {
                case Host:
                    participantDetails[@"presetName"] = @"default_webinar_host_preset";
                    break;
                case Participant:
                    participantDetails[@"presetName"] = @"default_webinar_participant_preset";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case GroupCall:
        case CustomControls:
        case DynamicSwitching:
            switch ((PresetType)[participantData[@"preset"] intValue]) {
                case Host:
                    participantDetails[@"roleName"] = @"host";
                    break;
                case Participant:
                    participantDetails[@"roleName"] = @"participant";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    [self.activityIndicator startAnimating];
    self.loadingView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    
    //  API calls to Dyte should NEVER be made from the frontend.
    //  API calls should be made from your own backend,
    //  and the app should connect to your backend to do operations like add participant.
    //  A sample implementation of the backend can be found at: https://github.com/dyte-in/backend-sample-app.
    //  The below request is being made to a hosted instance of the above sample backend,
    //  so treat it as if it were your own backend and not Dyte.
    [joinManager POST:@"https://dyte-sample.herokuapp.com/participant/create" parameters:participantDetails headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //  Use the authToken and the roomName to join the meeting via Dyte SDK.
        //  This demo shows all of this info being generated via user actions,
        //  but if you have already obtained this info via backend you can skip to this part directly.
        dispatch_async(dispatch_get_main_queue(), (^{
            [self.activityIndicator stopAnimating];
            self.loadingView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            [self addDyteViewForRoomName:roomName withAuthToken:((NSDictionary *)responseObject)[@"data"][@"authResponse"][@"authToken"]];
        }));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"caught error");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.loadingView.hidden = YES;
            self.view.userInteractionEnabled = YES;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Some error occurred, please try again later" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            alert.view.tintColor = [UIColor systemIndigoColor];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

//  The juicy part. The real deal.
//  Join the meeting using Dyte SDK.
- (void)addDyteViewForRoomName:(NSString *)roomName withAuthToken:(NSString *)authToken {
    
    //  Create meeting configuration
    DyteMeetingConfig *config = [[DyteMeetingConfig alloc] init];
    config.roomName = roomName;
    config.authToken = authToken;
    
    DyteMeetingView *dyteView;
    
    //  Initialize meeting's view with an appropriate frame.
    //  The logic here is built to keep the different demos in mind,
    //  but you could assign whatever size to the meeting.
    if (((TabViewController *)self.tabBarController).demoType == CustomControls) {
        
        //  Offsetting the height a bit to account for the extra control bar that we will add
        dyteView = [[DyteMeetingView alloc] initWithFrame:CGRectMake(0, self.view.safeAreaInsets.top, self.view.safeAreaLayoutGuide.layoutFrame.size.width, self.view.safeAreaLayoutGuide.layoutFrame.size.height-40)];
    } else {
        
        //  Taking up the full safe view area
        dyteView = [[DyteMeetingView alloc] initWithFrame:CGRectMake(0, self.view.safeAreaInsets.top, self.view.safeAreaLayoutGuide.layoutFrame.size.width, self.view.safeAreaLayoutGuide.layoutFrame.size.height)];
    }
    dyteView.tag = 10;
    
    //  Setting delegate to self to listen for events
    dyteView.delegate = self;
    
    //  Add the meeting view to the view heirarchy
    [self.view addSubview:dyteView];
    
    //  Join the meeting using the config
    [dyteView join:config];
}

#pragma mark Custom control handlers

//  Handler for custom audio control
- (void)toggleAudio:(UIBarButtonItem *)sender {
    if ([DyteSelfParticipant sharedInstance].audioEnabled) {
        [[DyteSelfParticipant sharedInstance] disableAudio];
        sender.image = [UIImage systemImageNamed:@"mic.slash.fill"];
    } else {
        [[DyteSelfParticipant sharedInstance] enableAudio];
        sender.image = [UIImage systemImageNamed:@"mic.fill"];
    }
}

//  Handler for custom video control
- (void)toggleVideo:(UIBarButtonItem *)sender {
    if ([DyteSelfParticipant sharedInstance].videoEnabled) {
        [[DyteSelfParticipant sharedInstance] disableVideo];
        sender.image = [UIImage systemImageNamed:@"video.slash.fill"];
    } else {
        [[DyteSelfParticipant sharedInstance] enableAudio];
        sender.image = [UIImage systemImageNamed:@"video.fill"];
    }
}

//  Handler for custom control to end the meeting
- (void)quitMeeting {
    [[DyteSelfParticipant sharedInstance] leaveRoom];
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearching) {
        [self getParticipantInfoForMeeting:searchedMeetings[indexPath.row]];
    } else {
        [self getParticipantInfoForMeeting:meetings[indexPath.row]];
    }
}

#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return [searchedMeetings count];
    } else {
        return [meetings count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"meetingCell" forIndexPath:indexPath];
    if (isSearching) {
        cell.textLabel.text = ((NSDictionary *)searchedMeetings[indexPath.row])[@"title"];
    } else {
        cell.textLabel.text = ((NSDictionary *)meetings[indexPath.row])[@"title"];
    }
    return cell;
}

#pragma mark Search bar delegate

//  Manage search in the table
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchedMeetings = [meetings filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL result = NO;
        NSString *compareString = (NSString *)((NSDictionary *)evaluatedObject)[@"title"];
        if (compareString.length < searchText.length) {
            result = [[compareString lowercaseString] isEqualToString:[searchText lowercaseString]];
        } else {
            result = [[[compareString lowercaseString] substringToIndex:searchText.length] isEqualToString:[searchText lowercaseString]];
        }
        return result;
    }]];
    isSearching = YES;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = NO;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark Meeting event listener delegate

- (void)meetingConnected {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  Add custom controls to the view, based on the demo type
        if (((TabViewController *)self.tabBarController).demoType == CustomControls) {
            [((DyteMeetingView *)[self.view viewWithTag:10]) updateUiConfig:@{@"controlBar": @NO}];
//            [((DyteMeetingView *)[self.view viewWithTag:10]) updateUiConfig:@{
//                            @"header": @(YES),
//                            @"controlBarElements": @{
//                                @"polls":  @(NO),
//                                @"chat":  @(NO),
//                                @"plugins": @(NO),
//                                @"participants": @(NO),
//                            }
//            }];
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.safeAreaLayoutGuide.layoutFrame.size.height+self.view.safeAreaLayoutGuide.layoutFrame.origin.y-40, self.view.safeAreaLayoutGuide.layoutFrame.size.width, 40)];
            toolbar.tag = 20;
            toolbar.tintColor = [UIColor systemIndigoColor];
            UIBarButtonItem *micButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"mic.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAudio:)];
            UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"video.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleVideo:)];
            UIBarButtonItem *endButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"phone.down.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(quitMeeting)];
            endButton.tintColor = [UIColor systemRedColor];
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            toolbar.items = @[micButton, spacer, cameraButton, spacer, endButton];
            [self.view addSubview:toolbar];
        }
    });
}

- (void)meetingJoined {
}

- (void)meetingEnded {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  Remove custom controls from the view, based on the demo type
        if (((TabViewController *)self.tabBarController).demoType == CustomControls) {
            [[self.view viewWithTag:20] removeFromSuperview];
        }
    });
}

- (void)meetingDisconnect {
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
