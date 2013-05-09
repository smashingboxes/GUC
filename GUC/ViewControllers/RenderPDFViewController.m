//
//  RenderPDFViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/23/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "RenderPDFViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuButtonHelper.h"
#import "Station.h"
#import "NetworkConnectionManager.h"

@interface RenderPDFViewController ()

@property(nonatomic)Inspection *currentInspection;
@property(nonatomic)MFMailComposeViewController *mailComposer;
@property(nonatomic)NSMutableArray *imageArray;
@property(nonatomic)NSInteger pdfPage;
@property(nonatomic)LocationHelper *locationHelper;

// Header Labels
@property(nonatomic)IBOutlet UILabel *stationNameLabel;
@property(nonatomic)IBOutlet UILabel *dateTimeLabel;
@property(nonatomic)IBOutlet UILabel *technicianLabel;
@property(nonatomic)IBOutlet UIImageView *locationImageView;

// General Labels
@property(nonatomic)IBOutlet UILabel *kwhLabel;
@property(nonatomic)IBOutlet UILabel *mwdLabel;
@property(nonatomic)IBOutlet UILabel *plusKVARHLabel;
@property(nonatomic)IBOutlet UILabel *minusKVARHLabel;
@property(nonatomic)IBOutlet UILabel *maxVARDLabel;
@property(nonatomic)IBOutlet UILabel *minVARDLabel;
@property(nonatomic)IBOutlet UITextView *rainGaugeView;
@property(nonatomic)IBOutlet UITextView *detentionBasinCommentsView;

// SwitchBoard Labels
@property(nonatomic)IBOutlet UILabel *maxAmpALabel;
@property(nonatomic)IBOutlet UILabel *maxAmpBLabel;
@property(nonatomic)IBOutlet UILabel *maxAmpCLabel;
@property(nonatomic)IBOutlet UILabel *presentAmpALabel;
@property(nonatomic)IBOutlet UILabel *presentAmpBLabel;
@property(nonatomic)IBOutlet UILabel *presentAmpCLabel;
@property(nonatomic)IBOutlet UILabel *minVoltsALabel;
@property(nonatomic)IBOutlet UILabel *minVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *minVoltsCLabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsALabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsCLabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsALabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsCLabel;
@property(nonatomic)IBOutlet UITextView *targetsAndAlarmsView;

// Battery/Charger Labels
@property(nonatomic)IBOutlet UILabel *volts24vLabel;
@property(nonatomic)IBOutlet UILabel *volts48vOneLabel;
@property(nonatomic)IBOutlet UILabel *volts48vTwoLabel;
@property(nonatomic)IBOutlet UILabel *volts125vOneLabel;
@property(nonatomic)IBOutlet UILabel *volts125vTwoLabel;
@property(nonatomic)IBOutlet UILabel *amps24vLabel;
@property(nonatomic)IBOutlet UILabel *amps48vOneLabel;
@property(nonatomic)IBOutlet UILabel *amps48vTwoLabel;
@property(nonatomic)IBOutlet UILabel *amps125vOneLabel;
@property(nonatomic)IBOutlet UILabel *amps125vTwoLabel;
@property(nonatomic)IBOutlet UILabel *specGravity24vLabel;
@property(nonatomic)IBOutlet UILabel *specGravity48vOneLabel;
@property(nonatomic)IBOutlet UILabel *specGravity48vTwoLabel;
@property(nonatomic)IBOutlet UILabel *specGravity125vOneLabel;
@property(nonatomic)IBOutlet UILabel *specGravity125vTwoLabel;

// Circuit Switcher Labels
@property(nonatomic)IBOutlet UILabel *gasALabel;
@property(nonatomic)IBOutlet UILabel *gasBLabel;
@property(nonatomic)IBOutlet UILabel *gasCLabel;

// Transformer Labels
@property(nonatomic)IBOutlet UILabel *tankOilLevelLabel;
@property(nonatomic)IBOutlet UILabel *pressureLabel;
@property(nonatomic)IBOutlet UILabel *nitrogenTankLabel;
@property(nonatomic)IBOutlet UILabel *windingTempLabel;
@property(nonatomic)IBOutlet UILabel *oilTempLabel;
@property(nonatomic)IBOutlet UILabel *bushingOilLevel;

// LTC/Regulator Labels
@property(nonatomic)IBOutlet UILabel *minStepALabel;
@property(nonatomic)IBOutlet UILabel *presentStepALabel;
@property(nonatomic)IBOutlet UILabel *maxStepALabel;
@property(nonatomic)IBOutlet UILabel *pressureALabel;
@property(nonatomic)IBOutlet UILabel *counterALabel;
@property(nonatomic)IBOutlet UILabel *voltageALabel;
@property(nonatomic)IBOutlet UILabel *oilLevelALabel;
@property(nonatomic)IBOutlet UILabel *testOperationALabel;
@property(nonatomic)IBOutlet UILabel *minStepBLabel;
@property(nonatomic)IBOutlet UILabel *presentStepBLabel;
@property(nonatomic)IBOutlet UILabel *maxStepBLabel;
@property(nonatomic)IBOutlet UILabel *pressureBLabel;
@property(nonatomic)IBOutlet UILabel *counterBLabel;
@property(nonatomic)IBOutlet UILabel *voltageBLabel;
@property(nonatomic)IBOutlet UILabel *oilLevelBLabel;
@property(nonatomic)IBOutlet UILabel *testOperationBLabel;
@property(nonatomic)IBOutlet UILabel *minStepCLabel;
@property(nonatomic)IBOutlet UILabel *presentStepCLabel;
@property(nonatomic)IBOutlet UILabel *maxStepCLabel;
@property(nonatomic)IBOutlet UILabel *pressureCLabel;
@property(nonatomic)IBOutlet UILabel *counterCLabel;
@property(nonatomic)IBOutlet UILabel *voltageCLabel;
@property(nonatomic)IBOutlet UILabel *oilLevelCLabel;
@property(nonatomic)IBOutlet UILabel *testOperationCLabel;

