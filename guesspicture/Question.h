//
//  Question.h
//  guesspicture
//
//  Created by 郎坤也 on 15/2/26.
//  Copyright (c) 2015年 郎坤也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject
/**答え*/
@property(nonatomic,copy) NSString *answer;
/**タイトル*/
@property(nonatomic,copy) NSString *title;
/**アイコン*/
@property(nonatomic,copy) NSString *icon;
/**予備文字の配列*/
@property(nonatomic,strong) NSArray *options;
@property (nonatomic,strong,readonly) UIImage *image;
//メソッドの返り値
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;

+(NSArray *)questions;

@end
