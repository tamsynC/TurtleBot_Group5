# TurtleBot_Group5

# Final Submission
- The final submissions folder contains MATLAB script to run our turtllebot
- An image file of objects with the textures 


# Project Description

The aim of this project is to implement a image comparision module to compare a still image of a deatiled square to a live imput feed from a USB camera mounted to a waffle TurtleBot 3. The TurtleBot is then to move towards this specified square.


# Required Software

* MATLAB
* ROS Melodic
* Ubuntu 18.04

# Dependancies

* MATLAB Add-ons
  - ROS Toolbox
  - Computer Vison Toolbox
  - Image Processing Toolbox
    
 * TURTLEBOT
  - https://github.com/ROBOTIS-GIT/turtlebot3.git
  - https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
  - https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
  - https://github.com/ROBOTIS-GIT/turtlebot3_autorace.git
  - https://github.com/ros-drivers/usb_cam.git
   

# Setup Guide
  * Start Roscore

  * Open an empty world with Turtlebot in Gazebo
    - roslaunch turtlebot3_gazebo turtlebot3_empty_world.launch

  * Network Settings
    * Check ifconfig for IPaddress
      - echo export ROS_HOSTNAME=IP_OF_VM >> ~/.bashrc
      - echo export ROS_MASTER_URI=http://IP_OF_VM:11311 >> ~/.bashrc
      - echo export ROS_IP=IP_OF_VM >> ~/.bashrc
     
  * Run MATLAB Script
    * Make sure the a MATLAB rosnode is established with proper connection
      - Check through rosnode info /matlab_restof_nodename


  * Check Rostopic List and Echo
    - Check /cmd_vel and /camera/rgb/raw_image to check if ros subscribers and publishers are working
    - rospublisher("/cmd_vel"); %MATLAB ROS Toolbox
    - rossubscriber("/camera/rgb/raw_image"); %MATLAB ROS Toolbox
      
  *  If not beginning detected by Matlab check network connection and settings


# Contributions

Ethan So (13566625) – 33%

Jet Webb	(24502825) – 33%

Tamsyn Crangle (24439287) – 33%


# Link to Demo and Presentation

* Demo
  - https://youtu.be/Mz3QDHVlBK4?si=XHbEO6X4NDKP1ZPS
    
* Presentation
  - https://www.youtube.com/watch?v=4hxqRl0YiZQ