// Breakers Labels
@property(nonatomic)IBOutlet UILabel *busSlotNameLabel;
@property(nonatomic)IBOutlet UILabel *busSlotCounterLabel;
@property(nonatomic)IBOutlet UILabel *busSlotTargetLabel;
@property(nonatomic)IBOutlet UILabel *busSlotOperationLabel;
@property(nonatomic)IBOutlet UILabel *busSlotPressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotOneNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotOneCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotOneTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotOneOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotOnePressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotTwoNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotTwoCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotTwoTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotTwoOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotTwoPressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotThreeNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotThreeCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotThreeTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotThreeOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotThreePressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFourNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFourCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFourTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFourOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFourPressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFiveNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFiveCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFiveTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFiveOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotFivePressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSixNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSixCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSixTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSixOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSixPressureLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSevenNameLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSevenCounterLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSevenTargetLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSevenOperationLabel;
@property(nonatomic)IBOutlet UILabel *cktSlotSevenPressureLabel;
@property(nonatomic)IBOutlet UITextView *commentsTextView;

// Views
@property(nonatomic)IBOutlet UIView *firstPage;
@property(nonatomic)IBOutlet UIView *secondPage;
@property(nonatomic)IBOutlet UIView *thirdPage;
@property(nonatomic)IBOutlet UIView *fourthPage;
@property(nonatomic)IBOutlet UIView *fifthPage;


@end

@implementation RenderPDFViewController

@synthesize currentInspection;
@synthesize mailComposer;
@synthesize imageArray;
@synthesize pdfPage;
@synthesize locationHelper;

@synthesize stationNameLabel;
@synthesize dateTimeLabel;
@synthesize technicianLabel;
@synthesize locationImageView;

@synthesize kwhLabel;
@synthesize mwdLabel;
@synthesize plusKVARHLabel;
@synthesize minusKVARHLabel;
@synthesize maxVARDLabel;
@synthesize minVARDLabel;
@synthesize rainGaugeView;
@synthesize detentionBasinCommentsView;

@synthesize firstPage;
@synthesize secondPage;
@synthesize thirdPage;
@synthesize fourthPage;
@synthesize fifthPage;

@synthesize maxAmpALabel;
@synthesize maxAmpBLabel;
@synthesize maxAmpCLabel;
@synthesize presentAmpALabel;
@synthesize presentAmpBLabel;
@synthesize presentAmpCLabel;
@synthesize minVoltsALabel;
@synthesize minVoltsBLabel;
@synthesize minVoltsCLabel;
@synthesize presentVoltsALabel;
@synthesize presentVoltsBLabel;
@synthesize presentVoltsCLabel;
@synthesize maxVoltsALabel;
@synthesize maxVoltsBLabel;
@synthesize maxVoltsCLabel;
@synthesize targetsAndAlarmsView;

@synthesize volts24vLabel;
@synthesize volts48vOneLabel;
@synthesize volts48vTwoLabel;
@synthesize volts125vOneLabel;
@synthesize volts125vTwoLabel;
@synthesize amps24vLabel;
@synthesize amps48vOneLabel;
@synthesize amps48vTwoLabel;
@synthesize amps125vOneLabel;
@synthesize amps125vTwoLabel;
@synthesize specGravity24vLabel;
@synthesize specGravity48vOneLabel;
@synthesize specGravity48vTwoLabel;
@synthesize specGravity125vOneLabel;
@synthesize specGravity125vTwoLabel;

@synthesize gasALabel;
@synthesize gasBLabel;
@synthesize gasCLabel;

@synthesize tankOilLevelLabel;
@synthesize pressureLabel;
@synthesize nitrogenTankLabel;
@synthesize windingTempLabel;
@synthesize oilTempLabel;
@synthesize bushingOilLevel;

@synthesize minStepALabel;
@synthesize presentStepALabel;
@synthesize maxStepALabel;
@synthesize pressureALabel;
@synthesize counterALabel;
@synthesize voltageALabel;
@synthesize oilLevelALabel;
@synthesize testOperationALabel;
@synthesize minStepBLabel;
@synthesize presentStepBLabel;
@synthesize maxStepBLabel;
@synthesize pressureBLabel;
@synthesize counterBLabel;
@synthesize voltageBLabel;
@synthesize oilLevelBLabel;
@synthesize testOperationBLabel;
@synthesize minStepCLabel;
@synthesize presentStepCLabel;
@synthesize maxStepCLabel;
@synthesize pressureCLabel;
@synthesize counterCLabel;
@synthesize voltageCLabel;
@synthesize oilLevelCLabel;
@synthesize testOperationCLabel;

