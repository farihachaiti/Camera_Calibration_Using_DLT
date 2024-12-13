function mainfunction
  clc
  
  #Object points
  printf("Object points\n")
  
  Aprimex1 = 80.01;
  Aprimey1 = 0;
  Aprimez1 = 104.6;
  Aprimex2 = 76.2;
  Aprimey2 = 0;
  Aprimez2 = 79.2;
  Aprimex3 = 0;
  Aprimey3 = 101.6;
  Aprimez3 = 154.9;
  Aprimex4 = 0;
  Aprimey4 = 104.1;
  Aprimez4 = 88.9;
  Aprimex5 = 81.3;
  Aprimey5 = 81.3;
  Aprimez5 = 0;
  Aprimex6 = 132.1;
  Aprimey6 = 86.4;
  Aprimez6 = 0;
  
  #reading images 
  printf("Reading image\n")
  
  img = imread('a.jpg');  
  
  #B = imread("b.jpg"); 
  
  #C = imread("c.jpg");
  
  #Showing image and picking 6 image points
  printf("Showing image and picking 6 image points\n")
  
 

 [x1,x2,x3,x4,x5,x6,y1,y2,y3,y4,y5,y6]=take_points(img)
 
 
 
 #[Aprimex1,Aprimex2,Aprimex3,Aprimex4,Aprimey1,Aprimey2,Aprimey3,Aprimey4]=take_points(B)
 
 
   #Measuring points
  printf("Measuring points\n")
 
  [Aprimex1y1z1, Aprimex2y2z2, Aprimex3y3z3, Aprimex4y4z4, Aprimex5y5z5,Aprimex6y6z6,T1] = measure_object_points(Aprimex1,Aprimey1,Aprimez1,Aprimex2,Aprimey2,Aprimez2,Aprimex3,Aprimey3,Aprimez3,Aprimex4,Aprimey4,Aprimez4,Aprimex5,Aprimey5,Aprimez5,Aprimex6,Aprimey6,Aprimez6)
  [Ax1y1, Ax2y2, Ax3y3, Ax4y4,Ax5y5,Ax6y6,T2] = measure_2d_points(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6)


  #Condittioned Coordinates
  printf("Conditioned Coordinatesn")
 
 A1 = design_matrix(Ax1y1,Aprimex1y1z1)
 A2 = design_matrix(Ax2y2,Aprimex2y2z2)
 A3 = design_matrix(Ax3y3,Aprimex3y3z3)
 A4 = design_matrix(Ax4y4,Aprimex4y4z4)
 A5 = design_matrix(Ax5y5,Aprimex5y5z5)
 A6 = design_matrix(Ax4y4,Aprimex6y6z6)
 
   #Calculating Projection Matrix
  printf("Calculating Projection Matrix\n")
 
 p = calculate_projection_matrix(A1,A2,A3,A4,A5,A6,T1,T2);
 
    #Interpretation of Projection Matrix
  printf("Interpretation of Projection Matrix\n")
 
 [K,R,C] = p_interpretation(p)
 
   if(any(K(:,1)<0))
    K(:,1) = K(:,1)*(-1)
    R(1,:) = R(1,:)*(-1)
   endif
   if(any(K(:,2)<0))
    K(:,2) = K(:,2)*(-1)
    R(2,:) = R(2,:)*(-1)
   endif
  if(any(K(:,3)<0))
    K(:,3) = K(:,3)*(-1)
    R(3,:) = R(3,:)*(-1)
  endif
  
  
 C= C/C(4,1)
 ax = K(1,1)
 ay = K(2,2)
 s = K(1,2)
 x0 = K(1,3)
 y0 = K(2,3)
 aspect_ratio = ay/ax
 omega = atand(R(3,2)/R(3,3))
 phi = -asind(R(3,1))
 kappa = atand(R(2,1)/R(1,1))
 
 endfunction

  function [x1,x2,x3,x4,x5,x6,y1,y2,y3,y4,y5,y6]=take_points(A)
    imshow(A)
    
 [xinput,yinput,mouse_button] = ginput(1)
 x1 = xinput
 y1 = yinput
 [xinput,yinput,mouse_button] = ginput(1)
 x2 = xinput
 y2 = yinput
 [xinput,yinput,mouse_button] = ginput(1)
 x3 = xinput
 y3 = yinput
 [xinput,yinput,mouse_button] = ginput(1)
 x4 = xinput
 y4 = yinput 
  [xinput,yinput,mouse_button] = ginput(1)
 x5 = xinput
 y5 = yinput 
  [xinput,yinput,mouse_button] = ginput(1)
 x6 = xinput
 y6 = yinput 
 close(gcf)
    
  endfunction
  
  function [Y1,Y2,Y3,Y4,Y5,Y6,T]=measure_2d_points(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6)
  
   #Conditioning: Translation
  printf("Conditioning: Translation\n")
  
  
  X1Y1 = [x1; y1; 1]
  X2Y2 = [x2; y2; 1]
  X3Y3 = [x3; y3; 1]
  X4Y4 = [x4; y4; 1]
  X5Y5 = [x5; y5; 1]
  X6Y6 = [x6; y6; 1]
  XYmat = [abs(X1Y1) abs(X2Y2) abs(X3Y3) abs(X4Y4) abs(X5Y5) abs(X6Y6)]
  
  t = mean(XYmat,2)
  t(1,1)
  t(2,1)
  t(3,1)
  
   #Conditioning: Scalling
  printf("Conditioning: Scalling\n")
  
 X1final = x1 - t(1,1)
 Y1final = y1 - t(2,1)
 X2final = x2 - t(1,1)
 Y2final = y2 - t(2,1)
 X3final = x3 - t(1,1)
 Y3final = y3 - t(2,1)
 X4final = x4 - t(1,1)
 Y4final = y4 - t(2,1)
 X5final = x5 - t(1,1)
 Y5final = y5 - t(2,1)
 X6final = x6 - t(1,1)
 Y6final = y6 - t(2,1)
  
 X1Y1final = [X1final; Y1final; 1]
 X2Y2final = [X2final; Y2final; 1]
 X3Y3final = [X3final; Y3final; 1]
 X4Y4final = [X4final; Y4final; 1]
 X5Y5final = [X5final; Y5final; 1]
 X6Y6final = [X6final; Y6final; 1]
 
 XYmat2 = [abs(X1Y1final) abs(X2Y2final) abs(X3Y3final) abs(X4Y4final) abs(X5Y5final) abs(X6Y6final)]
 
 s = mean(XYmat2,2)
 s(1,1)
 s(2,1)
 s(3,1)
 
  #Coordinate Transformation
  printf("Coordinate Transformation\n")
 
 
 T = [1/s(1,1) 0 0; 0 1/s(2,1) 0; 0 0 1]*[ 1 0 -t(1,1); 0 1 -t(2,1); 0 0 1] 
 
  #Conditioned Coordinates
  printf("Conditioned Coordinates\n")
 
 
 Y1 = T*X1Y1
 Y2 = T*X2Y2
 Y3 = T*X3Y3
 Y4 = T*X4Y4
 Y5 = T*X5Y5
 Y6 = T*X6Y6
 
