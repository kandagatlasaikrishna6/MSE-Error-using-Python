clc;  % clear command window
clear all;   % clear workspace
close all;  % closes previous fig. windows
fileName = 'forestfires.xlsx';
a = xlsread(fileName);

R12 = a( :, 5).*a( :, 6)/2;
R11 = a( :, 5).*a( :, 5)/2;
R13 = a( :, 5).*a( :, 7)/2;
R21 = R12;
R22 = a( :, 6).*a( :, 6)/2;
R23 = a( :, 6).*a( :, 7)/2;
R31 = R13;
R32 = R23;
R33 = a( :, 7).*a( :, 7)/2;

T12 = a( :, 8).*a( :, 9)/2;
T11 = a( :, 8).*a( :, 8)/2;
T13 = a( :, 8).*a( :, 7)/2;
T21 = T12;
T22 = a( :, 9).*a( :, 9)/2;
T23 = a( :, 9).*a( :, 7)/2;
T31 = T13;
T32 = T23;
T33 = a( :, 7).*a( :, 7)/2;

U12 = a( :, 10).*a( :, 9)/2;
U11 = a( :, 10).*a( :, 10)/2;
U13 = a( :, 10).*a( :, 8)/2;
U21 = U12;
U22 = a( :, 9).*a( :, 9)/2;
U23 = a( :, 9).*a( :, 8)/2;
U31 = U13;
U32 = U23;
U33 = a( :, 8).*a( :, 8)/2;

R = [R11 R12 R13; R21 R22 R23; R31 R32 R33];
Rinv = pinv(R);
disp (Rinv);

T = [T11 T12 T13; T21 T22 T23; T31 T32 T33];
Tinv = pinv(T);
disp (Tinv);

U = [U11 U12 U13; U21 U22 U23; U31 U32 U33];
Uinv = pinv(U);
disp (Uinv);

R01 = a( :, 5).*a( :, 2)/2;
R02 = a( :, 6).*a( :, 2)/2;
R03 = a( :, 7).*a( :, 2)/2;
R0 = [R01 ; R02 ; R03];
disp (R0);

T01 = a( :, 8).*a( :, 2)/2;
T02 = a( :, 9).*a( :, 2)/2;
T03 = a( :, 7).*a( :, 2)/2;
T0 = [T01 ; T02 ; T03];
disp (T0);

U01 = a( :, 10).*a( :, 2)/2;
U02 = a( :, 9).*a( :, 2)/2;
U03 = a( :, 8).*a( :, 2)/2;
U0 = [U01 ; U02 ; U03];
disp (U0);

A = Rinv * R0;
disp (A);

A1 = Tinv * T0;
disp (A1);

A2 = Uinv * U0;
disp (A2);

Y1 = (a( :, 5).*A(1 , :)) + (a( :, 6).*A(2, :)) + (a( :, 7).*A(3, :));
disp(Y1);

Y2 = (a( :, 8).*A1(1 , :)) + (a( :, 9).*A1(2, :)) + (a( :, 7).*A1(3, :));
disp(Y2);

Y3 = (a( :, 10).*A2(1 , :)) + (a( :, 9).*A2(2, :)) + (a( :, 8).*A2(3, :));
disp(Y3);

P = a( :, 2) - Y1( :, 1);
Q = P.^2;
disp(Q);

P1 = a( :, 2) - Y2( :, 1);
Q1 = P1.^2;
disp(Q1);

P2 = a( :, 2) - Y3( :, 1);
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