@synthesize busSlotNameLabel;
@synthesize busSlotCounterLabel;
@synthesize busSlotTargetLabel;
@synthesize busSlotOperationLabel;
@synthesize busSlotPressureLabel;
@synthesize cktSlotOneNameLabel;
@synthesize cktSlotOneCounterLabel;
@synthesize cktSlotOneTargetLabel;
@synthesize cktSlotOneOperationLabel;
@synthesize cktSlotOnePressureLabel;
@synthesize cktSlotTwoNameLabel;
@synthesize cktSlotTwoCounterLabel;
@synthesize cktSlotTwoTargetLabel;
@synthesize cktSlotTwoOperationLabel;
@synthesize cktSlotTwoPressureLabel;
@synthesize cktSlotThreeNameLabel;
@synthesize cktSlotThreeCounterLabel;
@synthesize cktSlotThreeTargetLabel;
@synthesize cktSlotThreeOperationLabel;
@synthesize cktSlotThreePressureLabel;
@synthesize cktSlotFourNameLabel;
@synthesize cktSlotFourCounterLabel;
@synthesize cktSlotFourTargetLabel;
@synthesize cktSlotFourOperationLabel;
@synthesize cktSlotFourPressureLabel;
@synthesize cktSlotFiveNameLabel;
@synthesize cktSlotFiveCounterLabel;
@synthesize cktSlotFiveTargetLabel;
@synthesize cktSlotFiveOperationLabel;
@synthesize cktSlotFivePressureLabel;
@synthesize cktSlotSixNameLabel;
@synthesize cktSlotSixCounterLabel;
@synthesize cktSlotSixTargetLabel;
@synthesize cktSlotSixOperationLabel;
@synthesize cktSlotSixPressureLabel;
@synthesize cktSlotSevenNameLabel;
@synthesize cktSlotSevenCounterLabel;
@synthesize cktSlotSevenTargetLabel;
@synthesize cktSlotSevenOperationLabel;
@synthesize cktSlotSevenPressureLabel;
@synthesize commentsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithInspection:(Inspection *)theInspection{
    if(self == [super init]){
        if(!currentInspection){
            currentInspection = [[Inspection alloc]init];
        }
        currentInspection = theInspection;
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(displayMenu)];
    [MenuButtonHelper setParentController:self];
    NSArray *titlesArray = [[NSArray alloc]initWithObjects:@"Next Page", @"Send PDF", nil];
    [[MenuButtonHelper sharedHelper]addButtonsWithTitlesToActionSheet:titlesArray];
    [[MenuButtonHelper sharedHelper]setButtonOneTarget:self forSelector:@selector(changePage)];
    [[MenuButtonHelper sharedHelper]setButtonTwoTarget:self forSelector:@selector(quicklyDrawPDF)];
    
    imageArray = [[NSMutableArray alloc]init];
    
    pdfPage = 0;
    
    if(!locationHelper){
        locationHelper = [[LocationHelper alloc]initWithDelegate:self];
    }
    [locationHelper findLocation];
    
    [self addInspectionDataToLabels];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)addInspectionDataToLabels{
    if(currentInspection){
        NSString *pass = @"Pass";
        NSString *fail = @"Fail";
        NSString *notAvailable = @"N/A";
        
        // General Settings
        if(currentInspection.generalSettings.stationName){
            stationNameLabel.text = currentInspection.generalSettings.stationName;
        }else{
            stationNameLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.dateTime){
            dateTimeLabel.text = currentInspection.generalSettings.dateTime;
        }else{
            dateTimeLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.technician){
            technicianLabel.text = currentInspection.generalSettings.technician;
        }else{
            technicianLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.kwh){
            kwhLabel.text = currentInspection.generalSettings.kwh;
        }else{
            kwhLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.mwd){
            mwdLabel.text = currentInspection.generalSettings.mwd;
        }else{
            mwdLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.positiveKVARH){
            plusKVARHLabel.text = currentInspection.generalSettings.positiveKVARH;
        }else{
            plusKVARHLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.negativeKVARH){
            minusKVARHLabel.text = currentInspection.generalSettings.negativeKVARH;
        }else{
            minusKVARHLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.maxVARD){
            maxVARDLabel.text = currentInspection.generalSettings.maxVARD;
        }else{
            maxVARDLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.minVARD){
            minVARDLabel.text = currentInspection.generalSettings.minVARD;
        }else{
            minVARDLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.rainGauge){
            rainGaugeView.text = currentInspection.generalSettings.rainGauge;
        }else{
            rainGaugeView.text = notAvailable;
        }
        if(currentInspection.generalSettings.detentionBasinComments){
            detentionBasinCommentsView.text = currentInspection.generalSettings.detentionBasinComments;
        }else{
            detentionBasinCommentsView.text = notAvailable;
        }
        
        // Switch Board
        if(currentInspection.switchBoard.maxAmpA){
            maxAmpALabel.text = currentInspection.switchBoard.maxAmpA;
        }else{
            maxAmpALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxAmpB){
            maxAmpBLabel.text = currentInspection.switchBoard.maxAmpB;
        }else{
            maxAmpBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxAmpC){
            maxAmpCLabel.text = currentInspection.switchBoard.maxAmpC;
        }else{
            maxAmpCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpA){
            presentAmpALabel.text = currentInspection.switchBoard.presentAmpA;
        }else{
            presentAmpALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpB){
            presentAmpBLabel.text = currentInspection.switchBoard.presentAmpB;
        }else{
            presentAmpBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpC){
            presentAmpCLabel.text = currentInspection.switchBoard.presentAmpC;
        }else{
            presentAmpCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsA){
            minVoltsALabel.text = currentInspection.switchBoard.minVoltsA;
        }else{
            minVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsB){
            minVoltsBLabel.text = currentInspection.switchBoard.minVoltsB;
        }else{
            minVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsC){
            minVoltsCLabel.text = currentInspection.switchBoard.minVoltsC;
        }else{
            minVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsA){
            presentVoltsALabel.text = currentInspection.switchBoard.presentVoltsA;
        }else{
            presentVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsB){
            presentVoltsBLabel.text = currentInspection.switchBoard.presentVoltsB;
        }else{
            presentVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsC){
            presentVoltsCLabel.text = currentInspection.switchBoard.presentVoltsC;
        }else{
            presentVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsA){
            maxVoltsALabel.text = currentInspection.switchBoard.maxVoltsA;
        }else{
            maxVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsB){
            maxVoltsBLabel.text = currentInspection.switchBoard.maxVoltsB;
        }else{
            maxVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsC){
            maxVoltsCLabel.text = currentInspection.switchBoard.maxVoltsC;
        }else{
            maxVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.targetsAndAlarms){
            targetsAndAlarmsView.text = currentInspection.switchBoard.targetsAndAlarms;
        }else{
            targetsAndAlarmsView.text = notAvailable;
        }
        
        // Battery/Charger
        if(currentInspection.batteryCharger.volts24V){
            volts24vLabel.text = currentInspection.batteryCharger.volts24V;
        }else{
            volts24vLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.amps24V){
            amps24vLabel.text = currentInspection.batteryCharger.amps24V;
        }else{
            amps24vLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.specGravity24V){
            specGravity24vLabel.text = currentInspection.batteryCharger.specGravity24V;
        }else{
            specGravity24vLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.volts48VOne){
            volts48vOneLabel.text = currentInspection.batteryCharger.volts48VOne;
        }else{
            volts48vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.amps48VOne){
            amps48vOneLabel.text = currentInspection.batteryCharger.amps48VOne;
        }else{
            amps48vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.specGravity48VOne){
            specGravity48vOneLabel.text = currentInspection.batteryCharger.specGravity48VOne;
        }else{
            specGravity48vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.volts48VTwo){
            volts48vTwoLabel.text = currentInspection.batteryCharger.volts48VTwo;
        }else{
            volts48vTwoLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.amps48VTwo){
            amps48vTwoLabel.text = currentInspection.batteryCharger.amps48VTwo;
        }else{
            amps48vTwoLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.specGravity48VTwo){
            specGravity48vTwoLabel.text = currentInspection.batteryCharger.specGravity48VTwo;
        }else{
            specGravity48vTwoLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.volts125VOne){
            volts125vOneLabel.text = currentInspection.batteryCharger.volts125VOne;
        }else{
            volts125vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.amps125VOne){
            amps125vOneLabel.text = currentInspection.batteryCharger.amps125VOne;
        }else{
            amps125vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.specGravity125VOne){
            specGravity125vOneLabel.text = currentInspection.batteryCharger.specGravity125VOne;
        }else{
            specGravity125vOneLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.volts125VTwo){
            volts125vTwoLabel.text = currentInspection.batteryCharger.volts125VTwo;
        }else{
            volts125vTwoLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.amps125VTwo){
            amps125vTwoLabel.text = currentInspection.batteryCharger.amps125VTwo;
        }else{
            amps125vTwoLabel.text = notAvailable;
        }
        if(currentInspection.batteryCharger.specGravity125VTwo){
            specGravity125vTwoLabel.text = currentInspection.batteryCharger.specGravity125VTwo;
        }else{
            specGravity125vTwoLabel.text = notAvailable;
        }
        
        // Circuit Switcher
        if(currentInspection.circuitSwitcher.gasA == YES){
            gasALabel.text = pass;
        }else if(currentInspection.circuitSwitcher.gasA == NO){
            gasALabel.text = fail;
        }else{
            gasALabel.text = notAvailable;
        }
        if(currentInspection.circuitSwitcher.gasB == YES){
            gasBLabel.text = pass;
        }else if(currentInspection.circuitSwitcher.gasB == NO){
            gasBLabel.text = fail;
        }else{
            gasBLabel.text = notAvailable;
        }
        if(currentInspection.circuitSwitcher.gasC == YES){
            gasCLabel.text = pass;
        }else if(currentInspection.circuitSwitcher.gasC == NO){
            gasCLabel.text = fail;
        }else{
            gasCLabel.text = notAvailable;
        }
        
        // Transformer
        if(currentInspection.transformer.tankOilLevel == YES){
            tankOilLevelLabel.text = pass;
        }else if(currentInspection.transformer.tankOilLevel == NO){
            tankOilLevelLabel.text = fail;
        }else{
            tankOilLevelLabel.text = notAvailable;
        }
        if(currentInspection.transformer.pressure){
            pressureLabel.text = currentInspection.transformer.pressure;
        }else{
            pressureLabel.text = notAvailable;
        }
        if(currentInspection.transformer.nitrogenTank){
            nitrogenTankLabel.text = currentInspection.transformer.nitrogenTank;
        }else{
            nitrogenTankLabel.text = notAvailable;
        }
        if(currentInspection.transformer.windingTemp){
            windingTempLabel.text = currentInspection.transformer.windingTemp;
        }else{
            windingTempLabel.text = notAvailable;
        }
        if(currentInspection.transformer.oilTemp){
            oilTempLabel.text = currentInspection.transformer.oilTemp;
        }else{
            oilTempLabel.text = notAvailable;
        }
        if(currentInspection.transformer.bushingOilLevel == YES){
            bushingOilLevel.text = pass;
        }else if(currentInspection.transformer.bushingOilLevel == NO){
            bushingOilLevel.text = fail;
        }else{
            bushingOilLevel.text = notAvailable;
        }
        
        // LTC/Regulator
        if(currentInspection.ltcRegulator.minStepA){
            minStepALabel.text = currentInspection.ltcRegulator.minStepA;
        }else{
            minStepALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureStepA){
            presentStepALabel.text = currentInspection.ltcRegulator.pressureStepA;
        }else{
            presentStepALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.maxStepA){
            maxStepALabel.text = currentInspection.ltcRegulator.maxStepA;
        }else{
            maxStepALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureA == YES){
            pressureALabel.text = pass;
        }else if(currentInspection.ltcRegulator.pressureA == NO){
            pressureALabel.text = fail;
        }else{
            pressureALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.counterA){
            counterALabel.text = currentInspection.ltcRegulator.counterA;
        }else{
            counterALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.voltageA){
            voltageALabel.text = currentInspection.ltcRegulator.voltageA;
        }else{
            voltageALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.oilLevelA == YES){
            oilLevelALabel.text = pass;
        }else if(currentInspection.ltcRegulator.oilLevelA == NO){
            oilLevelALabel.text = fail;
        }else{
            oilLevelALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.testOperationA == YES){
            testOperationALabel.text = pass;
        }else if(currentInspection.ltcRegulator.testOperationA == NO){
            testOperationALabel.text = fail;
        }else{
            testOperationALabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.minStepB){
            minStepBLabel.text = currentInspection.ltcRegulator.minStepB;
        }else{
            minStepBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureStepB){
            presentStepBLabel.text = currentInspection.ltcRegulator.pressureStepB;
        }else{
            presentStepBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.maxStepB){
            maxStepBLabel.text = currentInspection.ltcRegulator.maxStepB;
        }else{
            maxStepBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureB == YES){
            pressureBLabel.text = pass;
        }else if(currentInspection.ltcRegulator.pressureB == NO){
            pressureBLabel.text = fail;
        }else{
            pressureBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.counterB){
            counterBLabel.text = currentInspection.ltcRegulator.counterB;
        }else{
            counterBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.voltageB){
            voltageBLabel.text = currentInspection.ltcRegulator.voltageB;
        }else{
            voltageBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.oilLevelB == YES){
            oilLevelBLabel.text = pass;
        }else if(currentInspection.ltcRegulator.oilLevelB == NO){
            oilLevelBLabel.text = fail;
        }else{
            oilLevelBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.testOperationB == YES){
            testOperationBLabel.text = pass;
        }else if(currentInspection.ltcRegulator.testOperationB == NO){
            testOperationBLabel.text = fail;
        }else{
            testOperationBLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.minStepC){
            minStepCLabel.text = currentInspection.ltcRegulator.minStepC;
        }else{
            minStepCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureStepC){
            presentStepCLabel.text = currentInspection.ltcRegulator.pressureStepC;
        }else{
            presentStepCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.maxStepC){
            maxStepCLabel.text = currentInspection.ltcRegulator.maxStepC;
        }else{
            maxStepCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.pressureC == YES){
            pressureCLabel.text = pass;
        }else if(currentInspection.ltcRegulator.pressureC == NO){
            pressureCLabel.text = fail;
        }else{
            pressureCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.counterC){
            counterCLabel.text = currentInspection.ltcRegulator.counterC;
        }else{
            counterCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.voltageC){
            voltageCLabel.text = currentInspection.ltcRegulator.voltageC;
        }else{
            voltageCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.oilLevelC == YES){
            oilLevelCLabel.text = pass;
        }else if(currentInspection.ltcRegulator.oilLevelC == NO){
            oilLevelCLabel.text = fail;
        }else{
            oilLevelCLabel.text = notAvailable;
        }
        if(currentInspection.ltcRegulator.testOperationC == YES){
            testOperationCLabel.text = pass;
        }else if(currentInspection.ltcRegulator.testOperationC == NO){
            testOperationCLabel.text = fail;
        }else{
            testOperationCLabel.text = notAvailable;
        }
        
        // Breakers
        if(currentInspection.breakers.busSlotNumber){
            busSlotNameLabel.text = [[NSString alloc]initWithFormat:@"BUS. %@", currentInspection.breakers.busSlotNumber];
        }else{
            // Do nothing.
        }
        if(currentInspection.breakers.busSlotCounterValue){
            busSlotCounterLabel.text = currentInspection.breakers.busSlotCounterValue;
        }else{
            busSlotCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.busSlotTargetValue){
            busSlotTargetLabel.text = currentInspection.breakers.busSlotTargetValue;
        }else{
            busSlotTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.busSlotOperationValue){
            busSlotOperationLabel.text = currentInspection.breakers.busSlotOperationValue;
        }else{
            busSlotOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.busSlotPressureValue){
            busSlotPressureLabel.text = currentInspection.breakers.busSlotPressureValue;
        }else{
            busSlotPressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotOneNumber){
            cktSlotOneNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotOneNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotOneCounterValue){
            cktSlotOneCounterLabel.text = currentInspection.breakers.cktSlotOneCounterValue;
        }else{
            cktSlotOneCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotOneTargetValue){
            cktSlotOneTargetLabel.text = currentInspection.breakers.cktSlotOneTargetValue;
        }else{
            cktSlotOneTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotOneOperationValue){
            cktSlotOneOperationLabel.text = currentInspection.breakers.cktSlotOneOperationValue;
        }else{
            cktSlotOneOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotOnePressureValue){
            cktSlotOnePressureLabel.text = currentInspection.breakers.cktSlotOnePressureValue;
        }else{
            cktSlotOnePressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotTwoNumber){
            cktSlotTwoNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotTwoNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotTwoCounterValue){
            cktSlotTwoCounterLabel.text = currentInspection.breakers.cktSlotTwoCounterValue;
        }else{
            cktSlotTwoCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotTwoTargetValue){
            cktSlotTwoTargetLabel.text = currentInspection.breakers.cktSlotTwoTargetValue;
        }else{
            cktSlotTwoTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotTwoOperationValue){
            cktSlotTwoOperationLabel.text = currentInspection.breakers.cktSlotTwoOperationValue;
        }else{
            cktSlotTwoOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotTwoPressureValue){
            cktSlotTwoPressureLabel.text = currentInspection.breakers.cktSlotTwoPressureValue;
        }else{
            cktSlotTwoPressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotThreeNumber){
            cktSlotThreeNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotThreeNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotThreeCounterValue){
            cktSlotThreeCounterLabel.text = currentInspection.breakers.cktSlotThreeCounterValue;
        }else{
            cktSlotThreeCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotThreeTargetValue){
            cktSlotThreeTargetLabel.text = currentInspection.breakers.cktSlotThreeTargetValue;
        }else{
            cktSlotThreeTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotThreeOperationValue){
            cktSlotThreeOperationLabel.text = currentInspection.breakers.cktSlotThreeOperationValue;
        }else{
            cktSlotThreeOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotThreePressureValue){
            cktSlotThreePressureLabel.text = currentInspection.breakers.cktSlotThreePressureValue;
        }else{
            cktSlotThreePressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFourNumber){
            cktSlotFourNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotFourNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotFourCounterValue){
            cktSlotFourCounterLabel.text = currentInspection.breakers.cktSlotFourCounterValue;
        }else{
            cktSlotFourCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFourTargetValue){
            cktSlotFourTargetLabel.text = currentInspection.breakers.cktSlotFourTargetValue;
        }else{
            cktSlotFourTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFourOperationValue){
            cktSlotFourOperationLabel.text = currentInspection.breakers.cktSlotFourOperationValue;
        }else{
            cktSlotFourOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFourPressureValue){
            cktSlotFourPressureLabel.text = currentInspection.breakers.cktSlotFourPressureValue;
        }else{
            cktSlotFourPressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFiveNumber){
            cktSlotFiveNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotFiveNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotFiveCounterValue){
            cktSlotFiveCounterLabel.text = currentInspection.breakers.cktSlotFiveCounterValue;
        }else{
            cktSlotFiveCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFiveTargetValue){
            cktSlotFiveTargetLabel.text = currentInspection.breakers.cktSlotFiveTargetValue;
        }else{
            cktSlotFiveTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFiveOperationValue){
            cktSlotFiveOperationLabel.text = currentInspection.breakers.cktSlotFiveOperationValue;
        }else{
            cktSlotFiveOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotFivePressureValue){
            cktSlotFivePressureLabel.text = currentInspection.breakers.cktSlotFivePressureValue;
        }else{
            cktSlotFivePressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSixNumber){
            cktSlotSixNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotSixNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotSixCounterValue){
            cktSlotSixCounterLabel.text = currentInspection.breakers.cktSlotSixCounterValue;
        }else{
            cktSlotSixCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSixTargetValue){
            cktSlotSixTargetLabel.text = currentInspection.breakers.cktSlotSixTargetValue;
        }else{
            cktSlotSixTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSixOperationValue){
            cktSlotSixOperationLabel.text = currentInspection.breakers.cktSlotSixOperationValue;
        }else{
            cktSlotSixOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSixPressureValue){
            cktSlotSixPressureLabel.text = currentInspection.breakers.cktSlotSixPressureValue;
        }else{
            cktSlotSixPressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSevenNumber){
            cktSlotSevenNameLabel.text = [self setCircuitName:currentInspection.breakers.cktSlotSevenNumber];
        }else{
            // Do Nothing.
        }
        if(currentInspection.breakers.cktSlotSevenCounterValue){
            cktSlotSevenCounterLabel.text = currentInspection.breakers.cktSlotSevenCounterValue;
        }else{
            cktSlotSevenCounterLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSevenTargetValue){
            cktSlotSevenTargetLabel.text = currentInspection.breakers.cktSlotSevenTargetValue;
        }else{
            cktSlotSevenTargetLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSevenOperationValue){
            cktSlotSevenOperationLabel.text = currentInspection.breakers.cktSlotSevenOperationValue;
        }else{
            cktSlotSevenOperationLabel.text = notAvailable;
        }
        if(currentInspection.breakers.cktSlotSevenPressureValue){
            cktSlotSevenPressureLabel.text = currentInspection.breakers.cktSlotSevenPressureValue;
        }else{
            cktSlotSevenPressureLabel.text = notAvailable;
        }
        if(currentInspection.breakers.comments){
            commentsTextView.text = currentInspection.breakers.comments;
        }else{
            commentsTextView.text = notAvailable;
        }
    }
}

