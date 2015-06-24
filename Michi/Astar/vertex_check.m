function inside = vertex_check(Xr,Yr,Xo,Yo)

%NB a1 is upper in start and a2 is lower at start -> Xr cloclkweise

%in the search I rotate with positive theta

%NB Xo anticlockwise and the search goes anticlockwise 



inside=0;

a1=atan2(Yr(1)-Yr(2),Xr(1)-Xr(2));
if a1 == -pi
    a1=pi;
end
a2=atan2(Yr(3)-Yr(2),Xr(3)-Xr(2));
if a2 == -pi
    a2=pi;
end
%disp(a1*180/pi);
%disp(a2*180/pi);

for i=1:2
    if i == 1;
        a=atan2(Yo(1)-Yo(2),Xo(1)-Xo(2));
        aO1=a;
    else
        a=atan2(Yo(3)-Yo(2),Xo(3)-Xo(2));
        aO2=a;
    end
    if a == -pi
        a=pi;
    end
    %disp(a*180/pi);

    if a1 >= 0 && a2 >= 0
        if a >= 0 && (a >= a1 && a <= a2)
            inside=1;
            break
        end
    elseif a1 >= 0 && a2 < 0
        if a >= 0 && a >= a1
            inside=1;
            break
        elseif a < 0 && a <= a2
            inside=1;
            break
        end
    elseif a1 < 0 && a2 < 0
        if a < 0 && (a <= a2 && a >= a1)
            inside=1;
            break
        end
    elseif a1 < 0 && a2 >= 0
        if a >= 0 && a <= a2
            inside=1;
            break
        elseif a < 0 && a >= a1
            inside=1;
            break
        end
    end
end

% check completly inside and not just one edge
if inside == 0
    if a1 >= 0 && a2 >= 0
        if (aO1 >= a2 || aO1 < a1-pi) && (aO2 <= a1 && aO2 > a2-pi)
            inside=1;
        end
    elseif a1 >= 0 && a2 < 0
        if (aO1 >= a2 && aO1 < a1-pi) && (aO2 <= a1 && aO2 > a2+pi)
            inside=1;
        end
    elseif a1 < 0 && a2 < 0
        if (aO1 >= a2 && aO1 < a1+pi) && (aO2 <= a1 || aO2 > a2+pi)
            inside=1;
        end
    elseif a1 < 0 && a2 >= 0
        if (aO1 >= a2 && aO1 < a1+pi) && (aO2 <= a1 && aO2 > a2-pi)
            inside=1;
        end
    end
end