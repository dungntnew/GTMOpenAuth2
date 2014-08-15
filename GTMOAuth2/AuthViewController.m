//
//  AuthViewController.m
//  GTMOAuth2
//
//  Created by dung-nguyen on 2014/08/15.
//  Copyright (c) 2014年 Kayac. All rights reserved.
//

#import "AuthViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

// Constants used for OAuth 2.0 authorization.
static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";
static NSString *const kPlusScope = @"https://www.googleapis.com/auth/plus.me"; // scope for Google+ API
static NSString *const kClientId = @"824631462109-afedlkiu4fgdq7grvtb4nq0a3e1idb1v.apps.googleusercontent.com";
static NSString *const kClientSecret = @"EWmeKQvuOirAlTSlYQdQBJoI";

@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UIButton *signOut;
@property (weak, nonatomic) IBOutlet UILabel *authStatus;
@property BOOL isAuthorized;

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth;

- (void)doAuth;

- (void)doSignOut;
@end

@implementation AuthViewController

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
   
    // Check for authorization
    GTMOAuth2Authentication * auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName clientID:kClientId clientSecret:kClientSecret];
    
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];
    }
    else {
        [self.authStatus setText:@"Not Authorized"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)authButtonClicked:(id)sender {
    [self doAuth];
}
- (IBAction)singOutButtonClicked:(id)sender {
    [self doSignOut];
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    // Set Auth for other service here
    [self.authStatus setText:@"Has Authorized"];
    self.isAuthorized = YES;
}

- (void)doAuth {
    if (!self.isAuthorized) {
        
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController = [[GTMOAuth2ViewControllerTouch alloc]
                                                            initWithScope:kPlusScope
                                                            clientID:kClientId
                                                            clientSecret:kClientSecret
                                                            keychainItemName:kKeychainItemName
                                                            delegate:self
                                                            finishedSelector:finishedSelector];
        [self presentViewController:authViewController animated:YES completion:nil];
    }
}

- (void)doSignOut {
    if (self.isAuthorized) {
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        
        // Set Auth for other service to nil
        [self.authStatus setText:@"Not Authorized"];
        self.isAuthorized = NO;
    }
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil){
        [self isAuthorizedWithAuthentication:auth];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