-(NSString*)setCircuitName:(NSString*)circuitNumber{
    NSString *circuitName = [[NSString alloc]initWithFormat:@"CKT. %@",circuitNumber];
    return circuitName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)pdfFilePathWithStation:(NSString*)station date:(NSString*)date andTechnician:(NSString*)technician{
    NSString *trimmedDate = [self trimString:date];
    
    NSString *theFileName = [[NSString alloc]initWithFormat:@"%@_%@_%@.pdf", station, trimmedDate, technician];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:theFileName];
}

-(NSString*)createPDFFileNameWithStation:(NSString*)station date:(NSString*)date andTechnician:(NSString*)technician{
    NSString *trimmedDate = [self trimString:date];
    
    NSString *theFileName = [[NSString alloc]initWithFormat:@"%@_%@_%@.pdf", station, trimmedDate, technician];
    NSLog(@"File name is: %@",theFileName);
    
    return theFileName;
}

-(NSString*)trimString:(NSString*)theString{
    NSString *trimmedString = [theString stringByReplacingOccurrencesOfString:@" " withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return trimmedString;
}

-(void)changePage{
    switch(pdfPage){
        case 0:
            if(firstPage.alpha == 0.0){
                firstPage.alpha = 1.0;
            }
            [self captureScreen];
            [self makeViewVanish:firstPage];
            break;
        case 1:
            if(secondPage.alpha == 0.0){
                secondPage.alpha = 1.0;
            }
            [self captureScreen];
            [self makeViewVanish:secondPage];
            break;
        case 2:
            if(thirdPage.alpha == 0.0){
                thirdPage.alpha = 1.0;
            }
            [self captureScreen];
            [self makeViewVanish:thirdPage];
            break;
        case 3:
            if(fourthPage.alpha == 0.0){
                fourthPage.alpha = 1.0;
            }
            [self captureScreen];
            [self makeViewVanish:fourthPage];
            break;
        case 4:
            if(fifthPage.alpha == 0.0){
                fifthPage.alpha = 1.0;
            }
            [self captureScreen];
            [self makeViewVanish:fifthPage];
            [self drawPDF];
            break;
        default:
            break;
    }
    pdfPage += 1;
}

-(void)resetPages{
    pdfPage = 0;
    
    if(firstPage.alpha == 0.0){
        firstPage.alpha = 1.0;
    }
    if(secondPage.alpha == 0.0){
        secondPage.alpha = 1.0;
    }
    if(thirdPage.alpha == 0.0){
        thirdPage.alpha = 1.0;
    }
    if(fourthPage.alpha == 0.0){
        fourthPage.alpha = 1.0;
    }
    if(fifthPage.alpha == 0.0){
        fifthPage.alpha = 1.0;
    }
}

-(void)makeViewVanish:(UIView*)aView{
    [UIView animateWithDuration:0.5 animations:^{
        aView.alpha = 0.0;
    }];
}


#pragma mark - PDF Drawing Methods

-(void)captureScreen{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageArray addObject:image];
}

