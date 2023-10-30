function [v, w] = trackSquare(img, params)
    % Detect and track a square in the image

    % Load the reference square image (square_orig)
    square_orig = rgb2gray(imread('Detailed_Square.png'));

    % Detect SURF features in the reference and current images
    ptssquare_orig = detectSURFFeatures(square_orig);
    ptssquare_read = detectSURFFeatures(img);

    % Extract features from detected points
    [feature_square_orig, valid_points_square_orig] = extractFeatures(square_orig, ptssquare_orig);
    [feature_square_read, valid_points_square_read] = extractFeatures(img, ptssquare_read);

    % Match features between the reference and current images
    index_pairs = matchFeatures(feature_square_orig, feature_square_read);

    % Get matched points
    matched_square_orig = valid_points_square_orig(index_pairs(:, 1));
    matched_square_read = valid_points_square_read(index_pairs(:, 2));

    % Extract coordinates of matched points in the current image
    xy_read = matched_square_read.Location;

    % Calculate the center of the square in the current image using a bounding box
    boundingBox = [min(xy_read(:,1)), min(xy_read(:,2)), max(xy_read(:,1)) - min(xy_read(:,1)), max(xy_read(:,2)) - min(xy_read(:,2)];
    centerX_read = boundingBox(1) + boundingBox(3) / 2;
    centerY_read = boundingBox(2) + boundingBox(4) / 2;

    % Implement control logic to calculate linear and angular velocities
    targetX = params.targetX; % Replace with your desired target X position
    targetY = params.targetY; % Replace with your desired target Y position

    % Calculate linear and angular errors
    linearError = sqrt((centerX_read - targetX)^2 + (centerY_read - targetY)^2);
    angularError = atan2(targetY - centerY_read, targetX - centerX_read);

    % Calculate linear and angular velocities based on errors
    v = params.kp_linear * linearError;
    w = params.kp_angular * angularError;

    % Apply velocity limits
    v = min(v, params.max_linear_velocity);
    w = min(w, params.max_angular_velocity);

    % Return control velocities
end
