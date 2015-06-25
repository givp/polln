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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    // add particles
    ParticleScene * scene = [ParticleScene sceneWithSize:_particleScene.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    _particleScene.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [_particleScene presentScene:scene];
    
    // populate data
    PollenCount *pc = [[[PollenCount alloc] init] getPollenData];
    
    _pollenLocation.text = pc.locationName;
    _pollenStrength.text = pc.pollenStrength;
    _pollenValue.text = pc.pollenValue;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
