function best_config = bestconfig(pos_joint)

possible_configs = {'flip up lefty','flip down lefty','noflip up lefty','noflip down lefty','flip up righty','flip down righty','noflip up righty','noflip down righty'};

for i = 1:8
    compare_vector(i) = pos_joint{2,i}(3);
end

compare = max(compare_vector); 

ind = find(compare_vector == compare);

best_config = possible_configs(ind);

end
