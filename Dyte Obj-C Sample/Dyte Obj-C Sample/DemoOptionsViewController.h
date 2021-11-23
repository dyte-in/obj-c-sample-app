//
//  DemoOptionsViewController.h
//  DemoOptionsViewController
//
//  Created by Akshay Bhalotia on 17/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//  the four features that we are going to demo
//  saved as enums to make passing data around safer
typedef NS_ENUM(NSInteger, DemoOptions) {
    GroupCall = 0,
    Webinar,
    CustomControls,
    DynamicSwitching
};

@interface DemoOptionsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
