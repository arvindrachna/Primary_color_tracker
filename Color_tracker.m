clf();
clear all;
%Read the video
vr = VideoReader('ball_left15.avi');
% Find frame resolution and number of frames in the video
Npix_resolution = [vr.Width vr.Height];
Nfrm_movie = floor(vr.Duration * vr.FrameRate);

%% Object Tracking by Optical Flow
% Initialise the path location array
    path1=zeros(Nfrm_movie,2);
% Set various thresolds  
    th=2;       % Intensity image thresold
    crth=1.5;   % Color channels ratio thresold
    cth=70;     % Color thresold      
    for k=1:Nfrm_movie
    % Getting Image
    I=read(vr,k);
    
    I_double = double(I); % covert image to double
    I_double=I_double+1; % Add 1 to avoid devide by zero
    
    % To find the Red color, formula used is R*R/(G*B)
    I_double2=I_double(:,:,1).*I_double(:,:,1) ./(I_double(:,:,2).*I_double(:,:,3)); 
    % To find the Green color, formula used is G*G/(R*B)
    % To find the Blue color, formula used is B*B/(G*R)
    
    % Select pixels with R/G > color ratio thresold
    x=I_double(:,:,1) ./I_double(:,:,2)> crth;
    
    % Select pixels with R/B > color ratio thresold
    y=I_double(:,:,1) ./I_double(:,:,3)> crth;
    

    %Select pixels with R channel grater than color thresold
    z=I_double(:,:,1)>cth;
    
    % Intensity image based of the proposed formula, color ratio thresold
    % and color thresold
    I_double=I_double2 .* x .* y .* z ;
    
    %Thresolding the intensity image
    I_double= I_double .* (I_double>=th);
    
    %Smoothening of the thresolded intensity image
    I_double = medfilt2(I_double,[3,3]);
    
    % show the final intensity image
    figure(2), imshow(I_double);
    
    %Selecting the pixels with values greater than th
    [x2,y2]=find(I_double>th);
    %Find the mean location of the object in the current frame
    xm=mean(x2);
    ym=mean(y2);
    
    %Add the current location in the path array
    path1(k,:)=[xm,ym];
    
    % Plot the object mean loaction on the original image
    figure (1), image(I);
    hold on
    plot(ym, xm, 'h', 'MarkerSize', 16, 'MarkerEdgeColor', 'y', 'MarkerFaceColor', 'y')
    hold off
    
    end
    % Plot the final object path on the last frame
    figure (3), image(I);
    hold on
    plot(path1(:,2),path1(:,1));
    hold off
    
   
    