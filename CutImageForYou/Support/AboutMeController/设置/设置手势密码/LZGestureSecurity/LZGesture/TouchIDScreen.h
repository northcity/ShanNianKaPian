//
//  TouchIDScreen.h
//  CutImageForYou
//
//  Created by chenxi on 2018/6/8.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol LZGestureScreenDelegate <NSObject>
//
//- (void)screen:(LZGestureScreen *)screen didSetup:(NSString *)psw;
//
//@end
@interface TouchIDScreen : NSObject
+ (instancetype)shared;
- (void)show;
- (void)dismiss;
@end
