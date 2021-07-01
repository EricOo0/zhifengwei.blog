# c++ 标准库    侯捷 C++标准库与泛型编程
	GP泛型编程（模板）
	头文件没有.h后缀了
	命名空间（namespace）：封装，防止与其他人写的程序起冲突
	学习网页：CPLUSPLUS.com ;CppReference.com;gcc.gnu.org
	《STL 源码解析》
第一讲：STL怎么用
	1、6大部件component
		容器：帮助我们管理内存
		分配器：用来支持容器的内存使用，帮助容器分配内存
		算法：操作容器的数据
		迭代器(iterators)：泛化的指针，连接容器和算法
		适配器（adapter）：转换
		仿函数
		
	容器：
		前闭后开 begin()-第一个元素的位置;end()-最后一个元素的下一个位置
		每个容器都有专属于它的迭代器：container<T>::iterator 
		C++11 提供了新的for loop
		auto关键字，自动推导
		
		容器分类：
			序列式容器：
			Array：固定长度，没办法扩充;array.data()--返回第一个元素的地址
			Vector：可动态扩充，（分配器负责动态增长）
				每当空间不够的时候，vector会重新申请一个两倍的空间，将原来的数据复过去
				size()元素的容量
				capacity（）可容纳的元素大小 >=size()
				::前是空白代表全局命名空间
			Deque：双向队列，双向扩充
				分段连续--实现动态扩充
				涵盖了stack，queue---容器的adpter，不提供迭代器 
			List：双向链表
				有一个maximum_size
				容器内也有一个sort函数
			forward-List:单向链表
			
			关联式容器（适合用于查找，key-value）：
			set：底层都是红黑树（高度平衡）;不分keyvalue;
				有自己的find
			map：底层都是红黑树;（key-value）
			multiset、multiset：key可以重复
				
			不定序容器：
			unordered_map:底层是vector+链表
		
第二讲：源码分析
	C++标准库并不是按OOP的思想做的
	面向对象：将数据和操作数据的方法封装在类里
	模板编程GP：将数据和方法分开来
	
	list的迭代器不是随机接入迭代器，list内存不是联系的，不可以用全局的sort进行排序，它需要有自己的sort
	操作符重载：会作用在左边对象，右边作为传参
	类模板template <typename T>类模板template	函数模板template <classname T> 
			成员模板
	类模板泛化；也有特化的例子：template<> struct _type_traits<int>
	struct和class是一样的地位，但有一点差别
	局部特化：部分参数特化，部分泛化template <bool,class ALLOC=alloc>
	new的底层还是malloc；malloc给你的内存实际上比你申请的大；他会自己附加一下辅助信息
	分配器源码allocator：
		不建议直接用它
		<xmemeory>头文件下
			关键函数 
			VC下
			alloate：调用operator new->调用 malloc
			deallocate：调用operator delete-> 调用free
			使用会带来很多额外的开销，每次申请一点小内存，会有较大的overhead
	容器源码：
		list：
			成员：node指针里面包含前向指针和后向指针和数据
			iterator得是一个类/结构，list<Foo>::iterator ite;生成了一个对象
			容器主要分两部分：一堆typedef 一堆操作符重载
			环状：为了实现前闭后开
			iterator：iterator_traits萃取机：算法使用iterator时需要获取iteraor地一些信息，如果算法得到地是指针，不可以直接获取，因此设计了一个中间层traits来帮助获取
			
			
		vector:
			实现类似与数组；但是内存用完后可以动态扩充（不是原地扩充；两倍成长）
			类里有三个变量：start;end；en_of_storage;有的地方是1.5倍增长
			vector的大小是12（三个指针start，end，end_of_storage）
			有大量构造和析构--损耗大
			迭代器 
		array：
			实际上就是包装了一个数组，没有构造和析构函数
		deque：
			分段连续；每段叫一个buffer
			内部有个vector：map用来存储各个buffer的指针
			内部有两个迭代器：start（指向第一个buffer），finish；（指向最后一个buffer）
			迭代器有四个元素：cur（迭代器当前指向元素的地址），first（当前buffer的起始地址），last（当前buffer的最后一个位置），node（指向控制中心map，可以用来跳到下一个buffer）
			如何模拟连续空间：
				重载了[]操作符，可以通过下标访问
				重载操作符++;--;利用控制中心map跳到其他buffer，模拟连续空间
		queue：(适配器)底层就是一个deque，封锁了一些功能来实现queue
		stack: (适配器)底层也是deque
			stack和queue不可以遍历；也可以用list或vector（queue不太行）做底层
		
		rb_tree:高度平衡的二叉搜索树，有利于搜索和插入；红黑树提供遍历和iterator
				begin()：指向中序遍历的第一个元素，end():指向中序遍历的最后一个元素
		set/multiset: 以rb_tree为基础--元素自动排序特性，也提供iterator进行遍历，但不能通过iterator修改
					multi_set用的是insert_equal，key可以重复;
					set 的迭代器是const类型所以不可以改
		map/multimap:以rb_tree为底层，map可以用[]来插入和取值，如果不存在这个key，则会创建一个key和默认value
					lower_bound(k)//大于等于k
					upper_bound(k)//大于k
		hashtable：比红黑树简单；通过一个散列函数（简单的方法是除以容器大小取余），将对象放到对应下标（节省容器空间），如果发生碰撞
					用链表把他们串一起
					重哈希：链表太长的时候（元素数量大于bucket长度时），把bucket vector增长（即换2倍长的vector），重新hash，
		unordered容器基于hashtable
			篮子buket一定大于元素
			
第三讲：算法
	容器等其他组件是类模板；算法是函数模板--算法能看到的只是迭代器，不是容器
	iterator类型：random_access_iterator;bidirectional_iterator（list,map）;forward_iterator(forward-List，hashtable);input_iterator;out_put_iterator
	算法通过萃取机(iterator_traits来获得容器相关信息)
	常用算法：
		accumulate(first,last,init,function)
		for_each()		
		replace()
		count()
		find()
		sort()
	仿函数functor：
		为算法服务，
		一个class，要重载（）; 实例化后类似于函数指针
		template<class T>
		struct A{
			T operator()(a,b){
			}
		}
		为什么要把函数写成class：为了给算法使用
		functor都要继承自binary_function/unary_function（根据操作数数量）
		因为当你的仿函数要被适配时，可能会被问到binary_function中地typedef--用于指明参数和返回类型
	adptor适配器：
		改造仿函数或容器或迭代器
		容器适配器：stack；queue--内含（不是继承）了一个容器，然后进行改造
		函数适配器：bind2nd(functor，x);not1；bind绑定参数 
			适配器需要知道反函数对象的各种参数类型，所以仿函数需要继承上述父类
			typename关键字:Typename关键字告诉了编译器把一个特殊的名字解释成一个类型，在下列情况下必须对一个name使用typename关键字：
			
		
	