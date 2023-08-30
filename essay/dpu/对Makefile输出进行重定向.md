### 对Makefile输出进行重定向

1. 想要把make输出的全部内容输出到某个文件中
   
   使用`make xxx > build_output.txt`，此时没有改变stderr=2的输出方式，错误信息还是在屏幕。

2. 需要将make输出中的错误（及警告）信息输出到文件中
   
   使用`make xxx 2> build_output.txt`，此时没有改变stdout=1的输出方式，正常信息会输出到屏幕上。

3. 想要将正常信息和错误信息输出到不同的文件中
   
   使用`make xxx 1> build_output_normal.txt 2> build_output_error.txt`，正常信息和错误信息都输出到对应文件。

4. 将正常信息和错误信息输出到同一个文件中
   
   使用`make xxx > build_output_all.txt 2>&1`，其中2>&1表示错误信息输出到&1中，而&1指的是前面那个文件：build_output_all.txt，上面的1，2等数字，后面紧跟着>，中间不能有空格。
