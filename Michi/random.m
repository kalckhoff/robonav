function randompose = random()

r = -1 + (1+1)*rand(3,3);
randompose = [r,rand(3,1)*5000;0,0,0,1];

end