//
//  Question.m
//  guesspicture
//
//  Created by 郎坤也 on 15/2/26.
//  Copyright (c) 2015年 郎坤也. All rights reserved.
//

#import "Question.h"
#import <UIKit/UIKit.h>
/**写真*/
@interface Question()
{
    UIImage *_image;
}

@end

@implementation Question

/**写真の遅延ロード、写真がある場合、表示する*/
- (UIImage *)image
{
    if (!_image) {
        _image = [UIImage imageNamed:self.icon];
    }
    
    return _image;
}
/**オブジェクトのプロパティに間接的にアクセスするための仕組みです*/
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
/**_______________________________________________________________________
 単純型コレクション演算子
 単純型コレクション演算子は、右キーパスで指定したプロパティに対して作用します。す。
//        self.answer = dict[@"answer"];
//        self.icon = dict[@"icon"];
//        self.title = dict[@"title"];
//        self.options = dict[@"options"];
        
        // kvc(key value coding)
        //cocoa
//        [self setValue:dict[@"answer"] forKeyPath:@"answer"];
//        [self setValue:dict[@"icon"] forKeyPath:@"icon"];
//
//        [self setValue:dict[@"titile"] forKeyPath:@"title"];
//
//        [self setValue:dict[@"options"] forKeyPath:@"options"];
 __________________________________________________________________________*/

        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+(instancetype)questionWithDict:(NSDictionary *)dict;
{
    return [[self alloc] initWithDict:dict];
}
+(NSArray *)questions
{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil] ];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array ) {
        // Question *question = [Question questionWithDict:dict];
        [arrayM addObject:[Question questionWithDict:dict]];
    }

    return arrayM;
}
@end
