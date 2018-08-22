//
//  NSString+DKExtension.h
//  DKCategory
//
//  Created by 雪凌 on 2018/8/19.
//  Copyright © 2018年 雪凌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DKExtension)

#pragma mark- *** Common ***

/**
 *  获取字符串中字符的个数
 *
 *  @return 字符串中字符的个数
 */
- (NSInteger)dk_wordsCount;


#pragma mark- *** Contains ***

/**
 *  字符串中是否包含中文
 *
 *  @return 包含: YES 不包含: NO
 */
- (BOOL)dk_containChinese;

/**
 *  字符串中是否包含空格
 *
 *  @return 包含: YES 不包含: NO
 */
- (BOOL)dk_containBlank;

/**
 *  字符串中是否包CharacterSet
 *
 *  @param set 被检测的Set
 *
 *  @return 包含: YES 不包含: NO
 */
- (BOOL)dk_containsCharacterSet:(NSCharacterSet *)set;

/**
 *  字符串中是否包某个字符串
 *
 *  @param string 被检测的字符串
 *
 *  @return 包含: YES 不包含: NO
 */
- (BOOL)dk_containsString:(NSString *)string;

/**
 *  字符串中是否包表情符号
 *
 *  @return 包含: YES 不包含: NO
 */
- (BOOL)dk_containEmoji;


#pragma mark- *** Trims  ***

/**
 *  去除字符串中的空格
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)dk_trimmingWhitespace;

/**
 *  去除字符串中的换行符与空行
 *
 *  @return 去除字符串与空行的字符串
 */
- (NSString *)dk_trimmingWhitespaceAndNewlines;

/**
 *  去除字符串中html标签
 *
 *  @return 去除html标签后的结果
 */
- (NSString *)dk_trimmingHTML;

/**
 *  去除js脚本和html标签
 *
 *  @return 去除js和html标签后的结果
 */
- (NSString *)dk_trimmingScriptsAndHTML;


#pragma mark- *** JSON ***

/**
 *  将JSON字符串转换成相应对象
 *
 *  @return 转换后的对象字典或者数组,可为nil
 */
- (nullable id)dk_jsonValue;



@end

NS_ASSUME_NONNULL_END