endfunction

function [Y1,Y2,Y3,Y4,Y5,Y6,T]=measure_object_points(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,x5,y5,z5,x6,y6,z6)
  
   #Conditioning: Translation
  printf("Conditioning: Translation\n")
  
  
  X1Y1Z1 = [x1; y1; z1; 1]
  X2Y2Z2 = [x2; y2; z2; 1]
  X3Y3Z3 = [x3; y3; z3; 1]
  X4Y4Z4 = [x4; y4; z4; 1]
  X5Y5Z5 = [x5; y5; z5; 1]
  X6Y6Z6 = [x6; y6; z6; 1]
  XYZmat = [abs(X1Y1Z1) abs(X2Y2Z2) abs(X3Y3Z3) abs(X4Y4Z4) abs(X5Y5Z5) abs(X6Y6Z6)]
  
   t = mean(XYZmat,2)
  t(1,1)
  t(2,1)
  t(3,1)
  t(4,1)
  
  
   #Conditioning: Scalling
  printf("Conditioning: Scalling\n")
  
 X1final = x1 - t(1,1)
 Y1final = y1 - t(2,1)
 Z1final = z1 - t(3,1)
 X2final = x2 - t(1,1)
 Y2final = y2 - t(2,1)
 Z2final = z2 - t(3,1)
 X3final = x3 - t(1,1)
 Y3final = y3 - t(2,1)
 Z3final = z3 - t(3,1)
 X4final = x4 - t(1,1)
 Y4final = y4 - t(2,1)
 Z4final = z4 - t(3,1)
 X5final = x5 - t(1,1)
 Y5final = y5 - t(2,1)
 Z5final = z5 - t(3,1)
 X6final = x6 - t(1,1)
 Y6final = y6 - t(2,1)
 Z6final = z6 - t(3,1)
  
 X1Y1Z1final = [X1final; Y1final; Z1final; 1]
 X2Y2Z2final = [X2final; Y2final; Z2final; 1]
 X3Y3Z3final = [X3final; Y3final; Z3final; 1]
 X4Y4Z4final = [X4final; Y4final; Z4final; 1]
 X5Y5Z5final = [X5final; Y5final; Z5final; 1]
 X6Y6Z6final = [X6final; Y6final; Z6final; 1]
 
 XYZmat2 = [abs(X1Y1Z1final) abs(X2Y2Z2final) abs(X3Y3Z3final) abs(X4Y4Z4final) abs(X5Y5Z5final) abs(X6Y6Z6final)]
 
 s = mean(XYZmat2,2)
 s(1,1)
 s(2,1)
 s(3,1)
 s(4,1)
 
  #Coordinate Transformation
  printf("Coordinate Transformation\n")
 
 
 T = [1/s(1,1) 0 0 0; 0 1/s(2,1) 0 0; 0 0 1/s(3,1) 0; 0 0 0 1]*[ 1 0 0 -t(1,1); 0 1 0 -t(2,1); 0 0 1 -t(3,1); 0 0 0 1] 
 
  #Conditioned Coordinates
  printf("Conditioned Coordinates\n")
 
 
 Y1 = T*X1Y1Z1
 Y2 = T*X2Y2Z2
 Y3 = T*X3Y3Z3
 Y4 = T*X4Y4Z4
 Y5 = T*X5Y5Z5
 Y6 = T*X6Y6Z6
 
