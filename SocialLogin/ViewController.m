//
//  ViewController.m
//  SocialLogin
//
//  Created by Evgeny Aleksandrov on 22.06.13.
//  Copyright (c) 2013 SomeCompany. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginTouch:(id)sender {
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      if (session.isOpen) {
                                          [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                              if (!error) {
                                                  self.nameLabel.text = user.name;
                                                  self.emailLabel.text = [user objectForKey:@"email"];
                                              }
                                          }];
                                      }
                                  }];
}

- (IBAction)loginTwiTouch:(id)sender {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountTypeTwitter
                            withCompletionHandler:^(BOOL granted, NSError *error) {
                                if(granted) {
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        ACAccount *twitterAccount = [[accountStore accountsWithAccountType:accountTypeTwitter] objectAtIndex:0];
                                        
                                        self.twiNameLabel.text = [twitterAccount valueForKey:@"username"];
                                        self.twiIdLabel.text = [twitterAccount valueForKeyPath:@"properties.user_id"];
                                    });
                                } else {
                                    NSLog(@"Access denied");
                                }
                            }];
}

@end
