//
//  SWSCBridge.c
//  SwiftWebServerLib
//
//  Created by ellzu on 2019/7/12.
//

#include <dlfcn.h>
#include <string.h>

typedef int(*swsOnHostRequest_C)(void *request, void *response);

int handlerMaxCount = 0;
int handlerCount = 0;
void* **handlers;

int swsForwardRequestToHost(const char *path,void *request, void *response)
{
    if (handlerMaxCount == 0) {
        handlers = (void* **)malloc(sizeof(void*) * 2 * 5);
    }
    void *handler = 0;
    for(int i=0; i < handlerCount; i++) {
        const char *p = handlers[i][0];
        if (strcmp(p, path) == 0) {
            handler = handlers[i][1];
        }
    }
    handler = dlopen(path, RTLD_NOW);
    void *symbol = dlsym(handler, "swsOnHostRequest_C");
    int code = ((swsOnHostRequest_C)symbol)(request, response);
    dlclose(handler);
    return code;
}
