function [ H ] = HomographyCalculator(  samples )
%HOMOGRAPHYCALCULATOR Summary of this function goes here
%   Detailed explanation goes here

ns = size(samples,3);% Total Samples
a= samples(:,2,:);
a = squeeze(a);
b= samples(:,1,:);
b = squeeze(b);
% xa = Top xb = Center
alpha =[b(1,:) ; b(2,:);ones(1,ns);zeros(1,ns);zeros(1,ns);zeros(1,ns); -b(1,:).*a(1,:) ; - b(2,:).*a(1,:); -a(1,:)];
beta = [zeros(1,ns) ; zeros(1,ns);zeros(1,ns); b(1,:);b(2,:);ones(1,ns); -b(1,:).*a(2,:);-b(2,:).*a(2,:); - a(2,:)];
Q = [alpha' ;beta'];
QQ = Q'*Q;
[T,E] = eig(sym(QQ));
Td = double(T);
Ed = double(E);
[minimumEigenValue,resultIndex] = min(diag(Ed));
Hv = Td(:,resultIndex);
H = reshape(Hv,3,3);
H = H';

end

