function  res = fun( a, b )
% 内部变量，不影响外部
% 局部变量，被局部创建，退出func时被析构
    a = a+11;
    res = a+b;


end

