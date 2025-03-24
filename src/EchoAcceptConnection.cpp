/*
 * predixy - A high performance and full features proxy for redis.
 * Copyright (C) 2017 Joyield, Inc. <joyield.com@gmail.com>
 * All rights reserved.
 */

#include "EchoAcceptConnection.h"
#include "Handler.h"

EchoAcceptConnection::EchoAcceptConnection(int fd, sockaddr* addr, socklen_t len):
    AcceptConnection(fd, addr, len)
{
    setEchoConnection(true);
}

void EchoAcceptConnection::parse(Handler* h, Buffer* buf, int pos)
{
    logError("debug parse");
    FuncCallTimer();
    echo(h, buf);
}

void EchoAcceptConnection::echo(Handler* h, Buffer* buf)
{
    FuncCallTimer();
    logError("Echo buffer: %d, %.*s", buf->length(), buf->length(), buf->data());
    if (buf->length() > 0) {
        // Create a response to echo back the data
        ResponsePtr res = ResponseAlloc::create();
        logDebug("Response object address: %p", (void*)res.operator->());
        res->setStr(buf->data(), buf->length(), false);
        
        // Create a request to attach the response to
        Request* req = RequestAlloc::create(this);
        req->setResponse(res);
        req->setType(Command::EchoText);  // Use the new EchoText command type
        mRequests.push_back(req);
        
        // Handle the request to trigger write
        h->handleRequest(req);
        
        // Clear the buffer after queuing the response
        req->setDelivered();  // Mark the request as delivered
        buf->reset();
    }
} 