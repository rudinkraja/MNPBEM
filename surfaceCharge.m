addpath(genpath('MNPBEM17'));
%parpool('IdleTimeout', Inf);
clear
%%  electron beam
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'eels.refine', 2 );
%op.iter = bemiter.options;
%  table of dielectric functions
epstab  = { epsconst( 1 ), epstable( 'silver.dat' ) };
tic
diameter = 40;
gap = 2;
s = diameter + gap;
%number of elements( 32, 60, 144, 169, 225, 256 ... 1444)
elements = 144;
% rows (in the x direction)
n = 6;
% coluums (in the y direction)
m = 6;

pARRAY = cell(1, n * m);
eARRAY = zeros(n * m, 2);
bARRAY = zeros(1, n * m);

p0 = trisphere( elements, diameter);

w = 1;

%creating 2D structure
 for k = 0 : m - 1
     for i = 0 : n - 1
        my_field = strcat('v',num2str(k+1),num2str(i+1));
        p.(my_field) = shift( p0, [ s * i, s * k, 0 ] );
        pARRAY{w} = p.(my_field);
        eARRAY(w, 1) = 2;
        eARRAY(w, 2) = 1;
	bARRAY(1, w) = w;
        w = w + 1;
     end
 end
%  make particle
p = comparticle( epstab, { pARRAY{ 1, : } } , eARRAY , bARRAY, op );
toc

%%  BEM SOLVER
ene = 2.545
units;  enei = eV2nm ./ ene;
bem = bemsolver( p, op );
[ width, vel ] = deal( 1, eelsbase.ene2vel( 200e3 ) );
t = ( diameter+gap)/2;
%x3 = linspace( 0, ( n - 1 ) * t, ( n - 1 ) * t + 1 );
%y3 = linspace( -25, -25, ( n - 1 ) * t + 1 );
imp = [ -21, -21 ];
exc = electronbeam( p, imp, width, vel, op );
sig = bem \ exc( enei );

%% saving data

agArray6x6surfaceCharge_2_545_021_021 = real(sig.sig2);
save('agArray6x6surfaceCharge_2g_40d_2_545_-21x_-21y.mat', 'agArray6x6surfaceCharge_2_545_021_021','ene');

disp('fin');
quit
