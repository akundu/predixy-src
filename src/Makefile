
CXX ?= g++
LVL ?= -g -O3
Opts += $(LVL)

# Binary output directory (passed from parent Makefile)
BINDIR ?= ../bin

# Platform detection
PLATFORM := $(shell uname)

# Thread support
ifeq ($(MT), false)
    Opts += -D_PREDIXY_SINGLE_THREAD_
endif

# Timer stats
ifeq ($(TS), true)
    Opts += -D_PREDIXY_TIMER_STATS_
endif

# Event system detection
EV ?= auto
ifeq ($(EV), auto)
    ifeq ($(PLATFORM), Linux)
        EV = epoll
        Opts += -D_PREDIXY_BACKTRACE_
        LDLIBCPP = -static-libstdc++
    else ifeq ($(PLATFORM), Darwin)
        EV = kqueue
        Opts += -D_PREDIXY_BACKTRACE_
        LDLIBCPP = -static-libstdc++
    else ifeq ($(PLATFORM), FreeBSD)
        EV = kqueue
        Opts += -D_PREDIXY_BACKTRACE_
        LDFLAGS += $(shell pkg info -Dx gcc|grep 'rpath') -lexecinfo
    else ifeq ($(PLATFORM), OpenBSD)
        EV = kqueue
    else
        EV = poll
    endif
endif

# Event multiplexor selection
ifeq ($(EV), epoll)
    multiplexor = EpollMultiplexor
    Opts += -D_EPOLL_
else ifeq ($(EV), poll)
    multiplexor = PollMultiplexor
    Opts += -D_POLL_
else ifeq ($(EV), kqueue)
    multiplexor = KqueueMultiplexor
    Opts += -D_KQUEUE_
else
$(error Unknown event:$(EV))
endif

# Compiler flags
CFLAGS = -std=c++11 -Wall -w $(Opts)
INCFLAGS =
LDFLAGS += $(LDLIBCPP) -rdynamic -lpthread

# Target and object files
target = $(BINDIR)/predixy
objs = Crc16.o HashFunc.o Timer.o Logger.o LogFileSink.o \
       Alloc.o Socket.o ListenSocket.o AcceptSocket.o \
       ConnectSocket.o $(multiplexor).o Subscribe.o \
       Connection.o AcceptConnection.o EchoAcceptConnection.o ConnectConnection.o \
       Buffer.o Command.o Distribution.o Enums.o Reply.o \
       ConfParser.o Conf.o Auth.o DC.o LatencyMonitor.o \
       RequestParser.o Request.o ResponseParser.o Response.o \
       Server.o ServerGroup.o ServerPool.o ClusterNodesParser.o \
       ClusterServerPool.o StandaloneServerPool.o EchoListenSocket.o \
       ConnectConnectionPool.o Handler.o Proxy.o main.o

# Build rules
.PHONY: all debug clean

all: $(target)

$(target): $(objs)
	$(CXX) $(CFLAGS) -o $@ $^ $(LDFLAGS)

debug:
	@$(MAKE) LVL=-g

clean:
	@rm -rf $(objs) $(target)
	@echo "Clean complete."

%.o: %.cpp
	$(CXX) $(CFLAGS) -c $^ $(INCFLAGS)
