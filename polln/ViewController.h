//
//  ViewController.h
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import <MobileCoreServices/MobileCoreServices.h>
@import SpriteKit;

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@end

