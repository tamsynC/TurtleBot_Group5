%1. Open the turtlebot camera
%2. Look for the black square -> check that the square has 4 corners and is
%   black
%3. Calculate the point of intersection between the bot and the square
%4. Generate the angular and linear velocities to navigate to the point of
%   intersection.

square_orig = rgb2gray(imread('Grey_Hollow_Square.png'));
square_read = rgb2gray(imread('Grey_Square_Image_1.jpg'));

ptssquare_orig = detectSURFFeatures(square_orig);
ptssquare_read = detectSURFFeatures(square_read);

[feature_square_orig, valid_points_square_orig] = extractFeatures(square_orig, ptssquare_orig);
[feature_square_read, vaild_points_square_read] = extractFeatures(square_read, ptssquare_read);

index_pairs = matchFeatures(feature_square_orig, feature_square_read);

matched_orig = valid_points_square_orig(index_pairs(:,1));
matched_square = vaild_points_square_read(index_pairs(:,2));

figure;
showMatchedFeatures(square_orig,square_read,matched_orig,matched_square,'montage');
