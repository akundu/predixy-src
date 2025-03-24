/*
 * predixy - A high performance and full features proxy for redis.
 * Copyright (C) 2017 Joyield, Inc. <joyield.com@gmail.com>
 * All rights reserved.
 */

#ifndef _PREDIXY_ECHO_ACCEPT_CONNECTION_H_
#define _PREDIXY_ECHO_ACCEPT_CONNECTION_H_

#include "AcceptConnection.h"

class EchoAcceptConnection : public AcceptConnection
{
public:
    typedef EchoAcceptConnection Value;
    typedef Alloc<EchoAcceptConnection, Const::AcceptConnectionAllocCacheSize> Allocator;

    EchoAcceptConnection(int fd, sockaddr* addr, socklen_t len);
    virtual ~EchoAcceptConnection() {}

protected:
    virtual void parse(Handler* h, Buffer* buf, int pos) override;
private:
    void echo(Handler* h, Buffer* buf);
};

typedef EchoAcceptConnection::Allocator EchoAcceptConnectionAlloc;

#endif
