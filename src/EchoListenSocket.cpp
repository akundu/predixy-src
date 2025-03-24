/*
 * predixy - A high performance and full features proxy for redis.
 * Copyright (C) 2017 Joyield, Inc. <joyield.com@gmail.com>
 * All rights reserved.
 */

#include "EchoListenSocket.h"
#include <string.h>

EchoListenSocket::EchoListenSocket(const char* addr):
    ListenSocket(addr, SOCK_STREAM, 0)
{
    strncpy(type, ECHO_LISTEN_SOCKET_TYPE, sizeof(type));
}

EchoListenSocket::~EchoListenSocket()
{
} 