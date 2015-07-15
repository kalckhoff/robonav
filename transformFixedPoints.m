% translational part of tranformation, calculated by using topas

T = inv(T_ToolmarkerTip);

% initial position of marker 1,2,3,...
% 0 0 0 0
% 1 67.55844350398819 -1.776356839400251e-015 0
% 2 8.303628907712071 119.5255160233095 0
% 3 46.50299622565112 106.4354419968236 24.83611042643323

m0 = [0 0 0 1];
m1 = [67.61512005157435 -4.440892098500626e-015 -3.552713678800501e-015 1];
m2 = [46.28926097190227 109.2542780528632 0 1];
m3 = [7.798313609329889 116.4093665203644 -26.96338350303552 1];

m0 = T*m0';
m1 = T*m1';
m2 = T*m2';
m3 = T*m3';

fprintf(1, '<x>%f</x>\n<y>%f</y>\n<z>%f</z>\n',m0(1:3));
fprintf(1, '<x>%f</x>\n<y>%f</y>\n<z>%f</z>\n',m1(1:3));
fprintf(1, '<x>%f</x>\n<y>%f</y>\n<z>%f</z>\n',m2(1:3));
fprintf(1, '<x>%f</x>\n<y>%f</y>\n<z>%f</z>\n',m3(1:3));
% m1
% m2
% m3