clc;  % clear command window
clear all;   % clear workspace
close all;  % closes previous fig. windows
sai = 'U15974415 forestfires.xlsx';
z = xlsread(sai);
FFMC=z(:,5);
DMC=z(:,6);
DC=z(:,7);
ISI=z(:,8);
temp=z(:,9);
RH=z(:,10);
wind=z(:,11);
rain=z(:,12);
area1=z(:,13);

R12 = FFMC( 2 : 400).*DMC( 2 : 400)/2;
R11 = FFMC( 2 : 400).*FFMC( 2 : 400)/2;
R13 = FFMC( 2 : 400).*DC( 2 : 400)/2;
R21 = R12;
R22 = DMC( 2 : 400).*DMC( 2 : 400)/2;
R23 = DMC( 2 : 400).*DC( 2 : 400)/2;
R31 = R13;
R32 = R23;
R33 = DC( 2 : 400).*DC( 2 : 400)/2;

T12 = ISI( 2 : 400).*temp( 2 : 400)/2;
T11 = ISI( 2 : 400).*ISI( 2 : 400)/2;
T13 = ISI( 2 : 400).*wind( 2 : 400)/2;
T21 = T12;
T22 = temp( 2 : 400).*temp( 2 : 400)/2;
T23 = temp( 2 : 400).*wind( 2 : 400)/2;
T31 = T13;
T32 = T23;
T33 = wind( 2 : 400).*wind( 2 : 400)/2;

U12 = RH( 2 : 400).*temp( 2 : 400)/2;
U11 = RH( 2 : 400).*RH( 2 : 400)/2;
U13 = RH( 2 : 400).*ISI( 2 : 400)/2;
U21 = U12;
U22 = temp( 2 : 400).*temp( 2 : 400)/2;
U23 = temp( 2 : 400).*ISI( 2 : 400)/2;
U31 = U13;
U32 = U23;
U33 = ISI( 2 : 400).*ISI( 2 : 400)/2;


R = [R11 R12 R13; R21 R22 R23; R31 R32 R33];
Rinv = pinv(R);
disp (Rinv);

T = [T11 T12 T13; T21 T22 T23; T31 T32 T33];
Tinv = pinv(T);
disp (Tinv);

U = [U11 U12 U13; U21 U22 U23; U31 U32 U33];
Uinv = pinv(U);
disp (Uinv);


R01 = FFMC( 2 : 400).*area1( 2 : 400)/2;
R02 = DMC( 2 : 400).*area1( 2 : 400)/2;
R03 = DC( 2 : 400).*area1( 2 : 400)/2;
R0 = [R01 ; R02 ; R03];
disp (R0);

T01 = ISI( 2 : 400).*area1( 2 : 400)/2;
T02 = temp( 2 : 400).*area1( 2 : 400)/2;
T03 = wind( 2 : 400).*area1( 2 : 400)/2;
T0 = [T01 ; T02 ; T03];
disp (T0);

U01 = RH( 2 : 400).*area1( 2 : 400)/2;
U02 = temp( 2 : 400).*area1( 2 : 400)/2;
U03 = ISI( 2 : 400).*area1( 2 : 400)/2;
U0 = [U01 ; U02 ; U03];
disp (U0);

A = Rinv * R0;
disp (A);

A1 = Tinv * T0;
disp (A1);

A2 = Uinv * U0;
disp (A2);

Y1 = (FFMC( 400 : 517).*A(1 , :)) + (DMC( 400 : 517).*A(2, :)) + (DC( 400 : 517).*A(3, :));
disp(Y1);

Y2 = (ISI( 400 : 517).*A1(1 , :)) + (temp( 400 : 517).*A1(2, :)) + (wind( 400 : 517).*A1(3, :));
disp(Y2);

Y3 = (RH( 400 : 517).*A2(1 , :)) + (temp( 400 : 517).*A2(2, :)) + (ISI( 400 : 517).*A2(3, :));
disp(Y3);

P = area1( 400 : 517) - Y1( :, 1);
Q = P.^2;
disp(Q);

P1 = area1( 400 : 517) - Y2( :, 1);
Q1 = P1.^2;
disp(Q1);

P2 = area1( 400 : 517) - Y3( :, 1);
Q2 = P2.^2;
disp(Q2);

S1 = mean (Q);
S2 = mean (Q1);
S3 = mean (Q2);

S = [S1, S2, S3];
stem (S,'r');
title('How MSE changes when different features are used for prediction');
xlabel('Input features combinations I have tried');
ylabel('MSE');
grid on;