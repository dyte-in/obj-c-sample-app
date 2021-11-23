//
//  TabViewController.h
//  TabViewController
//
//  Created by Akshay Bhalotia on 17/11/21.
//

#import <UIKit/UIKit.h>
#import "DemoOptionsViewController.h"

NS_ASSUME_NONNULL_BEGIN

// the two basic roles types we will be working with
typedef NS_ENUM(NSInteger, PresetType) {
    Host = 0,
    Participant
};

@interface TabViewController : UITabBarController

//  custom property to hold the demo type
//  makes it easier for all child controllers to access
@property (nonatomic) DemoOptions demoType;

@end

NS_ASSUME_NONNULL_END
