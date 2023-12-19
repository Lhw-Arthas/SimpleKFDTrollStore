//
//  fun.h
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/07/25.
//

#ifndef fun_h
#define fun_h

#include <stdbool.h>
#include <stdio.h>

void do_fun(char** enabledTweaks, int numTweaks, int res_y, int res_x, int subtype);
void backboard_respring(void);
void respring(void);
void DynamicKFD(int subtype);
void supervised(bool is);
void funcInit();
uint64_t createFolderAndRedirect2(char* path);
uint64_t createFolderAndRedirect4(char* path);
uint64_t UnRedirectAndRemoveFolder2(uint64_t orig_to_v_data);
uint64_t UnRedirectAndRemoveFolder4(uint64_t orig_to_v_data);
uint64_t overwriteFileVar(char* to, char* from);
#endif /* fun_h */
