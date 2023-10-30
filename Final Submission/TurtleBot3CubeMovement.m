% Connect to ROS master
rosshutdown;
gazeboIp = '10.0.0.45'; %Ubuntu IPV4 Address
rosinit(gazeboIp);
% Create ROS subscribers and publishers
imgSub = rossubscriber('/camera/rgb/image_raw');
receive(imgSub,10); % Wait to receive first message
[velPub,velMsg] = rospublisher('/cmd_vel');
% Create video player for visualization
vidPlayer = vision.DeployableVideoPlayer;

while(true) 

    % Grab images from ROS
    img = readImage(imgSub.LatestMessage);

    
    %Open turtlebot camera
    square_orig = rgb2gray(imread('Detailed_Square.png'));
    square_read = rgb2gray(img);


    %Detect surface features and extract from the supplied image and camera image
    ptssquare_orig = detectSURFFeatures(square_orig);
    ptssquare_read = detectSURFFeatures(square_read);
    
    [feature_square_orig, valid_points_square_orig] = extractFeatures(square_orig, ptssquare_orig);
    [feature_square_read, valid_points_square_read] = extractFeatures(square_read, ptssquare_read);

    %Calculate the number of matched features between the two images
    index_pairs = matchFeatures(feature_square_orig, feature_square_read);
    
    matched_orig = valid_points_square_orig(index_pairs(:, 1));
    matched_square = valid_points_square_read(index_pairs(:, 2));

    %Generate a 2 column array of the X, Y positions of each point
    xy_read = matched_square.Location;
    
    %xy_orig = matched_orig.Location;
   
    
    cubeMeanX = mean(xy_read(:, 1)); %Average X position of the cube's points
    width = size(img,2); %Image input width
    centerScreen = width/2;
    
    
    tolerance = centerScreen / 10; %Center of screen tolerance
    showMatchedFeatures(square_orig, square_read, matched_orig, matched_square, 'montage'); %Display feature matching with camera
    
    accel = 0.02;
    
    if (centerScreen - tolerance < cubeMeanX) && (cubeMeanX < centerScreen + tolerance) %Checking if the cube is in the center of the screen
        w = 0;
        v = 0.2;
    elseif cubeMeanX < centerScreen - tolerance %If it's to the left of the screen turn counterclockwise (+w)
        w = w + accel;
        v = 0;
        w = min(w, 0.15);
    elseif cubeMeanX > centerScreen + tolerance %Right of the screen turn clockwise (-w)
        w = w - accel;
        v = 0;
        w = max(w, -0.15);
    else %Rotate until cube is seen
        w = 0.2;
        v = 0;
    end
         
    
    % Sending Z rotation and X linear motion to ROS
    velMsg.Linear.X = v;
    velMsg.Angular.Z = w;
    send(velPub,velMsg);
    

    %Display camera image
    step(vidPlayer,img); 
end