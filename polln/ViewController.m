//
//  ViewController.m
//  polln
//
//  Created by Giv Parvaneh on 6/25/15.
//  Copyright (c) 2015 Giv Parvaneh. All rights reserved.
//

#import "ViewController.h"
#import "ParticleScene.h"
#import "PollenCount.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SKView *particleScene;
@property (strong, nonatomic) IBOutlet UILabel *pollenLocation;
@property (strong, nonatomic) IBOutlet UILabel *pollenStrength;
@property (strong, nonatomic) IBOutlet UILabel *pollenValue;
@property (strong, nonatomic) IBOutlet UILabel *pollenZip;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // get location
    // Create a location manager
    locationManager = [[CLLocationManager alloc] init];
    // Set a delegate to receive location callbacks
    locationManager.delegate = self;
    // Start the location manager
    [locationManager startUpdatingLocation];

    // add particles
    ParticleScene * scene = [ParticleScene sceneWithSize:_particleScene.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    _particleScene.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [_particleScene presentScene:scene];
    
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Zip = [[NSString alloc]initWithString:placemark.postalCode];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSLog(@"%@ - %@", Area, Zip);
             
             // populate data
             PollenCount *pc = [[[PollenCount alloc] init] getPollenData:Area :Zip];
             
             _pollenLocation.text = pc.locationName;
             _pollenStrength.text = pc.pollenStrength;
             _pollenValue.text = pc.pollenValue;
             _pollenZip.text = pc.zip;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }

     }];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
