/*
 * predixy - A high performance and full features proxy for redis.
 * Copyright (C) 2017 Joyield, Inc. <joyield.com@gmail.com>
 * All rights reserved.
 */

#ifndef _PREDIXY_ECHO_LISTEN_SOCKET_H_
#define _PREDIXY_ECHO_LISTEN_SOCKET_H_

#include "ListenSocket.h"

#define ECHO_LISTEN_SOCKET_TYPE "echo"
class EchoListenSocket : public ListenSocket
{
public:
    EchoListenSocket(const char* addr);
    ~EchoListenSocket();
};

#endif 