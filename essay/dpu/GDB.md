#### 一些常用命令

* <mark>c</mark>ontinue: 继续运行程序直到下一个断点（类似于VS里的F5）

* <mark>n</mark>ext: 逐过程步进，不会进入子函数（类似VS里的F10）

* <mark>s</mark>tep: 逐语句步进，会进入子函数（类似VS里的F11）

* <mark>u</mark>ntil: 运行至当前语句块结束

* <mark>f</mark>inish: 运行至函数结束并跳出，并打印函数的返回值（类似VS的Shift+F11）

* <mark>d</mark>elete: 删除所有断点

* <mark>b</mark>reak: 设置断点

#### 具体使用方法

**break**

* break function   在进入指定函数时停住

* break linenum    在指定行号停住。

* break +/-offset    在当前行号的前面或后面的offset行停住。offiset为自然数。

* break filename:linenum    在源文件filename的linenum行处停住。

* break filename:function    在源文件filename的function行处停住。

* break ... if condition    ...可以是上述的参数，condition表示条件，在条件成立时停住。比如在循环境体中，可以设置break if i=100，表示当i为100时停住程序。
