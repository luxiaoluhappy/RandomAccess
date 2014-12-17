function len = lianxu1(a,pos,flag)
%a = [0 ones(1,5)  0 0 1 0 ones(1,10) 0] ;
len=1;
while pos>1 & a(pos-1)==flag
        pos=pos-1;
        len=len+1;
end

end