// 颜色
#define AppColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define AppAlphaColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** *  十六进制颜色 */
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBValue_alpha(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define UIColorFromHexadecimalRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/** *  主色调 */
#define ImportantColor UIColorFromRGBA(0, 107, 255,1)
//UIColorFromRGBValue(0x4876FF)

#define AppBaseTextColor1 (UIColorHex(0x666666))//灰色

#define AppBaseTextColor2 (UIColorHex(0x999999))

#define AppBaseTextColor3 ( AppColor(0, 107, 255))//蓝色 主题色

#define AppBaseTextColor4 (UIColorHex(0x7d8da2))

#define AppBaseLineColor (UIColorHex(0xe5e5e5))


#define AppBaseBackgroundColor2 (UIColorFromHexadecimalRGB(0xF9F8FE))

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"333333"]
//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"EBEBEB"]

//验证码字体颜色
#define CFontColor3 [UIColor colorWithHexString:@"264C90"] 



