//
//  utils.h
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/07/30.
//

#include <stdio.h>
#import <Foundation/Foundation.h>


int clearUICache(void);
int themePasscodes(void);
int ResSet16(NSInteger height, NSInteger width);
int removeSMSCache(void);
int VarMobileWriteTest(void);
int VarMobileRemoveTest(void);
int setSuperviseMode(bool enable);
int removeKeyboardCache(void);
int regionChanger(NSString *country_value, NSString *region_value);
void DynamicCOW(int subtype);
int whitelist(void);
uint64_t createFolderAndRedirect1(char *path);
uint64_t createFolderAndRedirect3(char *path);
uint64_t UnRedirectAndRemoveFolder1(uint64_t orig_to_v_data);
uint64_t UnRedirectAndRemoveFolder3(uint64_t orig_to_v_data);
uint64_t overwriteFileVarHelp(char* to, char* from);
