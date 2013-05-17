//
//  UIColor+HexString.m
//  GUC
//
//  Created by Michael Brodeur on 5/17/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+(UIColor*)colorWithHexString:(NSString*)hexString{
    NSString *colorString = [hexString uppercaseString];
    
    NSLog(@"%@",colorString);
    
    char colorBytes[3] = {'\0', '\0', '\0'};
    NSInteger redValue;
    NSInteger greenValue;
    NSInteger blueValue;
    
    for(int i = 0; i < 3; i++){
        colorBytes[0] = [colorString characterAtIndex:i*2];
        colorBytes[1] = [colorString characterAtIndex:(i*2)+1];
        
        if(i == 0){
            redValue = strtol(colorBytes, NULL, 16);
            NSLog(@"Red: %i", redValue);
        }else if(i == 1){
            greenValue = strtol(colorBytes, NULL, 16);
            NSLog(@"Green: %i", greenValue);
        }else if(i == 2){
            blueValue = strtol(colorBytes, NULL, 16);
            NSLog(@"Blue: %i", blueValue);
        }
    }
    
    float redFloat = redValue;
    float greenFloat = greenValue;
    float blueFloat = blueValue;
    
    NSLog(@"Values are: Red:%f, Green:%f, Blue:%f", redFloat, greenFloat, blueFloat);
    
    return [UIColor colorWithRed:redFloat/255.0f green:greenFloat/255.0f blue:blueFloat/255.0f alpha:1.0f];
}

@end