endfunction

function y=design_matrix(xy,XYZ)
   y = [-xy(3,1)*XYZ(1,1)  -xy(3,1)*XYZ(2,1) -xy(3,1)*XYZ(3,1) -xy(3,1)*XYZ(4,1) 0 0 0 0 xy(1,1)*XYZ(1,1) xy(1,1)*XYZ(2,1) xy(1,1)*XYZ(3,1) xy(1,1)*XYZ(4,1); 0 0 0 0 -xy(3,1)*XYZ(1,1) -xy(3,1)*XYZ(2,1) -xy(3,1)*XYZ(3,1) -xy(3,1)*XYZ(4,1) xy(2,1)*XYZ(1,1) xy(2,1)*XYZ(2,1) xy(2,1)*XYZ(3,1) xy(2,1)*XYZ(4,1)]
  
endfunction

 function p=calculate_projection_matrix(A1, A2, A3, A4, A5,A6,T1,T2)
    
 
  #Design Matrix A1
  printf("Design Matrix A1\n")
 
 Afinal_design_matrix = [A1; A2; A3; A4; A5; A6; 0 0 0 0 0 0 0 0 0 0 0 0]
 
  #Singular Value Decompisition
  printf("Singular Value Decompisition\n")
 
 [U,D,V] = svd(Afinal_design_matrix)
 #p = min(svd(design_matrix))
 p1 = [V(:,end)]
 
  #Reshaping to get the Homography Matrix
  printf("Reshaping to get the projection Matrix\n")
 
 p2 = reshape(p1,4,3)'

   #Reverse Conditioning
  printf("Reverse Conditioning\n")
 
 p = inverse(T2)*p2*T1
 
endfunction

function [K,R2,C]=p_interpretation(p)
  m = p(3, 1:3)
  
  m3 = norm(m)
  
  M = p(:,1:3)
  
  if(det(M)>0)
    lambda = 1/m3
  else
    lambda = -1/m3
  endif
  
  p2 = p*lambda
  M2 = p2(:,1:3)
  M3 = inverse(M2)
  [Q,R] = qr(M3)
  K = inverse(R)
  R2 = inverse(Q)

  
  [U,D,V] = svd(p)
   C = [V(:,end)]
  
  
  endfunction