-(void)drawPDF{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile([self pdfFilePathWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician], CGRectZero, nil);
    
    for(int i = 0; i < 5; i++){
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        
        [[imageArray objectAtIndex:i] drawInRect:CGRectMake(0, 0, 612, 792)];
    }
    
    // End and save the PDF.
    UIGraphicsEndPDFContext();
    
    [self displayMailComposer];
}


#pragma mark - MailPicker Methods

-(void)displayMailComposer{
    if(mailComposer){
        mailComposer = nil;
    }
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    
    NSString *pdfFilePath = [self pdfFilePathWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
    
    NSData *pdfData = [[NSData alloc]initWithContentsOfFile:pdfFilePath];
    
    NSString *pdfFileName = [self createPDFFileNameWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
    
    
    NSString *subjectString = [[NSString alloc]initWithFormat:@"%@ %@",currentInspection.generalSettings.stationName, currentInspection.generalSettings.dateTime];
    [mailComposer setSubject:subjectString];
    [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfFileName];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultSent){
        NSLog(@"Mail sent!");
        NSString *pdfFilePath = [self pdfFilePathWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
        if(pdfFilePath){
            [self createJSONDictionaryWithFile:pdfFilePath];
            // Remove the PDF so we don't waste storage on the device.
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:pdfFilePath error:&error];
        }
    }else if(result == MFMailComposeResultFailed){
        NSLog(@"Mail failed to be sent.");
    }else if(result == MFMailComposeResultCancelled){
        NSLog(@"Mail cancelled");
        [self resetPages];
        [mailComposer dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Network-Related Methods

-(void)createJSONDictionaryWithFile:(NSString*)theFilePath{
    NSString *filePath = theFilePath;
    NSData *pdfFileData = [[NSData alloc]initWithContentsOfFile:filePath];
    if(currentInspection && pdfFileData){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"YYYYMMdd"];
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        NSDictionary *JSONDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:currentInspection.generalSettings.stationName, @"station_name", dateString, @"date", [NSString stringWithFormat:@"%@", pdfFileData], @"file", nil];
        NSLog(@"JSON Dictionary created contains:\n%@", JSONDictionary);
        [[NetworkConnectionManager sharedManager]beginConnectionWithPurpose:@"PDF" withJSONDictionary:JSONDictionary forCaller:self];
    }else{
        [self showFileErrorAlertView];
    }
}

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if(theObjects){
        NSLog(@"Objects returned are:\n%@", theObjects);
        NSDictionary *resultDictionary = [theObjects objectAtIndex:0];
        if([[resultDictionary objectForKey:@"result"] isEqualToString:@"Created"]){
            NSLog(@"Success");
        }else{
            NSLog(@"Error!");
            [self showResponseErrorAlertView];
        }
    }
    [mailComposer dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showResponseErrorAlertView{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Response Error!" message:@"There was an error returned from the server.\nPlease try again." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles:nil];
    [alertView show];
}

-(void)showFileErrorAlertView{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"File Error!" message:@"The PDF file you're trying to send does not exist.\nPlease go back and try again." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles:nil];
    [alertView show];
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
    [self showResponseErrorAlertView];
}


#pragma mark - MenuButton Methods

-(void)displayMenu{
    [[MenuButtonHelper sharedHelper]displayMenu];
}

-(void)quicklyDrawPDF{
    if([imageArray count] > 0){
        [imageArray removeAllObjects];
    }
    
    pdfPage = 0;
    
    for(int i = 0; i < 5; i++){
        [self changePage];
    }
}


#pragma mark - Location Helper Methods

-(void)locationHelperDidFail{
    NSLog(@"Location Helper Failed!");
}

-(void)locationHelperDidSucceed:(CLLocation *)theLocation{
    CLLocation *returnedLocation = theLocation;
    
    NSArray *stationArray = [self stationInformation];
    
    if(stationArray){
        for(int i = 0; i < [stationArray count]; i++){
            NSDictionary *aDictionary = [stationArray objectAtIndex:i];
            if([[aDictionary objectForKey:@"Identifier"] isEqualToString:currentInspection.stationIdentifier]){
                Station *newStation = [[Station alloc]init];
                newStation.stationIdentifier = [aDictionary objectForKey:@"Identifier"];
                newStation.stationName = [aDictionary objectForKey:@"Name"];
                newStation.stationNumber = [[aDictionary objectForKey:@"Number"] intValue];
                newStation.stationLatitude = [aDictionary objectForKey:@"Latitude"];
                newStation.stationLongitude = [aDictionary objectForKey:@"Longitude"];
                
                NSLog(@"The coordinates for %@ are: %@, %@", newStation.stationName, newStation.stationLatitude, newStation.stationLongitude);
                
                CLLocation *stationLocation = [[CLLocation alloc]initWithLatitude:[newStation.stationLatitude doubleValue] longitude:[newStation.stationLongitude doubleValue]];
                
                CLLocationDistance locationDistance = [stationLocation distanceFromLocation:returnedLocation];
                
                NSLog(@"The distance from %@ is %f feet.",newStation.stationName,(locationDistance*3.280));
                
                NSString *distanceString = [NSString stringWithFormat:@"%f", (locationDistance*3.280)];
                
                if([distanceString integerValue] > 1000){
                    locationImageView.backgroundColor = [UIColor redColor];
                }else if([distanceString integerValue] <= 1000){
                    locationImageView.backgroundColor = [UIColor greenColor];
                }
            }
        }
    }else{
        NSLog(@"Error! Unable to access \"Stations\" property list.");
    }
}

-(void)locationHelperAuthorizationStatusDidChange{
    // Do nothing.
}

-(NSArray*)stationInformation{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Stations" withExtension:@"plist"];
    if(url){
        NSDictionary *stationsDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
        NSArray *stationsArray = [stationsDictionary objectForKey:@"Stations"];
        return stationsArray;
    }
    return nil;
}

@end
