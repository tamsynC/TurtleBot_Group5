%% Object Detection Example: Gazebo
% Copyright 2017 The MathWorks, Inc.
%% SETUP

% Connect to ROS master
rosshutdown;
gazeboIp = '10.0.0.45';
rosinit(gazeboIp);
% Create ROS subscribers and publishers
imgSub = rossubscriber('/camera/rgb/image_raw');
receive(imgSub,10); % Wait to receive first message
[velPub,velMsg] = rospublisher('/cmd_vel');
% Create video player for visualization
vidPlayer = vision.DeployableVideoPlayer;
% Load control parameters
params = controlParamsGazebo;
%% LOOP
while(1) 
    %% SENSE
    % Grab images
    img = readImage(imgSub.LatestMessage);
    % Load the reference image (square_orig) and the current image (square_read)
square_orig = rgb2gray(imread('Detailed_Square.png'));
square_read = rgb2gray(img);

% Detect SURF features in both images
ptssquare_orig = detectSURFFeatures(square_orig);
ptssquare_read = detectSURFFeatures(square_read);

% Extract features from detected points
[feature_square_orig, valid_points_square_orig] = extractFeatures(square_orig, ptssquare_orig);
[feature_square_read, valid_points_square_read] = extractFeatures(square_read, ptssquare_read);

% Match features between the reference and current images
index_pairs = matchFeatures(feature_square_orig, feature_square_read);

% Get matched points
matched_orig = valid_points_square_orig(index_pairs(:, 1));
matched_square = valid_points_square_read(index_pairs(:, 2));

% Extract coordinates of matched points
xy_orig = matched_orig.Location;
xy_read = matched_square.Location;

a= mean(xy_read(:, 1))
width = size(img,2);
aim = width/2;

tolerance = aim/10;


if  (aim-tolerance < a) && (a < aim+tolerance)
    w = 0;
    v = 0.2;
elseif a < aim-tolerance
    w = w + 0.01;
    v = 0;
elseif a > aim+tolerance
    w = w - 0.01;
    v = 0;
else
    w = 0.2;
    v = 0;
end 

% Now you have the (x, y) coordinates of the matched features in both images
% You can use these coordinates for further tracking or analysis

        
    %% PROCESS
    % Object detection algorithm
    resizeScale = 0.5;
    % [centerX,centerY,circleSize] = detectCircle(img,resizeScale);
    % % pause(0.5);
    % % Object tracking algorithm
    % [v,w] = trackCircle(a,circleSize,size(img,2),params);
    
    %% CONTROL
    % Package ROS message and send to the robot
    velMsg.Linear.X = v;
    % pause(0.5)
    velMsg.Angular.Z = w;
    send(velPub,velMsg);
    
    %% VISUALIZE
    % Annotate image and update the video player
    % img = insertShape(img,'Circle',[centerX centerY circleSize/2],'LineWidth',2);
    step(vidPlayer,img);
        
end