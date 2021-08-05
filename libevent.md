## libevent网络库学习

基于 Reactor 模式的网络库

事件循环：
    struct event_base *event_base_new(void);           // 创建事件循环
    void event_base_free(struct event_base *base);     // 销毁事件循环
    int event_base_dispatch(struct event_base *base);  // 运行事件循环

创建事件：
    Libevent 使用event结构体来代表事件，可以使用event_new()创建一个事件：
    struct event *event_new(struct event_base *base, // 事件循环
                        evutil_socket_t fd,      // 文件描述符
                        short what,              // 事件类型
                        event_callback_fn cb,    // 回调函数
                        void *arg);              // 传递给回调函数的参数
加入事件循环：
    int event_add(struct event *ev,             // 事件
              const struct timeval *tv);    // 超时时间

http://senlinzhan.github.io/2017/08/12/libevent/


reactor模型：
    
### libevent获得的http请求体数据的指针，得先把数据复制处理，不能直接赋给string
