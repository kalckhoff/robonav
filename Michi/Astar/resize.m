function Q = resize(W, step)

iQ=1;
jQ=1;
[i_max, j_max]=size(W);
Q=zeros(round(i_max/step),round(j_max/step));

for i=1:step:i_max-step
    for j=1:step:j_max-step
        temp = find(W(i:i+step, j:j+step)==0);
        if temp
            % obstacle
        else
            % no obstacles
            Q(iQ, jQ)=255;
        end
        jQ = jQ+1;
        clear temp;
    end
    iQ = iQ+1;
    jQ = 1;
end