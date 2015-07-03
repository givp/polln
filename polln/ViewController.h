//
//  ViewController.h
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import CoreMotion;
#import <MobileCoreServices/MobileCoreServices.h>
@import SpriteKit;

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (weak, nonatomic) IBOutlet SKView *particleScene;
@property (strong, nonatomic) IBOutlet UILabel *pollenLocation;
@property (strong, nonatomic) IBOutlet UILabel *pollenStrength;
@property (strong, nonatomic) IBOutlet UILabel *pollenValue;
@property (strong, nonatomic) IBOutlet UILabel *pollenZip;
@property (nonatomic, strong) CMAltimeter *altimeterManager;
@property (strong, nonatomic) IBOutlet UIView *pressureView;
- (IBAction)debugAnim:(id)sender;

@end

