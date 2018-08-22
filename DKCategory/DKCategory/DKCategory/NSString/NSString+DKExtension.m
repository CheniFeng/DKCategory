//
//  NSString+DKExtension.m
//  DKCategory
//
//  Created by 雪凌 on 2018/8/19.
//  Copyright © 2018年 雪凌. All rights reserved.
//

#import "NSString+DKExtension.h"

@implementation NSString (DKExtension)

#pragma mark- *** Common ***

- (NSInteger)dk_wordsCount {
    NSUInteger length = self.length;
    NSInteger l = 0, a = 0, b = 0;
    for (NSInteger i = 0; i < length; i++){
        unichar c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        }else if (isascii(c)) {
            a++;
        }else {
            l++;
        }
    }
    if (a == 0 && l == 0) { return 0; }
    return l + (NSInteger)ceilf((float)(a + b) / 2.0);
}

#pragma mark- *** Contains ***

- (BOOL)dk_containChinese {
    NSUInteger length = self.length;
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)dk_containBlank {
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)dk_containsCharacterSet:(NSCharacterSet *)set {
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    }else {
        return YES;
    }
}

- (BOOL)dk_containsString:(NSString *)string {
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)dk_containEmoji {
    __block BOOL returnValue = NO;
    NSUInteger length = self.length;
    [self enumerateSubstringsInRange:NSMakeRange(0, length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange,
                                       NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              }else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              }else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d
                                             || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c
                                             || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

#pragma mark- *** Trims ***

- (NSString *)dk_trimmingWhitespace {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)dk_trimmingWhitespaceAndNewlines {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)dk_trimmingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>"
                                           withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, self.length)];
}

- (NSString *)dk_trimmingScriptsAndHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error = nil;
    NSString *pattern = @"<script[^>]*>[\\w\\W]*</script>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];
    NSArray *matches = [regex matchesInString:mString
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, mString.length)];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range
                               withString:@""];
    }
    return [mString dk_trimmingHTML];
}

#pragma mark- *** JSON ***

- (nullable id)dk_jsonValue {
    NSError *error = nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) {
#ifdef DEBUG
        NSLog(@"Fail To Get JSON Value From String: %@, error: %@", self, error);
#endif
    }
    return result;
}


@end
