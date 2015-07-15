function t_window = getWindow()

jTcpObj = connectCamera();

pause

LoadLocator(jTcpObj, 'stylus');

for i=1:5
    [T,timestamp] = GetLocatorTransformMatrix(jTcpObj, 'stylus');
    poses_window{i} = [T]; 
    t_window{i} = poses_window{i}(1:3,4);
    pause;
end



end