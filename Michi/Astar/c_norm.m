function norm = c_norm(tang, dir)

n = length(tang);
norm = zeros(1,n);

for i = 1:n
    tang_v(i,1) = cos(tang(i));
    tang_v(i,2) = sin(tang(i));
end


direction=cross([tang_v(1,:),0],[tang_v(2,:),0]);

%if dir = 1 intern direction & if dir = -1 extern direction
if direction(3) > 0
    norm_v(:,1)=-tang_v(:,2)*dir;
    norm_v(:,2)=tang_v(:,1)*dir;
else
    norm_v(:,1)=tang_v(:,2)*dir;
    norm_v(:,2)=-tang_v(:,1)*dir;
end

for i = 1:n
    norm(i)=atan2(norm_v(i,2),norm_v(i,1));
end



    

    
